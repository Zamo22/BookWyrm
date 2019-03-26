//
//  RepositoryProtocols.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/25.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import OAuthSwift
import SWXMLHash
import SwiftyJSON

protocol RecommendationsViewModelling: class {
    func fetchBookList()
    func errorAlert(_ error: String)
    func filterBooks(bookList: [RecommendationsModel])
}

protocol RecommendationsControllable: class {
    
}

protocol RecommendationsRepositoring {
    func setViewModel(vModel: RecommendationsViewModelling)
    func getBookList()
    func getRecommendations(with list: [String])
}

protocol RecommendationsOauthServicing {
    func setToken(_ token: OAuthSwift)
    func setUserId(_ userId: String)
    func getBookList()
}

protocol RecommendationsRepositorable: class {
    func getToken()
    func parseBooklist(_ xml: XMLIndexer)
    func errorAlert(_ error: String)
    func decodeResults(json: JSON?)
}

protocol RecommendationsTastediveServicing {
    func getRecommendations(_ list: String)
}
