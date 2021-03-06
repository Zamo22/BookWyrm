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
    lazy var backendService: RecommendationsBackendServicing = {return RecommendationsBackendService(repo: self)}()
    
    //var recommendedList: [RecommendedBooksModel]?
    
    func setViewModel(vModel: RecommendationsViewModelling) {
        self.vModel = vModel
    }
    
    func getBookList() {
        goodreadsService.getBookList()
        backendService.getPopularBooks()
    }
    
    func parseBooklist(_ xml: XMLIndexer) {
        var books: [RecommendationsModel] = []
        //Change this to include if statement inside for loop to speed up process
        for elem in xml["GoodreadsResponse"]["reviews"]["review"].all {
            let model = RecommendationsModel(bookName: elem["book"]["title"].element!.text, bookRating: Int(elem["rating"].element!.text)!)
            books.append(model)
        }
        if books.isEmpty {
            vModel?.errorAlert("error2")
        } else {
            vModel?.filterBooks(bookList: books)
        }
    }
    
    func errorAlert(_ error: String) {
        vModel?.errorAlert(error)
    }
    
    func getRecommendations(with list: [String]) {
        let stringList = list.joined(separator: ", ")
        tastediveService.getRecommendations(stringList)
    }
    
    func decodeBackendPopularResults(json: JSON?) {
        guard let results = json?["isbnArray"].arrayValue else {
            return
        }
        var isbnArray: [String] = []
        for result in results {
            isbnArray.append(result.stringValue)
        }
        goodreadsService.searchBook(isbnArray: isbnArray)
    }
    
    func sendPopularBooksList(_ books: [RecommendedBooksModel]) {
        vModel?.sendPopularBooksList(books)
    }
    
    func sendBookList(_ books: [RecommendedBooksModel]) {
        vModel?.setBooksModel(books)
    }
    
    func decodeResults(json: JSON?) {
        guard let results = json?["Similar"]["Results"].arrayValue else {
            return
        }
        
        var nameList: [String] = []
        for result in results {
            let bookName = result["Name"].stringValue
            nameList.append(bookName)
        }
        goodreadsService.searchBook(titleArray: nameList)
    }
    
    func getToken() {
        let preferences = UserDefaults.standard
        let key = "oauth"
        if preferences.object(forKey: key) == nil {
            vModel?.errorAlert("error4")
        } else {
            let decoded  = preferences.object(forKey: key) as! Data
            guard let goodreadsKey = Bundle.main.object(forInfoDictionaryKey: "Goodreads_Key") as? String else {
                return
            }
            guard let goodreadsSecret = Bundle.main.object(forInfoDictionaryKey: "Goodreads_Secret") as? String else {
                return
            }
            if let credential = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? OAuthSwiftCredential {
                let oauthS = OAuth1Swift(consumerKey: goodreadsKey,
                                         consumerSecret: goodreadsSecret)
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
