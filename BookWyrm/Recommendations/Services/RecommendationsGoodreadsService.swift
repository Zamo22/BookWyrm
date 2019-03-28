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
import Alamofire

class RecommendationsGoodreadsService: RecommendationsGoodreadsServicing {
    
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
    
    func searchBook(isbnArray: [String]) {
        var recommendedModel: [RecommendedBooksModel] = []
        var count = 0
        for isbn in isbnArray {
            let url = "https://www.goodreads.com/book/isbn/\(isbn)?key=9VcjOWtKzmFGW8o91rxXg"
            Alamofire.request(url, method: .get).response { response in
                
                //Check error message
                guard let data = response.data else {
                    self.repo?.errorAlert("error4")
                    return
                }
                //Add another guard
                let xml = SWXMLHash.parse(data)
                
                //return author as an array here and parse it in the view model
                let model = RecommendedBooksModel(title: xml["GoodreadsResponse"]["book"]["title"].element?.text ?? "",
                                             authors: xml["GoodreadsResponse"]["book"]["authors"]["author"][0]["name"].element?.text ?? "",
                                             largeImageUrl: xml["GoodreadsResponse"]["book"]["image_url"].element?.text ?? "", 
                                             id:  xml["GoodreadsResponse"]["book"]["id"].element?.text ?? "",
                                             isbn: xml["GoodreadsResponse"]["book"]["isbn13"].element?.text ?? "")
                
                count += 1
                recommendedModel.append(model)
                if count == isbnArray.count {
                    //self.repo.sendPopularBookList()
                }
                
            }
        }
    }
}
