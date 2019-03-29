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
    func setBooksModel(_ books: [RecommendedBooksModel])
    func sendPopularBooksList(_ books: [RecommendedBooksModel])
    func setBook(_ bookInfo: RecommendedBooksModel)
}

protocol RecommendationsControllable: class {
    func setBooksModel(_ books: [RecommendedBooksModel])
    func setPopularBooksModel(_ books: [RecommendedBooksModel])
    func moveToDetailsPage(_ bookInfo: SearchModel)
}

protocol RecommendationsRepositoring {
    func setViewModel(vModel: RecommendationsViewModelling)
    func getBookList()
    func getRecommendations(with list: [String])
}

protocol RecommendationsGoodreadsServicing {
    func setToken(_ token: OAuthSwift)
    func setUserId(_ userId: String)
    func getBookList()
    func searchBook(isbnArray: [String])
    func searchBook(titleArray: [String])
}

protocol RecommendationsRepositorable: class {
    func getToken()
    func parseBooklist(_ xml: XMLIndexer)
    func errorAlert(_ error: String)
    func decodeResults(json: JSON?)
    func decodePopularResults(json: JSON?)
    func sendPopularBooksList(_ books: [RecommendedBooksModel])
    func sendBookList(_ books: [RecommendedBooksModel])
}

protocol RecommendationsTastediveServicing {
    func getRecommendations(_ list: String)
}

protocol RecommendationsGoogleBooksServicing {
    func getBookData(_ bookName: String, completionHandler: @escaping (JSON) -> Void)
}

protocol RecommendationsiDreamBooksServicing {
    func getPopularBooks()
}
