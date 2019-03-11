//
//  DetailsProtocols.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/07.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

protocol DetailRepositoring {
    func getGoodreadsUserID(callback: @escaping (_ id: String) -> Void)
    func checkIfInList(callback: @escaping (_ books: [String], _ reviews: [String]) -> Void)
    func getBookID (reviewDetails: String, callback: @escaping (_ id: String) -> Void)
    func postToShelf(params: [String: Any]) -> Bool
    func checkReviews(_ reviewData: String, completionHandler: @escaping (Bool, NetworkError) -> Void)
    func getUserId() -> String
}

protocol DetailViewControllable: class {
    func setReadStatus(read: Bool)
    func setReviewVisibility(hasReviews: Bool)
}

protocol DetailViewModelling {
    func checkIfInList(_ reviewDetails: String, callback: @escaping (_ check: Bool) -> Void)
    func getBookID (_ reviewDetails: String, callback: @escaping (_ id: String) -> Void)
    func modifyBookshelf()
    func checkReviews(_ reviewDetails: String)
    func getModel() -> DetailsModel
}