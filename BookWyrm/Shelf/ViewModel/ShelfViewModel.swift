//
//  ShelfViewModel.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/04.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import ShelfView

class ShelfViewModel: ShelfViewModelling {
    
    var books: [BookModel] = []
    var repo: ShelfRepositoring?
    
    weak var view: PlainShelfControllable?
    
    init(view: PlainShelfControllable, repo: ShelfRepositoring) {
        self.view = view
        self.repo = repo
        repo.setViewModel(vModel: self)
    }
    
    func getModel() -> [BookModel] {
        if books.isEmpty {
            repo?.getBookModel()
        }
        return books
    }
    
    func setModel(books: [BookModel]) {
        self.books = books
        self.view?.reloadData(self.books)
    }
    
    func getBook(_ bookId: String) {
        repo?.searchBook(bookId: bookId)
    }
    
    func setBook(_ bookInfo: ShelfModel) {
        
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
}
