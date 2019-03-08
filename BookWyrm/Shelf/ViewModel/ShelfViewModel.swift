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
    let repo: ShelfRepositoring = ShelfRepository()
    
    weak var view: PlainShelfControllable?
    
    init(view: PlainShelfControllable) {
        self.view = view
    }
    
    func getModel() -> [BookModel] {
        if books.isEmpty {
            repo.getBookModel { bookArray in
                self.books = bookArray
                self.view?.reloadData(self.books)
            }
        }
        return books
    }
   
    func getBook(_ bookId: String, callback: @escaping (SearchModel?, NetworkError) -> Void) {
        repo.searchBook(bookId: bookId) { bookInfo, error in
            let modifiedModel = SearchModel(title: bookInfo?.title ?? "",
                                            authors: "By: \(bookInfo?.authors ?? "")",
                                            smallImageUrl: "",
                                            largeImageUrl: bookInfo?.largeImageUrl ?? "",
                                            publishedDate: "Date Published: \(bookInfo?.publishedDay ?? "")-\(bookInfo?.publishedMonth ?? "")-\(bookInfo?.publishedYear ?? "")",
                                            reviewInfo: bookInfo?.reviewInfo ?? "",
                                            isbn: "ISBN_13: \(bookInfo?.isbn ?? "")",
                                            pageNumbers: "Pages: \(bookInfo?.pageNumbers ?? "")",
                                            genres: nil,
                                            description: bookInfo?.description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) ?? "",
                                            webLink: bookInfo?.webLink ?? "")
            
            callback(modifiedModel, error)
        }
    }
}
