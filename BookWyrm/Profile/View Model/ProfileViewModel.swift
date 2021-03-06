//
//  ProfileViewModel.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/04/29.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

class ProfileViewModel: ProfileViewModelling {
    
    weak var view: ProfileViewControllable?
    var repo: ProfileRepositoring?
    
    init(view: ProfileViewControllable, repo: ProfileRepositoring) {
        self.view = view
        self.repo = repo
        repo.setViewModel(vModel: self)
    }
    
    func getUserInfo() {
        repo?.fetchUserInfo()
    }
    
    func errorAlert(_ error: String) {
        if error == "error1" {
            view?.displayErrorPopup("No user profile information found. Please try again", "No user data")
        } else if error == "error2" {
            view?.displayErrorPopup("Unable to parse user information", "Error fetching data")
        }
    }
    
    func setUserInfo(userProfile: ProfileModel) {
        let newModel = ProfileModel(name: userProfile.name, profileImageLink: userProfile.profileImageLink, joinDate: "Joined: \(userProfile.joinDate)", numFriends: userProfile.numFriends, numGroups: userProfile.numGroups, numReviews: userProfile.numReviews)
        
        view?.setUserInfo(userProfile: newModel)
    }
    
}
