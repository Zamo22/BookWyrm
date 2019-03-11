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

class CriticReviewsRepository: CriticReviewsRepositoring {
    
    weak var vModel: CriticReviewsViewModelling?
    
    func setViewModel(vModel: CriticReviewsViewModelling) {
        self.vModel = vModel
    }
    
    //Fetch reviews given some kind of search data, we use book title as it's the most accurate
    func fetchReviews(reviewData: String) {
        let urlWithSpaces = "https://idreambooks.com/api/books/reviews.json?q=\(reviewData)&key=64f959b1d802bf39f22b52e8114cace510662582"
        
        guard let url = urlWithSpaces.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            guard let data = response.data else {
                //completionHandler(nil, .failure)
                return
            }
            
            let json = try? JSON(data: data)
            let results = json?["book"]["critic_reviews"].arrayValue
            guard let empty = results?.isEmpty, !empty else {
                //completionHandler(nil, .failure)
                //**CALL ERROR METHOD IN VIEWMODEL
                return
            }
            
            var reviews: [String] = []
            //Checked above
            for result in results! {
                reviews.append(result["snippet"].stringValue)
            }
            self.vModel?.setResults(reviews)
            //completionHandler(reviews, .success)
        }
    }
}
