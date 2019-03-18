//
//  ShelfProtocols.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/07.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import ShelfView

protocol ShelfRepositoring {
    func searchBook(bookId: String)
    func getBookModel()
    func setViewModel(vModel: ShelfViewModelling)
}

protocol ShelfViewModelling: class {
    func getModel() -> [BookModel]
    func getBook(_ bookId: String)
    func setModel(books: [BookModel])
    func setBook(_ bookInfo: ShelfModel)
    func errorBuilder(_ error: String)
}

protocol PlainShelfControllable: class {
    func reloadData(_ bookModel: [BookModel])
    func moveToDetailsPage(_ bookInfo: SearchModel)
    func displayErrorPopup(_ error: String, _ title: String)
}
