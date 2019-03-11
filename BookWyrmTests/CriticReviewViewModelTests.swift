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

class MockCriticReviewView: ReviewsControllable {
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
    
    var serviceUnderTest: CriticReviewsViewModel? = nil
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
        let testResults: [String] = ["Hello","World","","💩"]
        serviceUnderTest?.setResults(testResults)
        mockView.verify()
    }
    
    func testResultCountIsCorrect() {
        serviceUnderTest = CriticReviewsViewModel(view: mockView, repo: mockRepo)
        let testResults: [String] = ["Hello","World","","💩"]
        serviceUnderTest?.setResults(testResults)
        XCTAssert(serviceUnderTest?.countResults() == 4)
    }
    
    func testCorrectReviewIsReturned() {
        serviceUnderTest = CriticReviewsViewModel(view: mockView, repo: mockRepo)
        let testResults: [String] = ["Hello","World","","💩"]
        serviceUnderTest?.setResults(testResults)
        XCTAssert(serviceUnderTest?.getReview(index: 1) == "World")
    }


}