//
//  DetailViewModel.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/04.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

protocol DetailViewModelling {
    func checkIfInList(_ reviewDetails: String, callback: @escaping (_ check: Bool) -> Void)
    func getBookID (_ reviewDetails: String, callback: @escaping (_ id: String) -> Void)
    func modifyBookshelf()
    func checkReviews(_ reviewDetails: String)
    func getModel() -> DetailsModel
}

class DetailViewModel: DetailViewModelling {
    
    weak var view : DetailViewControllable?
    
    init(view: DetailViewControllable) {
        self.view = view
    }
    
    var repo: DetailRepositoring = DetailRepository()
    
    var bookId: String?
    var reviewId: String?
    var inList = false
    
    func checkIfInList(_ reviewDetails: String, callback: @escaping (_ check: Bool) -> Void) {
        
        repo.checkIfInList { books, reviews in
            self.getBookID(reviewDetails) { bookId in
                var counter = 0
                for book in books {
                    if bookId == book {
                        self.inList = true
                        self.reviewId = reviews[counter]
                    }
                    counter += 1
                }
                callback(self.inList)
            }
        }
    }
    
    func checkReviews(_ reviewDetails: String) {
        repo.checkReviews(reviewDetails) { check, _ in
            self.view?.setReviewVisibility(hasReviews: check)
        }
    }
    
    func getBookID (_ reviewDetails: String, callback: @escaping (_ id: String) -> Void) {
        repo.getBookID(reviewDetails: reviewDetails) { bookID in
            self.bookId = bookID
            callback(bookID)
        }
    }
    
    func getModel() -> DetailsModel {
        return DetailsModel(userId: repo.getUserId(), bookId: self.bookId!, reviewId: self.reviewId!)
    }
    
    //Add statements to unwrap bookId, searches if nil
    func modifyBookshelf() {
        if !inList {
            let params: [String: Any] = [
                "name": "to-read",
                "book_id": bookId!
            ]
            
           _ = repo.postToShelf(params: params)
            
            //Would cause problems if post failed
            self.inList = true
            view?.setReadStatus(read: true)
        } else {
            let params: [String: Any] = [
                "name": "to-read",
                "book_id": bookId!,
                "a": "remove"
            ]
            
            _ = repo.postToShelf(params: params)
            
            //Would cause problems if post failed
            self.inList = false
            view?.setReadStatus(read: false)
        }
    }
    
}

