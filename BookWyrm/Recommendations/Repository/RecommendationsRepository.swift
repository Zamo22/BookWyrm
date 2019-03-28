//
//  RecommendationsRepository.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/25.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import OAuthSwift
import SWXMLHash
import SwiftyJSON

class RecommendationsRepository: RecommendationsRepositoring, RecommendationsRepositorable {
    
    var oauthswift: OAuthSwift?
    
    weak var vModel: RecommendationsViewModelling?
    lazy var goodreadsService: RecommendationsGoodreadsServicing = { return RecommendationsGoodreadsService(repo: self) }()
    lazy var tastediveService: RecommendationsTastediveServicing = {return RecommendationsTastediveService(repo: self) }()
    lazy var googleService: RecommendationsGoogleBooksServicing = {return RecommendationsGoogleBooksService(repo: self)}()
    
    //var recommendedList: [RecommendedBooksModel]?
    
    func setViewModel(vModel: RecommendationsViewModelling) {
        self.vModel = vModel
    }
    
    func getBookList() {
        goodreadsService.getBookList()
    }
    
    func parseBooklist(_ xml: XMLIndexer) {
        var books: [RecommendationsModel] = []
        //Change this to include if statement inside for loop to speed up process
        for elem in xml["GoodreadsResponse"]["reviews"]["review"].all {
            let model = RecommendationsModel(bookName: elem["book"]["title"].element!.text, bookRating: Int(elem["rating"].element!.text)!)
            books.append(model)
        }
        vModel?.filterBooks(bookList: books)
    }
    
    func errorAlert(_ error: String) {
        vModel?.errorAlert(error)
    }
    
    func getRecommendations(with list: [String]) {
        let stringList = list.joined(separator: ", ")
        tastediveService.getRecommendations(stringList)
    }
    
    func decodeResults(json: JSON?) {
        guard let results = json?["Similar"]["Results"].arrayValue else {
            return
        }
        var recommendedList: [RecommendedBooksModel] = []
        var counter = 0
        for result in results {
            let bookName = result["Name"].stringValue
            googleService.getBookData(bookName) { bookData in
                let model = RecommendedBooksModel(title: bookData["items"][0]["volumeInfo"]["title"].stringValue,
                                                  authors: bookData["items"][0]["volumeInfo"]["authors"][0].stringValue,
                                                  largeImageUrl: bookData["items"][0]["volumeInfo"]["imageLinks"]["smallThumbnail"].string ?? "",
                                                  id: bookData["items"][0]["id"].stringValue,
                                                  isbn: bookData["items"][0]["volumeInfo"]["industryIdentifiers"].arrayValue.first?["identifier"].stringValue ?? "")
                if model.title != "" {
                recommendedList.append(model)
                }
                
                counter += 1
                
                if counter == results.count {
                    self.vModel?.setBooksModel(recommendedList)
                }
                
            }
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
                goodreadsService.setToken(oauthS)
            }
        }
        
        let idKey = "userID"
        if preferences.object(forKey: idKey) != nil {
            guard let safeId = preferences.string(forKey: idKey) else {
                return
            }
            goodreadsService.setUserId(safeId)
        }
    }
    
}
