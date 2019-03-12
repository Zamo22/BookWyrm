//
//  ShelfViewModelTests.swift
//  BookWyrmTests
//
//  Created by Zaheer Moola on 2019/03/11.
//  Copyright © 2019 DVT. All rights reserved.
//

import XCTest
@testable import BookWyrm
@testable import ShelfView

class MockShelfView: PlainShelfControllable {
    func reloadData(_ bookModel: [BookModel]) {
        XCTAssert(bookModel[0].bookId == "123" && bookModel[1].bookTitle == "Test Book: The Sequel")
    }
    
    func moveToDetailsPage(_ bookInfo: SearchModel) {
        XCTAssert(bookInfo.publishedDate == "Date Published: 01-03-1999")
        XCTAssert(bookInfo.authors == "By: Test Author")
        XCTAssert(bookInfo.isbn == "ISBN_13: 0123456789101")
        XCTAssert(bookInfo.pageNumbers == "Pages: 22")
    }
}

class MockShelfRepository: ShelfRepositoring {
    weak var vModel: ShelfViewModelling?
    
    func searchBook(bookId: String) {
        let model =  ShelfModel(title: "Test Book",
                                authors: "Test Author",
                                largeImageUrl: "www.pics.com",
                                publishedDay: "01",
                                publishedMonth: "03",
                                publishedYear: "1999",
                                reviewInfo: "0123456789101",
                                isbn: "0123456789101",
                                pageNumbers: "22",
                                description: "Test Description",
                                webLink: "www.testbook.co.za")
        vModel?.setBook(model)
    }
    
    func getBookModel() {
        var books: [BookModel] = []
        books.append(BookModel(bookCoverSource: "www.pic.com", bookId: "123", bookTitle: "Test Book"))
        books.append(BookModel(bookCoverSource: "www.pic2.com", bookId: "124", bookTitle: "Test Book: The Sequel"))
        
        vModel?.setModel(books: books)
    }
    
    func setViewModel(vModel: ShelfViewModelling) {
        self.vModel = vModel
    }
    
}

class ShelfViewModelTests: XCTestCase {

    var serviceUnderTest: ShelfViewModel? = nil
    var mockRepo = MockShelfRepository()
    var mockView = MockShelfView()
    
    func testGettingModelAndReloadingBookShelf() {
        serviceUnderTest = ShelfViewModel(view: mockView, repo: mockRepo)
        _ = serviceUnderTest?.getModel()
    }
    
    func testGettingBookDetailsAndSettingIt() {
        serviceUnderTest = ShelfViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.getBook("123")
    }

}
