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
        repo.storedDetailsCheck()
    }
    
    //To avoid the search running constantly as we type
    var previousRun = Date()

    func countResults(_ searchResults: [SearchModel]) -> Int {
        return searchResults.count
    }
    
    func searchText(textToSearch: String) {
        let minInterval = 0.7
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
    
    func detailsForPage(result: SearchModel) {
        var model = result
        model.authors = "By: \(model.authors)"
        model.publishedDate = "Date Published: \(model.publishedDate)"
        model.isbn = "ISBN_13: \(model.isbn)"
        model.pageNumbers = "Pages: \(model.pageNumbers)"
        model.genres = "Genres: \(model.genres ?? "None Found")"
        view?.moveToDetailsPage(bookModel: model)
    }
    
    func fetchResults(for text: String) {
        repo?.search(searchText: text)
    }
    
    func setResults(_ model: [SearchModel]) {
        self.view?.setResults(results: model)
    }
    
    func fetchView() -> SearchResultsTableViewControllable {
        if let view = view {
            return view
        } else {
            return SearchResultsTableViewController()
        }
    }
    
    func errorBuilder(_ error: String) {
        if error == "error1" {
            view?.displayErrorPopup("Error fetching results. Please check your network connection and try again", "Network Error")
        } else {
            view?.displayErrorPopup(error, "Authentication Error")
        }
    }
}
