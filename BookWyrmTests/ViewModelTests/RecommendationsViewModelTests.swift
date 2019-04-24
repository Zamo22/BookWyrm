//
//  RecommendationsViewModelTests.swift
//  BookWyrmTests
//
//  Created by Zaheer Moola on 2019/03/25.
//  Copyright © 2019 DVT. All rights reserved.
//

import XCTest
@testable import BookWyrm

class MockRecommendationsView: RecommendationsControllable {
    var secondTest = false
    
    func setBooksModel(_ books: [RecommendedBooksModel]) {
        XCTAssert(books[0].title == "Test Book")
    }
    
    func setPopularBooksModel(_ books: [RecommendedBooksModel]) {
        XCTAssert(books[0].title == "Test Book 2")
    }
    
    func moveToDetailsPage(_ bookInfo: SearchModel) {
        XCTAssert(bookInfo.authors == "By: Test Author")
    }
    
    func displayErrorPopup(_ error: String, _ title: String) {
        if !secondTest {
            XCTAssert(error == "Please check your internet connection and try again" && title == "Network Error")
        } else {
            XCTAssert(error == "Unable to obtain login token. Please restart the app" && title == "Authentication Error")
        }
    }
    
    
}

class MockRecommendationsRepository: RecommendationsRepositoring {
    weak var vModel: RecommendationsViewModelling?
    var secondTest = false
    
    func setViewModel(vModel: RecommendationsViewModelling) {
        self.vModel = vModel
    }
    
    func getBookList() {
        if !secondTest {
            var fakeModel: [RecommendationsModel] = []
            fakeModel.append(RecommendationsModel(bookName: "Harry Potter", bookRating: 4))
            fakeModel.append(RecommendationsModel(bookName: "Percy Jackson", bookRating: 3))
            vModel?.filterBooks(bookList: fakeModel)
        } else {
            var fakeModel: [RecommendationsModel] = []
            fakeModel.append(RecommendationsModel(bookName: "Test Book 1", bookRating: 3))
            fakeModel.append(RecommendationsModel(bookName: "Test Book 2", bookRating: 4))
            fakeModel.append(RecommendationsModel(bookName: "Test Book 3", bookRating: 4))
            fakeModel.append(RecommendationsModel(bookName: "Test Book 4", bookRating: 1))
            fakeModel.append(RecommendationsModel(bookName: "Test Book 5", bookRating: 5))
            fakeModel.append(RecommendationsModel(bookName: "Test Book 6", bookRating: 4))
            fakeModel.append(RecommendationsModel(bookName: "Test Book 7", bookRating: 5))
            fakeModel.append(RecommendationsModel(bookName: "Test Book 8", bookRating: 2))
            fakeModel.append(RecommendationsModel(bookName: "Test Book 9", bookRating: 5))
            vModel?.filterBooks(bookList: fakeModel)
        }
    }
    
    func getRecommendations(with list: [String]) {
        if !secondTest {
            XCTAssert(list.count == 1)
        } else {
            XCTAssert(list.count == 5)
        }
        var books: [RecommendedBooksModel] = []
        books.append(RecommendedBooksModel(title: "Test Book", authors: "Test Author", largeImageUrl: "fakeurl.com", bookId: "123", isbn: "98765", description: "Fake Description of Book", publishedDay: "01", publishedMonth: "02", publishedYear: "2003", reviewInfo: "98765", webLink: "fakelink.co.za", pageNumbers: "99"))
        vModel?.setBooksModel(books)
        
        var popularBooks: [RecommendedBooksModel] = []
        popularBooks.append(RecommendedBooksModel(title: "Test Book 2", authors: "Test Author 2", largeImageUrl: "fakeurl2.com", bookId: "1234", isbn: "987654", description: "Fake Description of Book", publishedDay: "01", publishedMonth: "03", publishedYear: "1963", reviewInfo: "987654", webLink: "fakelink2.co.za", pageNumbers: "100"))
        vModel?.sendPopularBooksList(popularBooks)
    }
}

class RecommendationsViewModelTests: XCTestCase {
    
    var serviceUnderTest: RecommendationsViewModel?
    var mockRepo = MockRecommendationsRepository()
    var mockView = MockRecommendationsView()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        mockRepo.secondTest = false
    }

    func testFetchingBookListWithFewHighRatedBooksSetsBookArrays() {
        serviceUnderTest = RecommendationsViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.fetchBookList()
    }
    
    func testFetchingBookListWithManyHighRatedBooksRandomlyPicksBookAndSetsBookArrays() {
        serviceUnderTest = RecommendationsViewModel(view: mockView, repo: mockRepo)
        mockRepo.secondTest = true
        serviceUnderTest?.fetchBookList()
    }
    
    func testNetworkErrorDisplaysPopup() {
        serviceUnderTest = RecommendationsViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.errorAlert("error1")
    }
    
    func testTokenErrorDisplaysPopup() {
        serviceUnderTest = RecommendationsViewModel(view: mockView, repo: mockRepo)
        mockView.secondTest = true
        serviceUnderTest?.errorAlert("error4")
    }
    
    func testMovingToDetailsPageModifiesTextLayout() {
        serviceUnderTest = RecommendationsViewModel(view: mockView, repo: mockRepo)
        let model = RecommendedBooksModel(title: "Test Book", authors: "Test Author", largeImageUrl: "fakeurl.com", bookId: "123", isbn: "98765", description: "Fake Description of Book", publishedDay: "01", publishedMonth: "02", publishedYear: "2003", reviewInfo: "98765", webLink: "fakelink.co.za", pageNumbers: "99")
        serviceUnderTest?.setBook(model)
    }

}
