//
//  CriticReviewsViewModel.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/05.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol CriticReviewsViewModelling {
    func countResults() -> Int
    func getReview(index: Int) -> String
    func fetchResults(for text: String)
}

class CriticReviewsViewModel: CriticReviewsViewModelling {

    private var reviewResults = [JSON]() {
        didSet {
            view?.reloadTable()
        }
    }
    
    let repo: CriticReviewsRepositoring = CriticReviewsRepository()
    weak var view: ReviewsControllable?
    
    init(view: ReviewsControllable) {
        self.view = view
    }
    
    func countResults() -> Int {
        return reviewResults.count
    }
    
    func getReview(index: Int) -> String {
        return reviewResults[index]["snippet"].stringValue
    }
    
    func fetchResults(for text: String) {
        repo.fetchReviews(reviewData: text, completionHandler: { [weak self] results, error in
            if case .failure = error {
                return
            }
            
            guard let results = results, !results.isEmpty else {
                return
            }
            self?.reviewResults = results
        })
    }
}
