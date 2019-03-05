//
//  CriticReviewsRepository.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/05.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol CriticReviewsRepositoring {
    func fetchReviews(reviewData: String, completionHandler: @escaping ([JSON]?, NetworkError) -> Void)
}

class CriticReviewsRepository: CriticReviewsRepositoring  {
    //Fetch reviews given some kind of search data, we use book title as it's the most accurate
    func fetchReviews(reviewData: String, completionHandler: @escaping ([JSON]?, NetworkError) -> Void) {
        let urlWithSpaces = "https://idreambooks.com/api/books/reviews.json?q=\(reviewData)&key=64f959b1d802bf39f22b52e8114cace510662582"
        
        guard let url = urlWithSpaces.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            guard let data = response.data else {
                completionHandler(nil, .failure)
                return
            }
            
            let json = try? JSON(data: data)
            let results = json?["book"]["critic_reviews"].arrayValue
            guard let empty = results?.isEmpty, !empty else {
                completionHandler(nil, .failure)
                return
            }
            
            completionHandler(results, .success)
        }
    }
}
