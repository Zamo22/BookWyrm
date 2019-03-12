//
//  SearchViewModelTests.swift
//  BookWyrmTests
//
//  Created by Zaheer Moola on 2019/03/12.
//  Copyright © 2019 DVT. All rights reserved.
//

import XCTest
import OAuthSwift
@testable import BookWyrm

class MockSearchRepository: SearchRepositoring {
    var counter = 0
    
    weak var vModel: SearchViewModelling?
    
    func search(searchText: String) {
        var testResults: [SearchModel] = []
        testResults.append(SearchModel(title: "Test Book",
                                       authors: "Test Author",
                                       smallImageUrl: "www.smallpics.com",
                                       largeImageUrl: "www.pics.com",
                                       publishedDate: "01-01-2000",
                                       reviewInfo: "Test Book",
                                       isbn: "0123456789101",
                                       pageNumbers: "387",
                                       genres: "Testing, Software",
                                       description: "Test Description",
                                       webLink: "www.testbook.co.za"))
        testResults.append(SearchModel(title: "Test Book 2: More testing",
                                       authors: "Test Author",
                                       smallImageUrl: "www.smallpics.com",
                                       largeImageUrl: "www.pics.com",
                                       publishedDate: "01-02-2002",
                                       reviewInfo: "Test Book 2",
                                       isbn: "0123456789101",
                                       pageNumbers: "500",
                                       genres: "Testing, Software",
                                       description: "A sequel to Test Description",
                                       webLink: "www.testbook2.co.za"))
        
        vModel?.setResults(testResults)
    }
    
    func storedDetailsCheck() {
        counter += 1
    }
    
    func setViewModel(vModel: SearchViewModelling) {
        self.vModel = vModel
    }
    
    func reset() {
        counter = 0
    }
    
    func verifyNotReached() {
        XCTAssert(counter == 1)
    }
}

class MockSearchView: SearchResultsTableViewControllable {    
    
    func setResults(results: [SearchModel]) {
        XCTAssert(results[0].title == "Test Book")
        //Alternative to counter
    }
    
    func moveToDetailsPage(bookModel: SearchModel) {
        XCTAssert(bookModel.authors == "By: Test Author")
        XCTAssert(bookModel.publishedDate == "Date Published: 01-01-2000")
        XCTAssert(bookModel.pageNumbers == "Pages: 387")
        XCTAssert(bookModel.isbn == "ISBN_13: 0123456789101")
        XCTAssert(bookModel.genres == "Genres: Testing, Software" || bookModel.genres == "Genres: None Found")
    }
    
    
}

class SearchViewModelTests: XCTestCase {
    var serviceUnderTest: SearchViewModel? = nil
    var mockRepo = MockSearchRepository()
    var mockView = MockSearchView()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        mockRepo.reset()
    }
    
    func testResultCountIsCorrect() {
        serviceUnderTest = SearchViewModel(view: mockView, repo: mockRepo)
        var testResults: [SearchModel] = []
        testResults.append(SearchModel(title: "Test Book",
                                       authors: "Test Author",
                                       smallImageUrl: "www.smallpics.com",
                                       largeImageUrl: "www.pics.com",
                                       publishedDate: "01-01-2000",
                                       reviewInfo: "Test Book",
                                       isbn: "0123456789101",
                                       pageNumbers: "387",
                                       genres: "Testing, Software",
                                       description: "Test Description",
                                       webLink: "www.testbook.co.za"))
        testResults.append(SearchModel(title: "Test Book 2: More testing",
                                       authors: "Test Author",
                                       smallImageUrl: "www.smallpics.com",
                                       largeImageUrl: "www.pics.com",
                                       publishedDate: "01-02-2002",
                                       reviewInfo: "Test Book 2",
                                       isbn: "0123456789101",
                                       pageNumbers: "500",
                                       genres: "Testing, Software",
                                       description: "A sequel to Test Description",
                                       webLink: "www.testbook2.co.za"))
        
        XCTAssert(serviceUnderTest?.countResults(testResults) == 2)
    }
    
    func testSearchOnlyExecutesAfterSpecifiedTime() {
        serviceUnderTest = SearchViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.searchText(textToSearch: "test search")
        mockRepo.verifyNotReached()
    }
    
    func testSearchingSetsResults() {
        serviceUnderTest = SearchViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.previousRun = Date() - 2
        serviceUnderTest?.searchText(textToSearch: "test search")
    }
    
    //'Error out of range' test where?
    func testGettingDetailsForCellModifiesContent() {
        serviceUnderTest = SearchViewModel(view: mockView, repo: mockRepo)
        let fakeModel = SearchModel(title: "Test Book",
                                    authors: "Test Author",
                                    smallImageUrl: "www.smallpics.com",
                                    largeImageUrl: "www.pics.com",
                                    publishedDate: "01-01-2000",
                                    reviewInfo: "Test Book",
                                    isbn: "0123456789101",
                                    pageNumbers: "387",
                                    genres: "Testing, Software",
                                    description: "Test Description",
                                    webLink: "www.testbook.co.za")
        let newModel = serviceUnderTest?.detailsForCell(result: fakeModel)
        XCTAssert(newModel?.authors == "By: Test Author")
    }
    
    func testModifyingDataAndMovingToDetailsPage() {
        serviceUnderTest = SearchViewModel(view: mockView, repo: mockRepo)
        let fakeModel = SearchModel(title: "Test Book",
                                    authors: "Test Author",
                                    smallImageUrl: "www.smallpics.com",
                                    largeImageUrl: "www.pics.com",
                                    publishedDate: "01-01-2000",
                                    reviewInfo: "Test Book",
                                    isbn: "0123456789101",
                                    pageNumbers: "387",
                                    genres: "Testing, Software",
                                    description: "Test Description",
                                    webLink: "www.testbook.co.za")
        serviceUnderTest?.detailsForPage(result: fakeModel)
    }
    
    func testModifyingDataAndMovingToDetailsPageWithNoGenres() {
        serviceUnderTest = SearchViewModel(view: mockView, repo: mockRepo)
        let fakeModel = SearchModel(title: "Test Book",
                                    authors: "Test Author",
                                    smallImageUrl: "www.smallpics.com",
                                    largeImageUrl: "www.pics.com",
                                    publishedDate: "01-01-2000",
                                    reviewInfo: "Test Book",
                                    isbn: "0123456789101",
                                    pageNumbers: "387",
                                    genres: nil,
                                    description: "Test Description",
                                    webLink: "www.testbook.co.za")
        serviceUnderTest?.detailsForPage(result: fakeModel)
    }
    
    //Add nil view check here too
    func testGettingViewInstanceCorrectly() {
        serviceUnderTest = SearchViewModel(view: mockView, repo: mockRepo)
        XCTAssert(serviceUnderTest?.fetchView() != nil)
    }

}
