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

class MyReviewRepository: MyReviewRepositoring {
    
    var oauthswift: OAuthSwift?
    weak var vModel: MyReviewViewModelling?
    
    func setViewModel(vModel: MyReviewViewModelling) {
        self.vModel = vModel
    }
    
    //**needs to do something on failure
    func postReview(params: [String: Any]) {
        storedDetailsCheck()
        let oauthSwift: OAuth1Swift = oauthswift as! OAuth1Swift
        _ = oauthSwift.client.post("https://www.goodreads.com/review.xml", parameters: params,
                                   success: { _ in
                                    self.vModel?.closePage() },
                                   failure: {_ in
                                    self.vModel?.errorBuilder("error2")})
    }
    
    func editReview(params: [String: Any], _ reviewId: String) {
        storedDetailsCheck()
        let oauthSwift: OAuth1Swift = oauthswift as! OAuth1Swift
        _ = oauthSwift.client.post("https://www.goodreads.com/review/\(reviewId).xml", parameters: params,
                                   success: { _ in
                                    self.vModel?.closePage() },
                                   failure: {_ in
                                    self.vModel?.errorBuilder("error2") })
    }
    
    func getReview(reviewId: String) {
         let uiTesting = ProcessInfo.processInfo.arguments.contains("Testing")
        
        if !uiTesting {
            storedDetailsCheck()
            let oauthSwift: OAuth1Swift = oauthswift as! OAuth1Swift
            
            _ = oauthSwift.client.get(
                "https://www.goodreads.com/review/show.xml?id=\(reviewId)&key=9VcjOWtKzmFGW8o91rxXg",
                success: { response in
                    
                    /** parse the returned xml to read user id **/
                    guard let dataString = response.string else {
                        self.vModel?.errorBuilder("error3")
                        return
                    }
                    let xml = SWXMLHash.parse(dataString)
                    let review =  (xml["GoodreadsResponse"]["review"]["body"].element?.text)
                    let rating = (xml["GoodreadsResponse"]["review"]["rating"].element?.text)
                    
                    guard let safeReview = review else {
                        self.vModel?.errorBuilder("error3")
                        return
                    }
                    guard let safeRating = rating else {
                        self.vModel?.errorBuilder("error3")
                        return
                    }
                    self.vModel?.setReview(safeReview, safeRating)
                    
            }, failure: { _ in
                self.vModel?.errorBuilder("error1")
            }
            )
        }
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
