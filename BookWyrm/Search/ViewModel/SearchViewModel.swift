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
    var repo: SearchRepositoring?
    
    init(view: SearchResultsTableViewControllable, repo: SearchRepositoring) {
        self.view = view
        self.repo = repo
        repo.setViewModel(vModel: self)
    }
    
    //To avoid the search running constantly as we type
    private var previousRun = Date()
    
    func countResults(_ searchResults: [SearchModel]) -> Int {
        return searchResults.count
    }
    
    func searchText(textToSearch: String) {
        let minInterval = 0.1
        if Date().timeIntervalSince(previousRun) > minInterval {
            previousRun = Date()
            fetchResults(for: textToSearch)
        }
    }
    
    func detailsForCell(result: SearchModel) -> SearchModel {
        var model = result
        model.authors = "By: \(result.authors)"
        return model
    }
    
    func detailsForPage(result: SearchModel) -> SearchModel {
        var model = result
        model.authors = "By: \(model.authors)"
        model.publishedDate = "Date Published: \(model.publishedDate)"
        model.isbn = "ISBN_13: \(model.isbn)"
        model.pageNumbers = "Pages: \(model.pageNumbers)"
        model.genres = "Genres: \(model.genres ?? "")"
        return model
    }
    
    //Should go into repo
    func storedDetailsCheck() {
        repo?.storedDetailsCheck()
    }

    func fetchResults(for text: String) {
        repo?.search(searchText: text, completionHandler: { [weak self] results, error in
            if case .failure = error {
                return
            }
            guard let results = results, !results.isEmpty else {
                return
            }
            self?.view?.setResults(results: results)
        })
    }
    
    func fetchUrlHandler(oauthswift: OAuthSwift) -> OAuthSwiftURLHandlerType {
        return (view?.getURLHandler(oSwift: oauthswift))!
    }
}
