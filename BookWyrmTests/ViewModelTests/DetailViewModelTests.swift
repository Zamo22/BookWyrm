//
//  DetailViewModelTests.swift
//  BookWyrmTests
//
//  Created by Zaheer Moola on 2019/03/12.
//  Copyright © 2019 DVT. All rights reserved.
//

import XCTest
@testable import BookWyrm

class MockDetailView: DetailViewControllable {
    var secondTest = false
    var errorTestNumber = 0
    
    func displayErrorPopup(_ error: String, _ title: String) {
        switch errorTestNumber {
        case 1:
            XCTAssert(error == "Please check your internet connection and try again" && title == "Network Error")
        case 2:
            XCTAssert(error == "Unable to add/remove item. Please try again later" && title == "Unsuccessful Operation")
        case 3:
            XCTAssert(error == "Could not find matching book on server. Please ensure you have a valid book version" && title == "Invalid Book")
        case 4:
            XCTAssert(error == "Unable to obtain login token. Please restart the app" && title == "Authentication Error")
        default:
            XCTAssert(false)
        }
    }
    
    func setReadStatus(read: Bool) {
        if secondTest {
            XCTAssert(!read)
        } else {
           XCTAssert(read)
        }
        
    }
    
    func setReviewVisibility(hasReviews: Bool) {
        if secondTest {
            XCTAssert(!hasReviews)
        } else {
            XCTAssert(hasReviews)
        }
    }
    
    func resetTestCheck() {
        secondTest = false
    }

}

class MockDetailRepository: DetailRepositoring {
    weak var vModel: DetailViewModelling?
    
    func setViewModel(vModel: DetailViewModelling) {
        self.vModel = vModel
    }
    
    func checkIfInList() {
        let books: [String] = ["1", "2", "5", "123"]
        let reviews: [String] = ["11", "22", "55", "123123"]
        vModel?.compareList(books, reviews)
    }
    
    func getBookID(reviewDetails: String) {
        if reviewDetails == "Read Book Information" {
            vModel?.setBookID("123")
        } else if reviewDetails == "Unread Book Information" {
            vModel?.setBookID("987")
        }
    }
    
    func postToShelf(params: [String: Any]) {
        if params["remove"] != nil {
            vModel?.setBookmarkStatus()
        } else {
            vModel?.setBookmarkStatus()
        }
    }
    
    func checkReviews(_ reviewData: String) {
        if reviewData == "Book Information" {
            vModel?.setReviewVisibility(hasReviews: true)
        } else if reviewData == "Obscure Book Information" {
            vModel?.setReviewVisibility(hasReviews: false)
        }
    }
    
    func getUserId() -> String {
        return "101"
    }
    
}

class DetailViewModelTests: XCTestCase {

    var serviceUnderTest: DetailViewModel?
    var mockRepo = MockDetailRepository()
    var mockView = MockDetailView()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
       mockView.resetTestCheck()
    }

    func testCheckingWhetherBookIsOnUsersBookShelfSetsStatusAsRead() {
        serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.checkIfInList("Read Book Information")
    }
    
    func testCheckingWhetherBookIsOnUsersBookShelfSetsStatusAsUnread() {
        serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        mockView.secondTest = true
        serviceUnderTest?.checkIfInList("Unread Book Information")
    }

    func testCheckingWhetherABookHasCriticReviewsShowsTheButtonIfItDoes() {
        serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.checkReviews("Book Information")
    }

    func testCheckingWhetherABookHasCriticReviewsHidesTheButtonIfItDoesnt() {
        serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        mockView.secondTest = true
        serviceUnderTest?.checkReviews("Obscure Book Information")
    }

    func testAddingABookToShelfAlsoChecksBookmarkButton() {
        serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.inList = true
        serviceUnderTest?.bookId = "123"
        serviceUnderTest?.modifyBookshelf()
    }

    func testRemovingABookFromShelfAlsoUnchecksBookmarkButton() {
        serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.inList = false
        serviceUnderTest?.bookId = "123"
        mockView.secondTest = true
        serviceUnderTest?.modifyBookshelf()
    }
    
    func testGettingModelFetchesUserIdAndConstructsModel() {
        serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.reviewId = "123"
        serviceUnderTest?.bookId = "987"
        let model = serviceUnderTest?.getModel()
        XCTAssert(model?.bookId == "987")
        XCTAssert(model?.reviewId == "123")
        XCTAssert(model?.userId == "101")
    }
    
    func testNetworkErrorShowsErrorAlert() {
        serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        mockView.errorTestNumber = 1
        serviceUnderTest?.errorAlert("error1")
    }
    
    func testErrorShownOnBeingUnableToModifyShelf() {
        serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        mockView.errorTestNumber = 2
        serviceUnderTest?.errorAlert("error2")
    }
    
    func testErrorShownOnNotBeingAbleToObtainValidBookId() {
        serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        mockView.errorTestNumber = 3
        serviceUnderTest?.errorAlert("error3")
    }
    
    func testErrorShownOnMissingOauthToken() {
        serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        mockView.errorTestNumber = 4
        serviceUnderTest?.errorAlert("error4")
    }

}
