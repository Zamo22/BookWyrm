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
    func searchBook(bookId: String, completionHandler: @escaping (ShelfModel?, NetworkError) -> Void)
    func getBookModel(callback: @escaping (_ books: [BookModel]) -> Void)
}

protocol ShelfViewModelling {
    func getModel() -> [BookModel]
    func getBook(_ bookId: String, callback: @escaping (SearchModel?, NetworkError) -> Void)
}

protocol PlainShelfControllable: class {
    func reloadData(_ bookModel: [BookModel])
}
