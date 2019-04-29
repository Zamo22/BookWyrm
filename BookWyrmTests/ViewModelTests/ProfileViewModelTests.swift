//
//  ProfileViewModelTests.swift
//  BookWyrmTests
//
//  Created by Zaheer Moola on 2019/04/29.
//  Copyright © 2019 DVT. All rights reserved.
//

import XCTest
@testable import BookWyrm

class MockProfileView: ProfileViewControllable {
    
    var error: String = ""
    var counter = 0
    
    func setUserInfo(userProfile: ProfileModel) {
        XCTAssert(userProfile.joinDate == "Joined: 01/1999")
        counter += 1
    }
    
    func resetCounter() {
        counter = 0
    }
    
    func displayErrorPopup(_ error: String, _ title: String) {
        self.error = error
    }
    
}

class MockProfileRepository: ProfileRepositoring {
    
    var counter = 0
     weak var vModel: ProfileViewModelling?
    
    func fetchUserInfo() {
        counter += 1
        let testModel = ProfileModel(name: "Zaheer", profileImageLink: "image.com", joinDate: "01/1999", numFriends: "1", numGroups: "3", numReviews: "11")
        vModel?.setUserInfo(userProfile: testModel)
    }
    
    func setViewModel(vModel: ProfileViewModelling) {
        self.vModel = vModel
    }
    
    func resetCounter() {
        counter = 0
    }
    
}

class ProfileViewModelTests: XCTestCase {
    
    var serviceUnderTest: ProfileViewModel?
    var mockRepo = MockProfileRepository()
    var mockView = MockProfileView()

    override func setUp() {

    }

    override func tearDown() {
        mockRepo.resetCounter()
        mockView.resetCounter()
        mockView.error = ""
    }
    
    func testGettingUserInfoCallsRepo() {
        serviceUnderTest = ProfileViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.getUserInfo()
        XCTAssert(mockRepo.counter == 1)
    }
    
    func testRequestingResultsAlsoSetsInformationInView() {
        serviceUnderTest = ProfileViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.getUserInfo()
        XCTAssert(mockView.counter == 1)
    }
    
    func testUserDataNotFoundShowsError() {
         serviceUnderTest = ProfileViewModel(view: mockView, repo: mockRepo)
         serviceUnderTest?.errorAlert("error1")
         XCTAssert(mockView.error == "No user profile information found. Please try again")
    }
    
    func testErrorParsingUserDataShowsError() {
        serviceUnderTest = ProfileViewModel(view: mockView, repo: mockRepo)
        serviceUnderTest?.errorAlert("error2")
        XCTAssert(mockView.error == "Unable to parse user information")
    }

}
