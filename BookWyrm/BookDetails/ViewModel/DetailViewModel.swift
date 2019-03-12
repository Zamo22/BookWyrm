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
    }
    
    var bookId: String?
    var reviewId: String?
    var inList = false
    
    func checkIfInList(_ reviewDetails: String, callback: @escaping (_ check: Bool) -> Void) {
        repo?.getBookID(reviewDetails: reviewDetails)
        
        
        repo?.checkIfInList { books, reviews in
                var counter = 0
                for book in books {
                    if self.bookId == book {
                        self.inList = true
                        self.reviewId = reviews[counter]
                    }
                    counter += 1
                }
                callback(self.inList)
            
        }
    }
    
    func getBooksAndReviews() {
        
    }
    
    func setListStatus(_ check: Bool) {
        
    }
    
    func checkReviews(_ reviewDetails: String) {
        repo?.checkReviews(reviewDetails) { check, _ in
            self.view?.setReviewVisibility(hasReviews: check)
        }
    }
    
    func setBookID (_ bookID: String?) {
        self.bookId = bookID
    }
    
    func getModel() -> DetailsModel {
        return DetailsModel(userId: (repo?.getUserId())!, bookId: self.bookId!, reviewId: self.reviewId)
    }
    
    //Add statements to unwrap bookId, searches if nil
    func modifyBookshelf() {
        if !inList {
            let params: [String: Any] = [
                "name": "to-read",
                "book_id": bookId!
            ]
            
           _ = repo?.postToShelf(params: params)
            
            //Would cause problems if post failed
            self.inList = true
            view?.setReadStatus(read: true)
        } else {
            let params: [String: Any] = [
                "name": "to-read",
                "book_id": bookId!,
                "a": "remove"
            ]
            
            _ = repo?.postToShelf(params: params)
            //Would cause problems if post failed
            self.inList = false
            view?.setReadStatus(read: false)
        }
    }
}
