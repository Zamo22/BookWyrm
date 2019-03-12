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
    func search(searchText: String)
    func storedDetailsCheck()
    func setViewModel(vModel: SearchViewModelling)
}

protocol SearchViewModelling: class {
    func countResults(_ searchResults: [SearchModel]) -> Int
    func searchText(textToSearch: String)
    func detailsForCell(result: SearchModel) -> SearchModel 
    func detailsForPage(result: SearchModel)
    func fetchView() -> SearchResultsTableViewControllable
    func setResults(_ model: [SearchModel])
}

protocol SearchResultsTableViewControllable: class {
    func setResults(results: [SearchModel])
    func moveToDetailsPage(bookModel: SearchModel)
}
