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
    func checkIfInList() {
        getToken()
        let oauthSwift: OAuth1Swift = oauthswift as! OAuth1Swift
        
        let preferences = UserDefaults.standard
        let idKey = "userID"
        
        if preferences.object(forKey: idKey) != nil {
            guard let safeId = preferences.string(forKey: idKey) else {
                return
            }
            userId = safeId
        }
        //Uses ID that was received to get a list of users books read
        _ = oauthSwift.client.request(
            "https://www.goodreads.com/review/list/\(userId!).xml?key=9VcjOWtKzmFGW8o91rxXg&v=2", method: .GET,
            success: { response in
                
                var books : [String] = []
                var reviews: [String] = []
                
                guard let dataString = response.string else {
                    return
                }
                let xml = SWXMLHash.parse(dataString)
                
                //Change this to include if statement inside for loop to speed up process
                for elem in xml["GoodreadsResponse"]["reviews"]["review"].all {
                    //Add book ID to array
                    books.append(elem["book"]["id"].element!.text)
                    reviews.append(elem["id"].element!.text)
                }
                
                self.vModel?.compareList(books, reviews)
                
        }, failure: { _ in
            self.vModel?.errorAlert("error1")
        }
        )
    }
    
    func getUserId() -> String {
        guard let userID = userId else {
            return "error"
        }
        return userID
    }
    
    func postToShelf(params: [String: Any]) {
        let oauthSwift: OAuth1Swift = oauthswift as! OAuth1Swift
        
        _ = oauthSwift.client.post("https://www.goodreads.com/shelf/add_to_shelf.xml", parameters: params,
                                   success: { _ in
                                    self.vModel?.setBookmarkStatus()},
                                   failure: {_ in
                                    self.vModel?.errorAlert("error2")
        })
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
                                    guard let dataString = response.string else {
                                        self.vModel?.errorAlert("error3")
                                        return
                                    }
                                    let xml = SWXMLHash.parse(dataString)
                                    
                                    guard let bookId = xml["GoodreadsResponse"]["search"]["results"]["work"][0]["best_book"]["id"].element?.text else {
                                        self.vModel?.errorAlert("error3")
                                        return
                                    }
                                    self.vModel?.setBookID(bookId)
            }, failure: { _ in
                self.vModel?.errorAlert("error1")
        })
    }

    func checkReviews(_ reviewData: String) {
        let urlWithSpaces = "https://idreambooks.com/api/books/reviews.json?q=\(reviewData)&key=64f959b1d802bf39f22b52e8114cace510662582"
        
        guard let url = urlWithSpaces.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            guard let data = response.data else {
                self.vModel?.errorAlert("error1")
                return
            }

            let json = try? JSON(data: data)
            let results = json?["book"]["critic_reviews"].arrayValue
            
            guard let empty = results?.isEmpty, !empty else {
                self.vModel?.setReviewVisibility(hasReviews: false)
                return
            }
            self.vModel?.setReviewVisibility(hasReviews: true)
        }
    }

    func getToken() {
        let preferences = UserDefaults.standard
        let key = "oauth"
        if preferences.object(forKey: key) == nil {
            vModel?.errorAlert("error4")
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
