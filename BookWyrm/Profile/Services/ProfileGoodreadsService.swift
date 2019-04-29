//
//  ProfileGoodreadsService.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/04/29.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

class ProfileGoodreadsService: ProfileGoodreadsServicing {
    
     weak var repo: ProfileRepositorable?
    
    init(repo: ProfileRepositorable) {
        self.repo = repo
    }
    
    func getGoodreadsUser(userId: String) {
        guard let goodreadsKey = Bundle.main.object(forInfoDictionaryKey: "Goodreads_Key") else {
            return
        }
        let url = "https://www.goodreads.com/user/show/\(userId).xml?key=\(goodreadsKey)"
        Alamofire.request(url, method: .get).response { response in
            
            guard let data = response.data else {
                self.repo?.errorAlert("error1")
                return
            }

            let xml = SWXMLHash.parse(data)
            self.repo?.parseUserInfo(xml)
        }
    }
}
