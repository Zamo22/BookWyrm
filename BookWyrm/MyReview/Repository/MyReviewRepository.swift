//
//  MyReviewRepository.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/05.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import OAuthSwift
import SWXMLHash

protocol MyReviewRepositoring {
    func getReview(reviewId: String, callback: @escaping (_ review: String, _ rating: String) -> Void)
    func editReview(params: [String: Any], _ reviewId: String)
    func postReview(params: [String: Any]) 
}

class MyReviewRepository: MyReviewRepositoring {
    
    var oauthswift: OAuthSwift?
    
    func postReview(params: [String: Any]) {
        storedDetailsCheck()
        let oauthSwift : OAuth1Swift = oauthswift as! OAuth1Swift
        _ = oauthSwift.client.post("https://www.goodreads.com/review.xml", parameters: params,
                                   success: { response in
                                    },
                                   failure: {error in
                                    print(error)
        })
    }
    
    func editReview(params: [String: Any], _ reviewId: String) {
        storedDetailsCheck()
        let oauthSwift : OAuth1Swift = oauthswift as! OAuth1Swift
        _ = oauthSwift.client.post("https://www.goodreads.com/review/\(reviewId).xml", parameters: params,
                                   success: { _ in
                                    },
                                   failure: {error in
                                    print(error)
        })
    }
    
    func getReview(reviewId: String, callback: @escaping (_ review: String, _ rating: String) -> Void) {
        storedDetailsCheck()
        let oauthSwift : OAuth1Swift = oauthswift as! OAuth1Swift
        
        _ = oauthSwift.client.get(
            "https://www.goodreads.com/review/show.xml?id=\(reviewId)&key=9VcjOWtKzmFGW8o91rxXg",
            success: { response in
                
                /** parse the returned xml to read user id **/
                let dataString = response.string!
                let xml = SWXMLHash.parse(dataString)
                let review =  (xml["GoodreadsResponse"]["review"]["body"].element?.text)
                let rating = (xml["GoodreadsResponse"]["review"]["rating"].element?.text)
                
                callback(review!, rating!)
                
        }, failure: { error in
            print(error)
        }
        )
        
    }
    
    func storedDetailsCheck() {
        let preferences = UserDefaults.standard
        let currentOauthKey = "oauth"
        
        if preferences.object(forKey: currentOauthKey) != nil {
            let decoded  = preferences.object(forKey: currentOauthKey) as! Data
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
