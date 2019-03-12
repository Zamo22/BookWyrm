//
//  DetailRepository.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/04.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import OAuthSwift
import SWXMLHash
import Alamofire
import AlamofireImage
import SwiftyJSON

class DetailRepository: DetailRepositoring {
    
    var oauthswift: OAuthSwift?
    var userId: String?
    
    weak var vModel: DetailViewModelling?
    func setViewModel(vModel: DetailViewModelling) {
        self.vModel = vModel
    }
    
    //Fail Check???
    func checkIfInList(callback: @escaping (_ books: [String], _ reviews: [String]) -> Void) {
        getToken()
        let oauthSwift: OAuth1Swift = oauthswift as! OAuth1Swift
        
        let preferences = UserDefaults.standard
        let idKey = "userID"
        
        if preferences.object(forKey: idKey) == nil {
            self.getGoodreadsUserID { id in
                self.userId = id
            }
        } else {
            userId = preferences.string(forKey: idKey)!
        }
        //Uses ID that was received to get a list of users books read
        _ = oauthSwift.client.request(
            "https://www.goodreads.com/review/list/\(userId!).xml?key=9VcjOWtKzmFGW8o91rxXg&v=2", method: .GET,
            success: { response in
                
                var books : [String] = []
                var reviews: [String] = []
                
                let dataString = response.string!
                let xml = SWXMLHash.parse(dataString)
                
                //Change this to include if statement inside for loop to speed up process
                for elem in xml["GoodreadsResponse"]["reviews"]["review"].all {
                    //Add book ID to array
                    books.append(elem["book"]["id"].element!.text)
                    reviews.append(elem["id"].element!.text)
                }
                
                callback(books, reviews)
                
        }, failure: { error in
            print(error)
        }
        )
    }
    
    func getUserId() -> String {
        return userId!
    }
    
    func postToShelf(params: [String: Any]) -> Bool {
        let oauthSwift: OAuth1Swift = oauthswift as! OAuth1Swift
        var succeeded = false
        
        _ = oauthSwift.client.post("https://www.goodreads.com/shelf/add_to_shelf.xml", parameters: params,
                                   success: { _ in
                                    succeeded = true },
                                   failure: {error in
                                    print(error)
        })
        
        return succeeded
    }
    
    func getBookID (reviewDetails: String) {
        getToken()
        let oauthSwift: OAuth1Swift = oauthswift as! OAuth1Swift
        
        let urlWithSpaces = "https://www.goodreads.com/search/index.xml?key=9VcjOWtKzmFGW8o91rxXg&q=\(reviewDetails)&search[title]"
        guard let url = urlWithSpaces.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        _ = oauthSwift.client.get(url,
                                  success: { response in
                                    let dataString = response.string!
                                    let xml = SWXMLHash.parse(dataString)
                                    
                                    guard let bookId = xml["GoodreadsResponse"]["search"]["results"]["work"][0]["best_book"]["id"].element?.text else {
                                        return
                                    }
                                    self.vModel?.setBookID(bookId)
                                    
            }, failure: { error in
                print(error)
        })
    }
    
    func getGoodreadsUserID(callback: @escaping (_ id: String) -> Void) {
        let oauthSwift: OAuth1Swift = oauthswift as! OAuth1Swift
        
        _ = oauthSwift.client.get(
            "https://www.goodreads.com/api/auth_user",
            success: { [weak self] response in
                
                /** parse the returned xml to read user id **/
                let dataString = response.string!
                let xml = SWXMLHash.parse(dataString)
                let userID  =  (xml["GoodreadsResponse"]["user"].element?.attribute(by: "id")?.text)!
                
                self?.userId = userID
                callback(userID)
                
            }, failure: { error in
                print(error)
        }
        )
        
    }
    
    func checkReviews(_ reviewData: String, completionHandler: @escaping (Bool, NetworkError) -> Void) {
        let urlWithSpaces = "https://idreambooks.com/api/books/reviews.json?q=\(reviewData)&key=64f959b1d802bf39f22b52e8114cace510662582"
        
        guard let url = urlWithSpaces.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            guard let data = response.data else {
                completionHandler(false, .failure)
                return
            }
            
            let json = try? JSON(data: data)
            let results = json?["book"]["critic_reviews"].arrayValue
            
            guard let empty = results?.isEmpty, !empty else {
                completionHandler(false, .failure)
                return
            }
            completionHandler(true, .success)
        }
    }

    func getToken() {
        let preferences = UserDefaults.standard
        let key = "oauth"
        if preferences.object(forKey: key) == nil {
            print("Error")
        } else {
            let decoded  = preferences.object(forKey: key) as! Data
            if let credential = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? OAuthSwiftCredential {
                let oauthS = OAuth1Swift(consumerKey: "9VcjOWtKzmFGW8o91rxXg",
                                         consumerSecret: "j7GVH7skvvgQRwLIJ7RGlEUVTN3QsrhoCt38VTno")
                oauthS.client.credential.oauthToken = credential.oauthToken
                oauthS.client.credential.oauthTokenSecret = credential.oauthTokenSecret
                oauthswift = oauthS
            }
        }
    }
}
