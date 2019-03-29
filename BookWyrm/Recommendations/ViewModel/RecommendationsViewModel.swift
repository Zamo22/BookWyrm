//
//  RecommendationsViewModel.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/25.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

class RecommendationsViewModel: RecommendationsViewModelling {
    
    weak var view: RecommendationsControllable?
    var repo: RecommendationsRepositoring?
    
    init(view: RecommendationsControllable, repo: RecommendationsRepositoring) {
        self.view = view
        self.repo = repo
        repo.setViewModel(vModel: self)
    }
    
    func fetchBookList() {
        repo?.getBookList()
    }
    
    func filterBooks(bookList: [RecommendationsModel]) {
        var highRatedBooks: [String] = []
        for book in bookList {
            if book.bookRating > 3 {
                let name = book.bookName.replacingOccurrences(of: "\\s?\\([^)]*\\)", with: "", options: .regularExpression)
                highRatedBooks.append(name)
            }
        }
        
        if !highRatedBooks.isEmpty {
            if highRatedBooks.count > 5 {
                let newBooks = highRatedBooks[randomPick: 5]
                repo?.getRecommendations(with: newBooks)
            } else {
                repo?.getRecommendations(with: highRatedBooks)
            }
        }
    }
    
    func setBook(_ bookInfo: RecommendedBooksModel) {
        
        let modifiedModel = SearchModel(title: bookInfo.title,
                                        authors: "By: \(bookInfo.authors)",
            smallImageUrl: "",
            largeImageUrl: bookInfo.largeImageUrl,
            publishedDate: "Date Published: \(bookInfo.publishedDay)-\(bookInfo.publishedMonth)-\(bookInfo.publishedYear)",
            reviewInfo: bookInfo.reviewInfo,
            isbn: "ISBN_13: \(bookInfo.isbn)",
            pageNumbers: "Pages: \(bookInfo.pageNumbers)",
            genres: nil,
            description: bookInfo.description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil),
            webLink: bookInfo.webLink)
        
        view?.moveToDetailsPage(modifiedModel)
    }
    
    func errorAlert(_ error: String) {
        if error == "error1" {
            view?.displayErrorPopup("Please check your internet connection and try again", "Network Error")
        } else if error == "error4" {
            view?.displayErrorPopup("Unable to obtain login token. Please restart the app", "Authentication Error")
        }
    }
    
    func setBooksModel(_ books: [RecommendedBooksModel]) {
        view?.setBooksModel(books)
    }
    
    func sendPopularBooksList(_ books: [RecommendedBooksModel]) {
        view?.setPopularBooksModel(books)
    }
    
}
