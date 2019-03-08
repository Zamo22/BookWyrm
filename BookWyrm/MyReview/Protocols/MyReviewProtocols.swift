//
//  MyReviewProtocols.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/07.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

protocol MyReviewRepositoring {
    func getReview(reviewId: String, callback: @escaping (_ review: String, _ rating: String) -> Void)
    func editReview(params: [String: Any], _ reviewId: String)
    func postReview(params: [String: Any])
}

protocol MyReviewViewModelling {
    func getReview(reviewId: String)
    func postReview(_ review: String, _ rating: Double, _ model: DetailsModel?)
}

protocol MyReviewViewControllable: class {
    func setReviewInfo(_ review: String, _ rating: Double)
    func returnToPrevScreen()
}
