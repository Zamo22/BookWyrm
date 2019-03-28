//
//  iDreamBooksService.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/28.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RecommendationsiDreamBooksService: RecommendationsiDreamBooksServicing {
    weak var repo: RecommendationsRepositorable?
    
    init(repo: RecommendationsRepositorable) {
        self.repo = repo
    }
    
    func getPopularBooks() {
        let urlToSearch = "http://idreambooks.com/api/publications/recent_recos.json?key=64f959b1d802bf39f22b52e8114cace510662582&slug=bestsellers"

        Alamofire.request(urlToSearch).responseJSON { response in
            guard let data = response.data else {
                self.repo?.errorAlert("error1")
                return
            }
            
            guard let json = try? JSON(data: data) else {
                return
            }
            self.repo?.decodePopularResults(json: json)
        }
    }
}
