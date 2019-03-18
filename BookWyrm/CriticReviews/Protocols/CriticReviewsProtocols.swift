//
//  CriticReviewsProtocols.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/07.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

protocol CriticReviewsRepositoring {
    func fetchReviews(reviewData: String)
    func setViewModel(vModel: CriticReviewsViewModelling)
}

protocol CriticReviewsViewModelling: class {
    func countResults() -> Int
    func getReview(index: Int) -> String
    func fetchResults(for text: String)
    func setResults(_ results: [String])
    func errorAlert(_ error: String)
}

protocol ReviewsControllable: class {
    func reloadTable()
    func displayErrorPopup(_ error: String, _ title: String)
}
