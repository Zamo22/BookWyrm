//
//  DetailViewModel.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/04.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

class DetailViewModel: DetailViewModelling {
    
    weak var view: DetailViewControllable?
    var repo: DetailRepositoring?
    
    init(view: DetailViewControllable, repo: DetailRepositoring) {
        self.view = view
        self.repo = repo
        repo.setViewModel(vModel: self)
    }
    
    var bookId: String?
    var reviewId: String?
    var inList = false
    
    func checkIfInList(_ reviewDetails: String) {
        repo?.getBookID(reviewDetails: reviewDetails)
    }
    
    func compareList(_ books: [String], _ reviews: [String]) {
        var counter = 0
        for book in books {
            if self.bookId == book {
                self.inList = true
                self.reviewId = reviews[counter]
            }
            counter += 1
        }
        view?.setReadStatus(read: self.inList)
    }
    
    func checkReviews(_ reviewDetails: String) {
        repo?.checkReviews(reviewDetails)
    }
    
    func setReviewVisibility(hasReviews: Bool) {
        self.view?.setReviewVisibility(hasReviews: hasReviews)
    }
    
    func setBookID (_ bookID: String?) {
        self.bookId = bookID
        repo?.checkIfInList()
    }
    
    func getModel() -> DetailsModel {
        return DetailsModel(userId: (repo?.getUserId())!, bookId: self.bookId!, reviewId: self.reviewId)
    }
    
    func setRemainingDetails(model: ExtraDetailsModel) {
        view?.setNewModel(model: model)
    }
    
    //Add statements to unwrap bookId, searches if nil
    func modifyBookshelf() {
        guard let bookID = bookId else {
            return
        }
        
        if !inList {
            let params: [String: Any] = [
                "name": "to-read",
                "book_id": bookID
            ]
            
            //Would cause problems if post failed
           self.inList = true
           repo?.postToShelf(params: params)
        } else {
            let params: [String: Any] = [
                "name": "to-read",
                "book_id": bookID,
                "a": "remove"
            ]
            
            //Would cause problems if post failed
            self.inList = false
            repo?.postToShelf(params: params)
        }
    }
    
    func setBookmarkStatus() {
        view?.setReadStatus(read: inList)
    }
    
    func errorAlert(_ error: String) {
        if error == "error1" {
            view?.displayErrorPopup("Please check your internet connection and try again", "Network Error")
        } else if error == "error2" {
            view?.displayErrorPopup("Unable to add/remove item. Please try again later", "Unsuccessful Operation")
        } else if error == "error3" {
            view?.displayErrorPopup("Could not find matching book on server. Please ensure you have a valid book version", "Invalid Book")
        } else if error == "error4" {
            view?.displayErrorPopup("Unable to obtain login token. Please restart the app", "Authentication Error")
        }
    }
}
