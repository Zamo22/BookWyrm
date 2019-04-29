//
//  ProfileRepository.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/04/29.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import SWXMLHash

class ProfileRepository: ProfileRepositoring, ProfileRepositorable {
    
    weak var vModel: ProfileViewModelling?
    var userId: String?
    lazy var goodreadsService: ProfileGoodreadsServicing = { return ProfileGoodreadsService(repo: self) }()
    
    func fetchUserInfo() {
        storedDetailsCheck()
        guard let checkedUserId = userId else {
            //Show error
            return
        }
        goodreadsService.getGoodreadsUser(userId: checkedUserId)
    }
    
    func parseUserInfo(_ xml: XMLIndexer) {

        guard let name = xml["GoodreadsResponse"]["user"]["name"].element?.text else {
            return
        }
        guard let imageUrl = xml["GoodreadsResponse"]["user"]["image_url"].element?.text else {
            return
        }
        guard let datejoined = xml["GoodreadsResponse"]["user"]["joined"].element?.text else {
            return
        }
        guard let numFriends = xml["GoodreadsResponse"]["user"]["friends_count"].element?.text else {
            return
        }
        guard let numGroups = xml["GoodreadsResponse"]["user"]["groups_count"].element?.text else {
            return
        }
        guard let numReviews = xml["GoodreadsResponse"]["user"]["reviews_count"].element?.text else {
            return
        }
        
        let profile = ProfileModel(name: name, profileImageLink: imageUrl, joinDate: datejoined, numFriends: numFriends, numGroups: numGroups, numReviews: numReviews)
        vModel?.setUserInfo(userProfile: profile)
    }
    
    func setViewModel(vModel: ProfileViewModelling) {
        self.vModel = vModel
    }
    
    func errorAlert(_ error: String) {
        
    }
    
    func storedDetailsCheck() {
        let preferences = UserDefaults.standard
        let idKey = "userID"
        
        if preferences.object(forKey: idKey) != nil {
            if let userID = preferences.string(forKey: idKey) {
                userId = userID
            }
        }
    }
}
