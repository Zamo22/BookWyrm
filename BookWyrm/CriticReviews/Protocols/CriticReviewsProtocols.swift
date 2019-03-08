//
//  CriticReviewsProtocols.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/07.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol CriticReviewsRepositoring {
    func fetchReviews(reviewData: String, completionHandler: @escaping ([String]?, NetworkError) -> Void)
}

protocol CriticReviewsViewModelling {
    func countResults() -> Int
    func getReview(index: Int) -> String
    func fetchResults(for text: String)
}

protocol ReviewsControllable: class {
    func reloadTable()
}
