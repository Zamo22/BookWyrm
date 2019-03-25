//
//  RecommendationsOauthService.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/25.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import SWXMLHash
import OAuthSwift

class RecommendationsOauthService: RecommendationsOauthServicing {
    
    weak var repo: RecommendationsRepositorable?
    var oauthswift: OAuthSwift?
    var userId: String?
    
    init(repo: RecommendationsRepositorable) {
        self.repo = repo
    }
    
    func setToken(_ token: OAuthSwift) {
        oauthswift = token
    }
    
    func setUserId(_ userId: String) {
        self.userId = userId
    }
    
    func getBookList() {
        let uiTesting = ProcessInfo.processInfo.arguments.contains("Testing")
        
        if uiTesting {
            if let path = Bundle.main.path(forResource: "Book_List", ofType: "xml") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    let xml = SWXMLHash.parse(data)
                    repo?.parseBooklist(xml)
                } catch let error {
                    print("parse error: \(error.localizedDescription)")
                }
            } else {
                print("Invalid filename/path.")
            }
        } else {
            repo?.getToken()
            let oauthSwift: OAuth1Swift = oauthswift as! OAuth1Swift
            //Uses ID that was received to get a list of users books read
            _ = oauthSwift.client.request(
                "https://www.goodreads.com/review/list/\(userId ?? "123").xml?key=9VcjOWtKzmFGW8o91rxXg&v=2", method: .GET,
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
    }
}
