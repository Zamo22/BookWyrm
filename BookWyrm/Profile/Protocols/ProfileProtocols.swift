//
//  ProfileProtocols.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/04/29.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import SWXMLHash

protocol ProfileGoodreadsServicing {
    func getGoodreadsUser(userId: String)
}

protocol ProfileRepositoring {
    func fetchUserInfo()
    func setViewModel(vModel: ProfileViewModelling)
}

protocol ProfileRepositorable: class {
    func parseUserInfo(_ xml: XMLIndexer)
    func errorAlert(_ error: String)
}

protocol ProfileViewModelling: class {
    func getUserInfo()
    func setUserInfo(userProfile: ProfileModel)
}

protocol ProfileViewControllable: class {
    func setUserInfo(userProfile: ProfileModel)
}
