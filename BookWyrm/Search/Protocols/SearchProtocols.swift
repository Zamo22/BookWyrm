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
    func getToken() -> OAuthSwift
}

protocol SearchViewModelling {
    func storedDetailsCheck()
    func emptyResults()
    func countResults() -> Int
    func searchText(textToSearch: String)
    func detailsForCell(position: Int) -> SearchModel
    func detailsForPage(position: Int) -> SearchModel
    func getToken() -> OAuthSwift
}

protocol SearchResultsTableViewControllable: class {
    func reloadData()
}
