//
//  SearchRepository.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/28.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import OAuthSwift
import SWXMLHash
import SafariServices

class SearchRepository: SearchRepositoring {
    
    var oauthswift: OAuthSwift?
    
    weak var vModel: SearchViewModelling?
    func setViewModel(vModel: SearchViewModelling) {
        self.vModel = vModel
    }
    
    func search(searchText: String) {
        let urlToSearch = "https://www.googleapis.com/books/v1/volumes?q=\(searchText)&printType=books&AIzaSyCfP80tkDzTVuCI5jcUf_AfQixydJcHpOM"
        //Clean url to avoid errors from spaces
        guard let encodedUrlToSearch = urlToSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        Alamofire.request(encodedUrlToSearch).responseJSON { response in
            guard let data = response.data else {
                self.vModel?.errorBuilder("error1")
                return
            }
            
            let json = try? JSON(data: data)
            let results = json?["items"].arrayValue
            
            guard let safeResults = results else {
                return
            }
            
            var bookModel = [SearchModel]()
            for result in safeResults {
                let authors = result["volumeInfo"]["authors"].arrayValue
                var authorInfo = authors.first?.stringValue
                
                var skipFirst = true
                for author in authors {
                    if skipFirst {
                        skipFirst = false
                    } else {
                        authorInfo = "\(authorInfo ?? "") , \(author.stringValue)"
                    }
                }
                
                let genres =  result["volumeInfo"]["categories"].arrayValue
                var genreInfo = genres.first?.stringValue
                skipFirst = true
                
                for genre in genres {
                    if skipFirst {
                        skipFirst = false
                    } else {
                        genreInfo = "\(genreInfo ?? "") , \(genre.stringValue)"
                    }
                }
                
                bookModel.append(SearchModel(title: result["volumeInfo"]["title"].stringValue,
                                             authors: authorInfo ?? "",
                                             smallImageUrl: result["volumeInfo"]["imageLinks"]["smallThumbnail"].string ?? "",
                                             largeImageUrl: result["volumeInfo"]["imageLinks"]["thumbnail"].string ?? "",
                                 publishedDate: result["volumeInfo"]["publishedDate"].stringValue,
                                 reviewInfo: result["volumeInfo"]["title"].stringValue,
                                 isbn: result["volumeInfo"]["industryIdentifiers"].arrayValue.first?["identifier"].stringValue ?? "",
                                 pageNumbers: result["volumeInfo"]["pageCount"].stringValue,
                                 genres: genreInfo,
                                 description: result["volumeInfo"]["description"].stringValue.removingPercentEncoding ?? "",
                                 webLink: result["accessInfo"]["webReaderLink"].stringValue))
            }
            
            self.vModel?.setResults(bookModel)
        }
    }
    
    func doOAuthGoodreads(callback: @escaping (_ token: OAuthSwift) -> Void) {
        /** 1 . create an instance of OAuth1 **/
        let oauthswift = OAuth1Swift(
            consumerKey: "9VcjOWtKzmFGW8o91rxXg",
            consumerSecret: "j7GVH7skvvgQRwLIJ7RGlEUVTN3QsrhoCt38VTno",
            requestTokenUrl: "https://www.goodreads.com/oauth/request_token",
            authorizeUrl: "https://www.goodreads.com/oauth/authorize?mobile=1",
            accessTokenUrl: "https://www.goodreads.com/oauth/access_token"
        )
        
        self.oauthswift=oauthswift
        oauthswift.allowMissingOAuthVerifier = true
        oauthswift.authorizeURLHandler = getURLHandler()
        /** 2 . authorize with a redirect url **/
        _ = oauthswift.authorize(
            withCallbackURL: URL(string: "BookWyrm://oauth-callback/goodreads")!,
            success: { _, _, _ in //Credential is first param
                self.oauthswift = oauthswift
                callback(oauthswift)
        },
            failure: { error in
                self.vModel?.errorBuilder(error.localizedDescription)
        }
        )
    }
    
    func storedDetailsCheck() {
        let preferences = UserDefaults.standard
        let currentOauthKey = "oauth"
        let idKey = "userID"
        
        if preferences.object(forKey: currentOauthKey) == nil {
            doOAuthGoodreads { token in
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: token.client.credential)
                //let encodedData = NSKeyedArchiver.archivedData(withRootObject: token.client.credential, requiringSecureCoding: false)
                preferences.set(encodedData, forKey: currentOauthKey)
            }
        } else {
            let decoded  = preferences.object(forKey: currentOauthKey) as! Data
            if let credential = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? OAuthSwiftCredential {
                let oauthS = OAuth1Swift(consumerKey: "9VcjOWtKzmFGW8o91rxXg",
                                         consumerSecret: "j7GVH7skvvgQRwLIJ7RGlEUVTN3QsrhoCt38VTno")
                oauthS.client.credential.oauthToken = credential.oauthToken
                oauthS.client.credential.oauthTokenSecret = credential.oauthTokenSecret
                oauthswift = oauthS
            }
        }
        
        if preferences.object(forKey: idKey) == nil {
            getUserID { userId in
                preferences.set(userId, forKey: idKey)
            }
        }
    }
    
    func getURLHandler() -> OAuthSwiftURLHandlerType {
        if #available(iOS 9.0, *) {
            let handler = SafariURLHandler(viewController: vModel?.fetchView() as! UIViewController, oauthSwift: self.oauthswift!)
            handler.factory = { url in
                let controller = SFSafariViewController(url: url)
                // Customize it, for instance
                if #available(iOS 10.0, *) {
                    // controller.preferredBarTintColor = UIColor.red
                }
                return controller
            }
            
            return handler
        }
        return OAuthSwiftOpenURLExternally.sharedInstance
    }
    
    //Runs an escaping method that fetches users ID
    func getUserID(_ callback: @escaping (_ id: String) -> Void) {
        let oauthswift = self.oauthswift as! OAuth1Swift
        
        _ = oauthswift.client.get(
            "https://www.goodreads.com/api/auth_user",
            success: { response in
                /** parse the returned xml to read user id **/
                guard let dataString = response.string else {
                    return
                }
                let xml = SWXMLHash.parse(dataString)
                guard let userID  =  (xml["GoodreadsResponse"]["user"].element?.attribute(by: "id")?.text) else {
                    return
                }
                callback(userID)
                }, failure: { error in
                    self.vModel?.errorBuilder(error.localizedDescription)
                }
        )
    }
}
