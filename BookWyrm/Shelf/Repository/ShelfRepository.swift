//
//  ShelfRepository.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/04.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import OAuthSwift
import SWXMLHash
import Alamofire
import ShelfView

class ShelfRepository: ShelfRepositoring {
    
    var oauthswift: OAuthSwift?
    var userId: String?
    
    func getBookModel(callback: @escaping (_ books: [BookModel]) -> Void) {
        storedDetailsCheck()
        let oauthSwift = self.oauthswift as! OAuth1Swift
        
        guard let userID = userId else {
            return
        }
        
        _ = oauthSwift.client.request(
            "https://www.goodreads.com/review/list/\(userID).xml?key=9VcjOWtKzmFGW8o91rxXg&v=2", method: .GET,
            success: { response in
                
                let dataString = response.string!
                let xml = SWXMLHash.parse(dataString)
                var books: [BookModel] = []
                
                //Iterate over books that user has read
                for elem in xml["GoodreadsResponse"]["reviews"]["review"].all {
                    //Add each book to books model
                    books.append(BookModel(bookCoverSource: elem["book"]["image_url"].element!.text,
                                                bookId: elem["book"]["id"].element!.text,
                                                bookTitle: elem["book"]["title"].element!.text))
                }
                
                callback(books)
                
        }, failure: { error in
            print(error)
        }
        )
    }
    
    func storedDetailsCheck() {
        let preferences = UserDefaults.standard
        let currentOauthKey = "oauth"
        let idKey = "userID"
        
        if preferences.object(forKey: currentOauthKey) == nil {
            //Maybe add auth check here too
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
        
        if preferences.object(forKey: idKey) != nil {
            userId = preferences.string(forKey: idKey)!
        }
    }
    
    func searchBook(bookId: String, completionHandler: @escaping (ShelfModel?, NetworkError) -> Void) {
        let url = "https://www.goodreads.com/book/show/\(bookId)?key=9VcjOWtKzmFGW8o91rxXg"
        Alamofire.request(url, method: .get).response { response in
            
            guard let data = response.data else {
                completionHandler(nil, .failure)
                return
            }
            //Add another guard
            let xml = SWXMLHash.parse(data)
            
            //return author as an array here and parse it in the view model
            var detailModel = ShelfModel(title: xml["GoodreadsResponse"]["book"]["title"].element?.text ?? "",
                                         authors: xml["GoodreadsResponse"]["book"]["authors"]["author"][0]["name"].element?.text ?? "",
                                         largeImageUrl: xml["GoodreadsResponse"]["book"]["image_url"].element?.text ?? "",
                                         publishedDay: xml["GoodreadsResponse"]["book"]["publication_day"].element?.text ?? "01",
                                         publishedMonth: xml["GoodreadsResponse"]["book"]["publication_month"].element?.text ?? "01",
                                         publishedYear: xml["GoodreadsResponse"]["book"]["publication_year"].element?.text ?? "2000",
                                         reviewInfo: xml["GoodreadsResponse"]["book"]["isbn13"].element?.text ?? "",
                                         isbn: xml["GoodreadsResponse"]["book"]["isbn13"].element?.text ?? "",
                                         pageNumbers: xml["GoodreadsResponse"]["book"]["num_pages"].element?.text ?? "",
                                         description: xml["GoodreadsResponse"]["book"]["description"].element?.text.removingPercentEncoding ?? "",
                                         webLink: xml["GoodreadsResponse"]["book"]["link"].element?.text ?? "")
            completionHandler(detailModel, .success)
            
        }
    }
}
