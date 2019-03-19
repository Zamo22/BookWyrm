//
//  DetailsOAuthswiftService.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/19.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import OAuthSwift
import SWXMLHash

class DetailsOAuthswiftService: DetailsOAuthswiftServicing {
    weak var repo: DetailRepositorable?
    var oauthswift: OAuthSwift?
    
    init(repo: DetailRepositorable) {
        self.repo = repo
    }
    
    func setToken(_ token: OAuthSwift) {
        oauthswift = token
    }
    
    func getBookList() {
        let oauthSwift: OAuth1Swift = oauthswift as! OAuth1Swift
        guard let userId = repo?.getUserId() else {
            return
        }
        //Uses ID that was received to get a list of users books read
        _ = oauthSwift.client.request(
            "https://www.goodreads.com/review/list/\(userId).xml?key=9VcjOWtKzmFGW8o91rxXg&v=2", method: .GET,
            success: { response in
                
                guard let dataString = response.string else {
                    return
                }
                let xml = SWXMLHash.parse(dataString)
                self.repo?.parseBooklist(xml)
        }, failure: { _ in
            self.repo?.errorAlert("error1")
        }
        )
    }
    
    func getBookData(_ reviewDetails: String) {
        repo?.getToken()
        let oauthSwift: OAuth1Swift = oauthswift as! OAuth1Swift
        
        let urlWithSpaces = "https://www.goodreads.com/search/index.xml?key=9VcjOWtKzmFGW8o91rxXg&q=\(reviewDetails)&search[title]"
        guard let url = urlWithSpaces.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        _ = oauthSwift.client.get(url,
                                  success: { response in
                                    guard let dataString = response.string else {
                                        self.repo?.errorAlert("error3")
                                        return
                                    }
                                    let xml = SWXMLHash.parse(dataString)
                                    self.repo?.parseBookDetails(xml)
        }, failure: { _ in
            self.repo?.errorAlert("error1")
        })
    }
    
    func postToShelf(params: [String: Any]) {
        let oauthSwift: OAuth1Swift = oauthswift as! OAuth1Swift
        
        _ = oauthSwift.client.post("https://www.goodreads.com/shelf/add_to_shelf.xml", parameters: params,
                                   success: { _ in
                                    self.repo?.setBookmarkStatus()},
                                   failure: {_ in
                                    self.repo?.errorAlert("error2")
        })
    }
}
