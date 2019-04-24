//
//  DetailsProtocols.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/07.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import SwiftyJSON
import OAuthSwift
import SWXMLHash

protocol DetailRepositoring {
    func setViewModel(vModel: DetailViewModelling)
    func checkIfInList()
    func getBookID (reviewDetails: String)
    func postToShelf(params: [String: Any])
    func checkReviews(_ reviewData: String)
    func getUserId() -> String
}

protocol DetailRepositorable: class {
    func decodeReviewCheck(json: JSON?)
    func errorAlert(_ error: String)
    func getToken()
    func getUserId() -> String
    func parseBooklist(_ xml: XMLIndexer)
    func parseBookDetails(_ xml: XMLIndexer)
    func parseExtraDetails(_ xml: XMLIndexer)
    func setBookmarkStatus()
}

protocol DetailViewControllable: class {
    func setReadStatus(read: Bool)
    func setReviewVisibility(hasReviews: Bool)
    func displayErrorPopup(_ error: String, _ title: String)
    func setNewModel(model: ExtraDetailsModel)
    func setReviewInfo(review: ReviewModel)
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
    func setRemainingDetails(model: ExtraDetailsModel)
     func setFirstReview(review: ReviewModel)
}

protocol DetailsAlamofireServicing {
    func checkReviews(_ reviewData: String)
    func getBook(_ bookId: String)
}

protocol DetailsOAuthswiftServicing {
    func setToken(_ token: OAuthSwift)
    func getBookList()
    func getBookData(_ reviewDetails: String)
    func postToShelf(params: [String: Any])
}
