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
    func setReviewInfo(review: ReviewModel) {
        if !thirdTest {
            XCTAssert(review.reviewerImageLink == "pic.image.com" && review.reviewerName == "NY Times")
        } else {
            XCTAssert(review.reviewerImageLink == "" && review.reviewerName == "Guardian")
        }
    }
    
    func setNewModel(model: ExtraDetailsModel) {
        if ratingTest {
            XCTAssert(model.avgRating == "4")
            XCTAssert(model.numReviews == "800K ratings")
        } else if ratingTest2 {
            XCTAssert(model.avgRating == "5")
            XCTAssert(model.numReviews == "2M ratings")
        }
        
    }
    
    var secondTest = false
    var thirdTest = false
    var ratingTest = false
    var ratingTest2 = false
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
        thirdTest = false
        ratingTest = false
        ratingTest2 = false
    }

}

class MockDetailRepository: DetailRepositoring {
    weak var vModel: DetailViewModelling?
    
    func setViewModel(vModel: DetailViewModelling) {
        self.vModel = vModel
    }
    
    var secondTest = false
    
    func checkIfInList() {
        let books: [String] = ["1", "2", "5", "123"]
        let reviews: [String] = ["11", "22", "55", "123123"]
        vModel?.compareList(books, reviews)
    }
    
    func getBookID(reviewDetails: String) {
        var similarBooksArray: [SimilarBook] = []
        similarBooksArray.append(SimilarBook(bookId: "1", imageLink: "pic.image.com", title: "Test", author: "Test Author", bookLink: "testbook.web.com", pages: "123", isbn: "987654321"))
        similarBooksArray.append(SimilarBook(bookId: "3", imageLink: "pic2.image.com", title: "Test2", author: "Test Author", bookLink: "testbook2.web.com", pages: "125", isbn: "987657321"))
        
        if reviewDetails == "Read Book Information" {
            vModel?.setBookID("123")
            let testExtraDetailsModel = ExtraDetailsModel(avgRating: "4", numReviews: "800000", yearPublished: "1999", publisher: "Test Publihser", details: "Some synopsis", similarBooks: similarBooksArray)
            vModel?.setRemainingDetails(model: testExtraDetailsModel)
        } else if reviewDetails == "Unread Book Information" {
            vModel?.setBookID("987")
             let testExtraDetailsModel = ExtraDetailsModel(avgRating: "4", numReviews: "900", yearPublished: "1999", publisher: "Test Publihser", details: "Some synopsis", similarBooks: similarBooksArray)
            vModel?.setRemainingDetails(model: testExtraDetailsModel)
        } else if reviewDetails == "Popular Book Information"{
            let testExtraDetailsModel = ExtraDetailsModel(avgRating: "5", numReviews: "2000000", yearPublished: "2009", publisher: "Famous Test Publihser", details: "Some synopsis", similarBooks: similarBooksArray)
            vModel?.setRemainingDetails(model: testExtraDetailsModel)
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
            var testReviewModel = ReviewModel(reviewerImageLink: "pic.image.com", reviewerName: "NY Times", rating: "3", review: "Great Book")
            if secondTest {
                testReviewModel = ReviewModel(reviewerImageLink: "", reviewerName: "Guardian", rating: "3", review: "Great Book")
            }
            vModel?.setFirstReview(review: testReviewModel)
        } else if reviewData == "Obscure Book Information" {
            vModel?.setReviewVisibility(hasReviews: false)
        }
    }
    
    func getUserId() -> String {
        return "101"
    }
    
    func resetTestCheck() {
        secondTest = false
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
        mockRepo.resetTestCheck()
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

    func testCheckingWhetherABookHasCriticReviewsAndShowsReviewWithOwnImage() {
        serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.checkReviews("Book Information")
    }
    
    func testCheckingWhetherABookHasCriticReviewsAndShowsReviewWithDefaultImage() {
        serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        mockRepo.secondTest = true
        mockView.thirdTest = true
        serviceUnderTest?.checkReviews("Book Information")
    }

    func testCheckingWhetherABookHasCriticReviewsHidesTheButtonIfItDoesnt() {
        serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        mockView.secondTest = true
        serviceUnderTest?.checkReviews("Obscure Book Information")
    }

    func testAddingABookToShelfAlsoChecksBookmarkButton() {
        serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.inList = false
        serviceUnderTest?.bookId = "123"
        serviceUnderTest?.modifyBookshelf()
    }

    func testRemovingABookFromShelfAlsoUnchecksBookmarkButton() {
        serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.inList = true
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
    
    func testBookWithLargeNumberOfReviewGetsFormattedCorrectlyToThousand() {
         serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        mockView.ratingTest = true
        serviceUnderTest?.checkIfInList("Read Book Information")
    }
    
    func testBookWithLargeNumberOfReviewGetsFormattedCorrectlyToMillion() {
        serviceUnderTest = DetailViewModel(view: mockView, repo: mockRepo)
        mockView.ratingTest2 = true
        serviceUnderTest?.checkIfInList("Popular Book Information")
    }
}
