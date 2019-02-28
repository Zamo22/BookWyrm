//
//  PlainShelfController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/19.
//  Copyright © 2019 DVT. All rights reserved.
//

import ShelfView
import OAuthSwift
import SWXMLHash
import SafariServices
import Alamofire
import SwiftyJSON

class PlainShelfController: UIViewController, PlainShelfViewDelegate {
    var shelfView: PlainShelfView!
    
    //Create the oAuth token(?) that we'll use to hold our authentication and make requests
    var oauthswift: OAuthSwift?
    var books: [BookModel] = []
    
    private let apiFetcher = APIRequestFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = UserDefaults.standard
        let currentOauthKey = "oauth"
        let idKey = "userID"
        if preferences.object(forKey: currentOauthKey) == nil {
            doOAuthGoodreads { token in
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: token.client.credential)
                preferences.set(encodedData, forKey: currentOauthKey)
            }
        } else {
            let decoded  = preferences.object(forKey: currentOauthKey) as! Data
            if let credential = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? OAuthSwiftCredential {
                let oauthS = OAuth1Swift(consumerKey: "9VcjOWtKzmFGW8o91rxXg",
                                         consumerSecret: "j7GVH7skvvgQRwLIJ7RGlEUVTN3QsrhoCt38VTno")
                oauthS.client.credential.oauthToken = credential.oauthToken
                oauthS.client.credential.oauthTokenSecret = credential.oauthTokenSecret
                self.oauthswift = oauthS
                
                var userId: String = ""
                if preferences.object(forKey: idKey) == nil {
                    self.testOauthGoodreads(oauthS) { id in
                        userId = id
                    }
                } else {
                    userId = preferences.string(forKey: idKey)!
                    
                }
                
                let oauthswift = oauthS
                //Uses ID that was received to get a list of users books read
                _ = oauthswift.client.request(
                    "https://www.goodreads.com/review/list/\(userId).xml?key=9VcjOWtKzmFGW8o91rxXg&v=2", method: .GET,
                    success: { response in
                        
                        let dataString = response.string!
                        let xml = SWXMLHash.parse(dataString)
                        
                        //Iterate over books that user has read
                        for elem in xml["GoodreadsResponse"]["reviews"]["review"].all {
                            //Add each book to books model
                            self.books.append(BookModel(bookCoverSource: elem["book"]["image_url"].element!.text,
                                                        bookId: elem["book"]["id"].element!.text,
                                                        bookTitle: elem["book"]["title"].element!.text))
                        }
                        //Reload shelfview with update book model
                        self.shelfView.reloadBooks(bookModel: self.books)
                        
                }, failure: { error in
                    print(error)
                }
                )
            }
        }
        
        //Create shelfview
        shelfView = PlainShelfView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
                                   bookModel: books, bookSource: PlainShelfView.BOOK_SOURCE_URL)
        shelfView.tag = 100
        
        shelfView.delegate = self
        self.view.addSubview(shelfView)
    }
    
    //Will Add code here
    func onBookClicked(_ shelfView: PlainShelfView, index: Int, bookId: String, bookTitle: String) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            apiFetcher.searchBook(bookId: bookId, completionHandler: { [weak self] xml, error in
                if case .failure = error {
                    return
                }
                
                if xml == nil {
                    return
                }
                
                vc.selectedTitle = xml!["GoodreadsResponse"]["book"]["title"].element?.text ?? ""
                vc.reviewDetailsToSend = xml!["GoodreadsResponse"]["book"]["isbn13"].element?.text
                vc.selectedAuthor = "By: \(xml!["GoodreadsResponse"]["book"]["authors"]["author"][0]["name"].element?.text ?? "")"
                vc.selectedPublishedDate = "Date Published: \(xml!["GoodreadsResponse"]["book"]["publication_day"].element?.text ?? "01")-\(xml!["GoodreadsResponse"]["book"]["publication_month"].element?.text ?? "01")-\(xml!["GoodreadsResponse"]["book"]["publication_year"].element?.text ?? "2000")"
                vc.selectedIsbn = "ISBN_13: \(xml!["GoodreadsResponse"]["book"]["isbn13"].element?.text ?? "")"
                vc.selectedNumPages = "Pages: \(xml!["GoodreadsResponse"]["book"]["num_pages"].element?.text ?? "0")"
                let str = xml!["GoodreadsResponse"]["book"]["description"].element?.text.removingPercentEncoding
                vc.selectedDescription = str!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                vc.oauthswift = self?.oauthswift
                vc.readingLink = xml!["GoodreadsResponse"]["book"]["link"].element?.text
                
                if let url =  xml!["GoodreadsResponse"]["book"]["image_url"].element?.text {
                    self?.apiFetcher.fetchImage(imageUrl: url, completionHandler: { image, _ in
                        vc.bookImageView.image = image
                    })
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })
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
            success: { credential, response, _ in
                self.oauthswift=oauthswift
                callback(oauthswift)
        },
            failure: { error in
                print( "ERROR ERROR: \(error.localizedDescription)", terminator: "")
        }
        )
    }
    
    //Runs an escaping method that fetches users ID
    func testOauthGoodreads(_ oauthswift: OAuth1Swift, callback: @escaping (_ id: String) -> Void) {
        _ = oauthswift.client.get(
            "https://www.goodreads.com/api/auth_user",
            success: { response in
                
                /** parse the returned xml to read user id **/
                let dataString = response.string!
                let xml = SWXMLHash.parse(dataString)
                let userID  =  (xml["GoodreadsResponse"]["user"].element?.attribute(by: "id")?.text)!
                callback(userID)
                
        }, failure: { error in
            print(error)
        }
        )
    }
    
    func getURLHandler() -> OAuthSwiftURLHandlerType {
        if #available(iOS 9.0, *) {
            let handler = SafariURLHandler(viewController: self, oauthSwift: self.oauthswift!)
            /* handler.presentCompletion = {
             print("Safari presented")
             }
             handler.dismissCompletion = {
             print("Safari dismissed")
             }*/
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
    //Handles removing current subview and
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        shelfView = PlainShelfView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
                                   bookModel: books, bookSource: PlainShelfView.BOOK_SOURCE_URL)
        shelfView.tag = 100
        self.view.addSubview(shelfView)
    }
}
