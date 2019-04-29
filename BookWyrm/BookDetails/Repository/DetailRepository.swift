//
//  DetailRepository.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/04.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import OAuthSwift
import SWXMLHash
import SwiftyJSON

class DetailRepository: DetailRepositoring, DetailRepositorable {
    
    var oauthswift: OAuthSwift?
    var userId: String?
    
    weak var vModel: DetailViewModelling?
    lazy var alamofireService: DetailsAlamofireServicing = { return DetailsAlamofireService(repo: self) }()
    lazy var oauthService: DetailsOAuthswiftServicing = { return DetailsOAuthswiftService(repo: self) }()
    
    func setViewModel(vModel: DetailViewModelling) {
        self.vModel = vModel
    }
    
    func checkIfInList() {
        oauthService.getBookList()
    }
    
    func parseBooklist(_ xml: XMLIndexer) {
        var books: [String] = []
        var reviews: [String] = []
        //Change this to include if statement inside for loop to speed up process
        for elem in xml["GoodreadsResponse"]["reviews"]["review"].all {
            //Add book ID to array
            books.append(elem["book"]["id"].element?.text ?? "")
            reviews.append(elem["id"].element?.text ?? "")
        }
        
        self.vModel?.compareList(books, reviews)
    }
    
    func getUserId() -> String {
        guard let userID = userId else {
            return "error"
        }
        return userID
    }
    
    func postToShelf(params: [String: Any]) {
        oauthService.postToShelf(params: params)
    }
    
    func setBookmarkStatus() {
        vModel?.setBookmarkStatus()
    }
    
    func getBookID (reviewDetails: String) {
        oauthService.getBookData(reviewDetails)
    }
    
    func parseBookDetails(_ xml: XMLIndexer) {
        guard let bookId = xml["GoodreadsResponse"]["search"]["results"]["work"][0]["best_book"]["id"].element?.text else {
            self.vModel?.errorAlert("error3")
            return
        }
        self.vModel?.setBookID(bookId)
        alamofireService.getBook(bookId)
    }
    
    func parseExtraDetails(_ xml: XMLIndexer) {
        guard let avgRating = xml["GoodreadsResponse"]["book"]["average_rating"].element?.text else {
            return
        }
        guard let numReviews = xml["GoodreadsResponse"]["book"]["work"]["ratings_count"].element?.text else {
            return
        }
        guard let publisher = xml["GoodreadsResponse"]["book"]["publisher"].element?.text else {
            return
        }
        guard let publishedYear = xml["GoodreadsResponse"]["book"]["publication_year"].element?.text else {
            return
        }
        
        guard let description = xml["GoodreadsResponse"]["book"]["description"].element?.text else {
            return
        }
        
        var similarBooksArray: [SimilarBook] = []
        for similar in xml["GoodreadsResponse"]["book"]["similar_books"]["book"].all {
            guard let similarBookId = similar["id"].element?.text else {
                return
            }
            guard let imageLink = (similar["image_url"].element?.text) else {
                return
            }
            guard let bookLink = (similar["link"].element?.text) else {
                return
            }
            guard let author = (similar["authors"]["author"]["name"].element?.text) else {
                return
            }
            guard let title = (similar["title"].element?.text) else {
                return
            }
            guard let pages = (similar["num_pages"].element?.text) else {
                return
            }
            guard let isbn = (similar["isbn"].element?.text) else {
                return
            }
            similarBooksArray.append(SimilarBook(bookId: similarBookId, imageLink: imageLink, title: title, author: author, bookLink: bookLink, pages: pages, isbn: isbn))
            
        }
        
        let extraDetailsModel = ExtraDetailsModel(avgRating: avgRating, numReviews: numReviews, yearPublished: publishedYear, publisher: publisher, details: description, similarBooks: similarBooksArray)
        vModel?.setRemainingDetails(model: extraDetailsModel)
    }
    
    func checkReviews(_ reviewData: String) {
        alamofireService.checkReviews(reviewData)
    }
    
    func decodeReviewCheck(json: JSON?) {
        let results = json?["book"]["critic_reviews"].arrayValue
        
        guard let empty = results?.isEmpty, !empty else {
            self.vModel?.setReviewVisibility(hasReviews: false)
            return
        }
        self.vModel?.setReviewVisibility(hasReviews: true)
        
        guard let review = (results?[0]["snippet"].stringValue) else {
            return
        }
        guard let reviewer = (results?[0]["source"].stringValue) else {
            return
        }
        guard let rating = (results?[0]["star_rating"].stringValue) else {
            return
        }
        guard let imageLink = results?[0]["source_logo"].stringValue else {
            return
        }
        
        let firstReview = ReviewModel(reviewerImageLink: imageLink, reviewerName: reviewer, rating: rating, review: review)
        
        self.vModel?.setFirstReview(review: firstReview)
    }
    
    func errorAlert(_ error: String) {
        vModel?.errorAlert(error)
    }
    
    func getToken() {
        let preferences = UserDefaults.standard
        let key = "oauth"
        if preferences.object(forKey: key) == nil {
            vModel?.errorAlert("error4")
        } else {
            let decoded  = preferences.object(forKey: key) as! Data
            if let credential = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? OAuthSwiftCredential {
                guard let goodreadsKey = Bundle.main.object(forInfoDictionaryKey: "Goodreads_Key") as? String else {
                    return
                }
                guard let goodreadsSecret = Bundle.main.object(forInfoDictionaryKey: "Goodreads_Secret") as? String else {
                    return
                }
                let oauthS = OAuth1Swift(consumerKey: goodreadsKey,
                                         consumerSecret: goodreadsSecret)
                oauthS.client.credential.oauthToken = credential.oauthToken
                oauthS.client.credential.oauthTokenSecret = credential.oauthTokenSecret
                oauthService.setToken(oauthS)
            }
        }
        
        let idKey = "userID"
        if preferences.object(forKey: idKey) != nil {
            guard let safeId = preferences.string(forKey: idKey) else {
                return
            }
            userId = safeId
        }
    }
}
