//
//  RecommendationsBackendService.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/04/16.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RecommendationsBackendService: RecommendationsBackendServicing {
    
    weak var repo: RecommendationsRepositorable?
    
    init(repo: RecommendationsRepositorable) {
        self.repo = repo
    }
    
    func getPopularBooks() {
        let urlToSearch = "https://bookwyrm-backend.vapor.cloud/popular"
        
        Alamofire.request(urlToSearch).responseJSON { response in
            guard let data = response.data else {
                self.repo?.errorAlert("error1")
                return
            }
            
            guard let json = try? JSON(data: data) else {
                return
            }
            self.repo?.decodeBackendPopularResults(json: json)
        }
    }
}
