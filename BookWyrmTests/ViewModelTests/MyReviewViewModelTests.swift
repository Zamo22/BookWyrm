//
//  MyReviewViewModelTests.swift
//  BookWyrmTests
//
//  Created by Zaheer Moola on 2019/03/11.
//  Copyright © 2019 DVT. All rights reserved.
//

import XCTest
@testable import BookWyrm

class MockMyReviewRepository: MyReviewRepositoring {
    weak var vModel: MyReviewViewModelling?
    
    func getReview(reviewId: String) {
        if (reviewId == "123") {
            vModel?.setReview("Good Book", "4")
        }
    }
    
    func editReview(params: [String : Any], _ reviewId: String) {
        let review = params["review[review]"] as! String
        let rating = params["review[rating]"] as! Double
        
        XCTAssert(review == "Ending was terrible" && rating == 2 && reviewId == "987")
        vModel?.closePage()
    }
    
    func postReview(params: [String : Any]) {
        let bookId = params["book_id"] as! String
        let review = params["review[review]"] as! String
        let rating = params["review[rating]"] as! Double
        
        XCTAssert(bookId == "123" && review == "Decent Book" && rating == 3)
        vModel?.closePage()
    }
    
    func setViewModel(vModel: MyReviewViewModelling) {
        self.vModel = vModel
    }
}

class MockMyReviewView: MyReviewViewControllable {
    var errorTest = 0
    
    func displayErrorPopup(_ error: String, _ title: String) {
        
        if errorTest == 1 {
            XCTAssert(title == "Network Error" && error == "Error fetching results. Please check your network conenction and try again")
        } else if errorTest == 2 {
            XCTAssert(title == "Network Error" && error == "Error posting your review. Please check your network connection and try again")
        } else if errorTest == 3 {
            XCTAssert(title == "Review not found" && error == "No review found. You may have selected an alternative version of the book you reviewed")
        }
    }
    
    var counter = 0
    
    func setReviewInfo(_ review: String, _ rating: Double) {
        XCTAssert(review == "Good Book" && rating == 4)
    }
    
    func returnToPrevScreen() {
        counter += 1
    }
    
    func verify() {
        XCTAssert(counter == 1)
    }
    
    func resetCounter() {
        counter = 0
    }
}

class MyReviewViewModelTests: XCTestCase {
    
    var serviceUnderTest: MyReviewViewModel? = nil
    var mockRepo = MockMyReviewRepository()
    var mockView = MockMyReviewView()

    override func setUp() {
        
    }

    override func tearDown() {
        mockView.resetCounter()
    }
    
    func testGettingAndSettingExistingReview() {
        serviceUnderTest = MyReviewViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.getReview(reviewId: "123")
    }
    
    func testPostingNewReview() {
        let testModel = DetailsModel(userId: "1", bookId: "123", reviewId: nil)
        serviceUnderTest = MyReviewViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.postReview("Decent Book", 3, testModel)
        mockView.verify()
    }
    
    func testEditingExistingReview() {
        let testModel = DetailsModel(userId: "1", bookId: "1234", reviewId: "987")
        serviceUnderTest = MyReviewViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.postReview("Ending was terrible", 2, testModel)
        mockView.verify()
    }
    
    func testErrorMessageShownOnBadNetworkWhenFetchingReview() {
        serviceUnderTest = MyReviewViewModel(view: mockView, repo: mockRepo)
        mockView.errorTest = 1
        serviceUnderTest?.errorBuilder("error1")
    }
    
    func testErrorMessageShownOnBadNetworkWhenPostingReview() {
        serviceUnderTest = MyReviewViewModel(view: mockView, repo: mockRepo)
        mockView.errorTest = 2
        serviceUnderTest?.errorBuilder("error2")
    }
    
    func testErrorMessageShownOnInvalidFetchedReview() {
        serviceUnderTest = MyReviewViewModel(view: mockView, repo: mockRepo)
        mockView.errorTest = 3
        serviceUnderTest?.errorBuilder("error3")
    }

}
