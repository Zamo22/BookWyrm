//
//  SearchProtocols.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/07.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import OAuthSwift

protocol SearchRepositoring {
    func search(searchText: String, completionHandler: @escaping ([SearchModel]?, NetworkError) -> Void)
    func getUserID(_ callback: @escaping (_ id: String) -> Void)
    func doOAuthGoodreads(callback: @escaping (_ token: OAuthSwift) -> Void)
    func storedDetailsCheck()
    func setViewModel(vModel: SearchViewModelling)
}

protocol SearchViewModelling: class {
    func storedDetailsCheck()
    func countResults(_ searchResults: [SearchModel]) -> Int
    func searchText(textToSearch: String)
    func detailsForCell(result: SearchModel) -> SearchModel 
    func detailsForPage(result: SearchModel) -> SearchModel 
    func fetchUrlHandler(oauthswift: OAuthSwift) -> OAuthSwiftURLHandlerType
}

protocol SearchResultsTableViewControllable: class {
    func getURLHandler(oSwift: OAuthSwift) -> OAuthSwiftURLHandlerType
    func setResults(results: [SearchModel]) 
}
