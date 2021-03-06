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
        guard let number = Int(model.numReviews) else {
            errorAlert("error5")
            return
        }
        var newNumReviews = "\(number) ratings"
        if number > 999 {
            if number > 999999 {
                let roundedNum: Int = number / 1000000
                newNumReviews = "\(roundedNum)M ratings"
            } else {
                let roundedNum: Int = number / 1000
                newNumReviews = "\(roundedNum)K ratings"
            }
        }
        var similarBooksModel: [SimilarBook] = []
        for book in model.similarBooks {
            similarBooksModel.append(SimilarBook(bookId: book.bookId, imageLink: book.imageLink, title: book.title, author: "By: \(book.author)", bookLink: book.bookLink, pages: "Pages: \(book.pages)", isbn: book.isbn))
        }
        if let cleanedDetails = model.details.removingPercentEncoding?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) {
            let newModel = ExtraDetailsModel(avgRating: model.avgRating, numReviews: newNumReviews, yearPublished: model.yearPublished, publisher: model.publisher, details: cleanedDetails, similarBooks: similarBooksModel)
            view?.setNewModel(model: newModel)
        }        
    }
    
    //Add statements to unwrap bookId, searches if nil
    func modifyBookshelf() {
        guard let bookID = bookId else {
            errorAlert("error3")
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
    
    func setFirstReview(review: ReviewModel) {
        view?.setReviewInfo(review: review)
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
        } else if error == "error5" {
            view?.displayErrorPopup("Incorrect format of number of reviews received", "Data Retrieval Error")
        }
    }
}
