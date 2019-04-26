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
        guard let iDreamKey = Bundle.main.object(forInfoDictionaryKey: "iDreamBooks_Key") else {
            return
        }
        let urlWithSpaces = "https://idreambooks.com/api/books/reviews.json?q=\(reviewData)&key=\(iDreamKey)"
        
        guard let url = urlWithSpaces.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            guard let data = response.data else {
                self.vModel?.errorAlert("Network")
                return
            }
            
            let json = try? JSON(data: data)
            let results = json?["book"]["critic_reviews"].arrayValue
            guard let empty = results?.isEmpty, !empty else {
                //No results found for book
                self.vModel?.errorAlert("Empty")
                return
            }
            
            var reviews: [ReviewModel] = []
            guard let safeResults = results else {
                //Error case already handled
                return
            }
            
            for result in safeResults {
                let imageLink = result["source_logo"].stringValue
                let name = result["source"].stringValue
                let stars = result["star_rating"].stringValue
                let text = result["snippet"].stringValue
                reviews.append(ReviewModel(reviewerImageLink: imageLink, reviewerName: name, rating: stars, review: text))
            }
            self.vModel?.setResults(reviews)
        }
    }
}
