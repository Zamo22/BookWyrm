//
//  CriticReviewViewModelTest.swift
//  BookWyrmTests
//
//  Created by Zaheer Moola on 2019/03/07.
//  Copyright © 2019 DVT. All rights reserved.
//

class MockCriticReviewRepo: CriticReviewsRepositoring {
    var counter = 0
    
    func setViewModel(vModel: CriticReviewsViewModelling) {
        counter += 1
    }
    
    func fetchReviews(reviewData: String) {
        counter += 1
    }
    
    func verify() {
        XCTAssert(counter == 2)
    }
    
    func resetCounter() {
        counter = 0
    }
}

class MockCriticReviewView: NSObject, ReviewsControllable {
    
    var secondTest = false
    
    func displayErrorPopup(_ error: String, _ title: String) {
        if !secondTest {
            XCTAssert(title == "Network Error" && error == "Please check your internet connection and refresh")
        } else {
            XCTAssert(title == "No Results Found" && error == "Bad version of book selected. Look for an alternative version")
        }
    }
    
    var counter = 0
    
    func reloadTable() {
        counter += 1
    }
    
    func verify() {
        XCTAssert(counter == 1)
    }
    
    func resetCounter() {
        counter = 0
    }
}

import XCTest
@testable import BookWyrm

class CriticReviewViewModelTests: XCTestCase {
    
    var serviceUnderTest: CriticReviewsViewModel?
    let mockRepo = MockCriticReviewRepo()
    let mockView =  MockCriticReviewView()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        mockView.resetCounter()
        mockRepo.resetCounter()
    }
    
    func testThatFetchingResultsAsksRepoForResults() {
        serviceUnderTest = CriticReviewsViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.fetchResults(for: "Test Data")
        mockRepo.verify()
    }

    func testThatSettingResultsReloadsDataInTableView() {
        serviceUnderTest = CriticReviewsViewModel(view: mockView, repo: mockRepo)
        var testResults: [ReviewModel] = []
        testResults.append(ReviewModel(reviewerImageLink: "www.booklink.com", reviewerName: "Zaheer", rating: "3", review: "Hello"))
        testResults.append(ReviewModel(reviewerImageLink: "www.booklink2.com", reviewerName: "Zaheer", rating: "5", review: "World"))
        serviceUnderTest?.setResults(testResults)
        mockView.verify()
    }
    
    func testResultCountIsCorrect() {
        serviceUnderTest = CriticReviewsViewModel(view: mockView, repo: mockRepo)
        var testResults: [ReviewModel] = []
        testResults.append(ReviewModel(reviewerImageLink: "www.booklink.com", reviewerName: "Zaheer", rating: "3", review: "Hello"))
        testResults.append(ReviewModel(reviewerImageLink: "www.booklink2.com", reviewerName: "Zaheer", rating: "5", review: "World"))
        serviceUnderTest?.setResults(testResults)
        XCTAssert(serviceUnderTest?.countResults() == 2)
    }
    
    func testCorrectReviewIsReturned() {
        serviceUnderTest = CriticReviewsViewModel(view: mockView, repo: mockRepo)
        var testResults: [ReviewModel] = []
        testResults.append(ReviewModel(reviewerImageLink: "www.booklink.com", reviewerName: "Zaheer", rating: "3", review: "Hello"))
        testResults.append(ReviewModel(reviewerImageLink: "www.booklink2.com", reviewerName: "Zaheer", rating: "5", review: "World"))
        serviceUnderTest?.setResults(testResults)
        XCTAssert(serviceUnderTest?.getReview(index: 1).review  == "World")
    }
    
    func testErrorMessageShownOnErrorFromBadNetwork() {
        serviceUnderTest = CriticReviewsViewModel(view: mockView, repo: mockRepo)
        mockView.secondTest = false
        serviceUnderTest?.errorAlert("Network")
    }
    
    func testErrorMessageShownOnErrorFromNoResults() {
        serviceUnderTest = CriticReviewsViewModel(view: mockView, repo: mockRepo)
        mockView.secondTest = true
        serviceUnderTest?.errorAlert("Empty")
    }

}
