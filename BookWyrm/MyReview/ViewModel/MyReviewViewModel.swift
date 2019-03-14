//
//  MyReviewViewModel.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/05.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

class MyReviewViewModel: MyReviewViewModelling {
    
    weak var view: MyReviewViewControllable?
    var repo: MyReviewRepositoring?
    
    init(view: MyReviewViewControllable, repo: MyReviewRepositoring) {
        self.view = view
        self.repo = repo
        repo.setViewModel(vModel: self)
    }
    
    func getReview(reviewId: String) {
        repo?.getReview(reviewId: reviewId)
    }
    
    func setReview(_ review: String, _ rating: String) {
        self.view?.setReviewInfo(review, Double(rating)!)
    }
    
    func postReview(_ review: String, _ rating: Double, _ model: DetailsModel?) {
        if model?.reviewId == nil {
            //Add further options later on (set read status)
            let params: [String: Any] = [
                "book_id": (model?.bookId)!,
                "review[review]": review,
                "review[rating]": rating
            ]
            repo?.postReview(params: params)
        } else {
            let params: [String: Any] = [
                "review[review]": review,
                "review[rating]": rating
            ]
            repo?.editReview(params: params, (model?.reviewId)!)
        }
    }
    
    func closePage() {
        view?.returnToPrevScreen()
    }
    
    func networkError() {
        
    }
}
