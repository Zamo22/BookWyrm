//
//  CriticReviewsViewModel.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/05.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

class CriticReviewsViewModel: CriticReviewsViewModelling {
    
    private var reviewResults = [String]() {
        didSet {
            view?.reloadTable()
        }
    }
    
    private var repo: CriticReviewsRepositoring? = nil
    weak var view: ReviewsControllable?
    
    init(view: ReviewsControllable, repo: CriticReviewsRepositoring) {
        self.view = view
        self.repo = repo
        repo.setViewModel(vModel: self)
    }
    
    func countResults() -> Int {
        return reviewResults.count
    }
    
    func getReview(index: Int) -> String {
        return reviewResults[index]
    }
    
    func fetchResults(for text: String) {
        repo?.fetchReviews(reviewData: text)
    }
    
    func setResults(_ results: [String]) {
        self.reviewResults = results
    }
}
