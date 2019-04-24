//
//  CriticReviewsViewModel.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/05.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

class CriticReviewsViewModel: CriticReviewsViewModelling {
    
    private var reviewResults = [ReviewModel]() {
        didSet {
            view?.reloadTable()
        }
    }
    
    private var repo: CriticReviewsRepositoring?
    weak var view: ReviewsControllable?
    
    init(view: ReviewsControllable, repo: CriticReviewsRepositoring) {
        self.view = view
        self.repo = repo
        repo.setViewModel(vModel: self)
    }
    
    func countResults() -> Int {
        return reviewResults.count
    }
    
    func getReview(index: Int) -> ReviewModel {
        return reviewResults[index]
    }
    
    func fetchResults(for text: String) {
        repo?.fetchReviews(reviewData: text)
    }
    
    func setResults(_ results: [ReviewModel]) {
        self.reviewResults = results
    }
    
    func errorAlert(_ error: String) {
        if error == "Network" {
            view?.displayErrorPopup("Please check your internet connection and refresh", "Network Error")
        } else {
            view?.displayErrorPopup("Bad version of book selected. Look for an alternative version", "No Results Found")
        }
    }
}
