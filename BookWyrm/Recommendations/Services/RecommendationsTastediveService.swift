//
//  RecommendationsTastediveService.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/26.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RecommendationsTastediveService: RecommendationsTastediveServicing {
    
    weak var repo: RecommendationsRepositorable?
    
    init(repo: RecommendationsRepositorable) {
        self.repo = repo
    }
    
    func getRecommendations(_ list: String) {
        guard let tastediveKey = Bundle.main.object(forInfoDictionaryKey: "Tastedive_Key") as? String else {
            return
        }
        let urlWithSpaces = "https://tastedive.com/api/similar?q=\(list)&type=books&k=\(tastediveKey)"
        guard let url = urlWithSpaces.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            guard let data = response.data else {
                self.repo?.errorAlert("error1")
                return
            }
            
            let json = try? JSON(data: data)
            self.repo?.decodeResults(json: json)
        }
    }
}
