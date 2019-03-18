//
//  DetailsProtocols.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/07.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

protocol DetailRepositoring {
    func setViewModel(vModel: DetailViewModelling)
    func checkIfInList()
    func getBookID (reviewDetails: String)
    func postToShelf(params: [String: Any])
    func checkReviews(_ reviewData: String)
    func getUserId() -> String
}

protocol DetailViewControllable: class {
    func setReadStatus(read: Bool)
    func setReviewVisibility(hasReviews: Bool)
    func displayErrorPopup(_ error: String, _ title: String)
}

protocol DetailViewModelling: class {
    func checkIfInList(_ reviewDetails: String)
    func setBookID (_ bookID: String?)
    func modifyBookshelf()
    func checkReviews(_ reviewDetails: String)
    func getModel() -> DetailsModel
    func compareList(_ books: [String], _ reviews: [String])
    func setBookmarkStatus()
    func setReviewVisibility(hasReviews: Bool)
    func errorAlert(_ error: String)
}
