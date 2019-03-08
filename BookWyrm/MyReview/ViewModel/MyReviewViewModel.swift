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
    
    init(view: MyReviewViewControllable) {
        self.view = view
    }
    
    let repo: MyReviewRepositoring = MyReviewRepository()
    
    func getReview(reviewId: String) {
        repo.getReview(reviewId: reviewId) { review, rating in
            self.view?.setReviewInfo(review, Double(rating)!)
        }
    }
    
    func postReview(_ review: String, _ rating: Double, _ model: DetailsModel?) {
        if model?.reviewId == nil {
            //Add further options later on (set read status)
            let params: [String: Any] = [
                "book_id": model?.bookId ?? "",
                "review[review]": review,
                "review[rating]": rating
            ]
            repo.postReview(params: params)
            view?.returnToPrevScreen()
        } else {
            let params: [String: Any] = [
                "review[review]": review,
                "review[rating]": rating
            ]
            repo.editReview(params: params, (model?.reviewId)!)
            view?.returnToPrevScreen()
        }
    }
}
