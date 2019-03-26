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
                highRatedBooks.append(book.bookName)
            }
        }
        
        if !highRatedBooks.isEmpty {
            if highRatedBooks.count > 5 {
                //Randomly select items
            } else {
                repo?.getRecommendations(with: highRatedBooks)
            }
        }
    }
    
    func errorAlert(_ error: String) {
        
    }
    
}