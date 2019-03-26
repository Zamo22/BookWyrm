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
    lazy var oauthService: RecommendationsOauthServicing = { return RecommendationsOauthService(repo: self) }()
    lazy var tastediveService: RecommendationsTastediveServicing = {return RecommendationsTastediveService(repo: self) }()
    
    func setViewModel(vModel: RecommendationsViewModelling) {
        self.vModel = vModel
    }
    
    func getBookList() {
        oauthService.getBookList()
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
        var nameArray: [String] = []
        for result in results {
            nameArray.append(result["Name"].stringValue)
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
                oauthService.setToken(oauthS)
            }
        }
        
        let idKey = "userID"
        if preferences.object(forKey: idKey) != nil {
            guard let safeId = preferences.string(forKey: idKey) else {
                return
            }
            oauthService.setUserId(safeId)
        }
    }
    
}
