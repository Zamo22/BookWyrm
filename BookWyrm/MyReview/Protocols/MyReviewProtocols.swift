//
//  MyReviewProtocols.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/07.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

protocol MyReviewRepositoring {
    func getReview(reviewId: String)
    func editReview(params: [String: Any], _ reviewId: String)
    func postReview(params: [String: Any])
    func setViewModel(vModel: MyReviewViewModelling)
}

protocol MyReviewViewModelling: class {
    func getReview(reviewId: String)
    func postReview(_ review: String, _ rating: Double, _ model: DetailsModel?)
    func closePage()
    func setReview(_ review: String, _ rating: String)
    func errorBuilder(_ error: String)
}

protocol MyReviewViewControllable: class {
    func setReviewInfo(_ review: String, _ rating: Double)
    func returnToPrevScreen()
    func displayErrorPopup(_ error: String, _ title: String)
}
