//
//  SearchViewModel.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/28.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import OAuthSwift

class SearchViewModel: SearchViewModelling {
    
    weak var view: SearchResultsTableViewControllable?
    
    init(view: SearchResultsTableViewControllable) {
        self.view = view
    }
    
    private var searchResults = [SearchModel]() {
        didSet {
            view?.reloadData()
        }
    }
    
    lazy var repo: SearchRepositoring = { return SearchRepository(view: self.view!) }()
    
    //To avoid the search running constantly as we type
    private var previousRun = Date()
    
    func emptyResults() {
        searchResults.removeAll()
    }
    
    func countResults() -> Int {
        return searchResults.count
    }
    
    func searchText(textToSearch: String) {
        let minInterval = 0.05
        if Date().timeIntervalSince(previousRun) > minInterval {
            previousRun = Date()
            fetchResults(for: textToSearch)
        }
    }
    
    func detailsForCell(position: Int) -> SearchModel {
        var quickSearchModel = searchResults[position]
        quickSearchModel.authors = "By: \(quickSearchModel.authors)"
        return quickSearchModel
    }
    
    func detailsForPage(position: Int) -> SearchModel {
        var model = searchResults[position]
        model.authors = "By: \(model.authors)"
        model.publishedDate = "Date Published: \(model.publishedDate)"
        model.isbn = "ISBN_13: \(model.isbn)"
        model.pageNumbers = "Pages: \(model.pageNumbers)"
        model.genres = "Genres: \(model.genres ?? "")"
        return model
    }
    
    func getToken() -> OAuthSwift {
        return repo.getToken()
    }
    
    //Should go into repo
    func storedDetailsCheck() {
        repo.storedDetailsCheck()
    }

    func fetchResults(for text: String) {
        repo.search(searchText: text, completionHandler: { [weak self] results, error in
            if case .failure = error {
                return
            }
            guard let results = results, !results.isEmpty else {
                return
            }
            self?.searchResults = results
        })
    }
}
