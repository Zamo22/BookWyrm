//
//  SearchProtocols.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/07.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import OAuthSwift
import SwiftyJSON

protocol SearchRepositoring {
    func search(searchText: String)
    func storedDetailsCheck()
    func setViewModel(vModel: SearchViewModelling)
}

protocol SearchRepositorable: class {
    func decodeResults(json: JSON?)
    func errorBuilder(_ error: String)
}

protocol SearchViewModelling: class {
    func countResults(_ searchResults: [SearchModel]) -> Int
    func searchText(textToSearch: String)
    func detailsForCell(result: SearchModel) -> SearchModel
    func detailsForPage(result: SearchModel)
    func fetchView() -> SearchResultsTableViewControllable
    func setResults(_ model: [SearchModel])
    func errorBuilder(_ error: String)
}

protocol SearchResultsTableViewControllable: class {
    func setResults(results: [SearchModel])
    func moveToDetailsPage(bookModel: SearchModel)
    func displayErrorPopup(_ error: String, _ title: String)
}

protocol SearchAlamofireServicing {
    func getSearchResults(_ searchText: String)
}
