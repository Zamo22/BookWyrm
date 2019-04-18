//
//  NewDetailViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/04/17.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit
import SafariServices

class NewDetailViewController: UIViewController {
    
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookAverageRating: CosmosView!
    @IBOutlet weak var bookNumRatings: UILabel!
    @IBOutlet weak var bookPages: UILabel!
    @IBOutlet weak var bookPublisherInfo: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookSynopsis: UITextView!
    @IBOutlet weak var reviewerImage: UIImageView!
    @IBOutlet weak var reviewText: UITextView!
    @IBOutlet weak var reviewerTitle: UILabel!
    @IBOutlet weak var reviewerRating: CosmosView!
    @IBOutlet weak var similarBook1: UIImageView!
    @IBOutlet weak var similarBook2: UIImageView!
    @IBOutlet weak var similarBook3: UIImageView!
    @IBOutlet weak var similarBook4: UIImageView!
    @IBOutlet weak var bookLinkButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    var reviewDetailsToSend: String?
    var readingLink: String?
    
    var bookModel: SearchModel?
    var newModel: ExtraDetailsModel?
    
    lazy var model: DetailViewModelling = { return DetailViewModel(view: self, repo: DetailRepository()) }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    @IBAction func openBookLink(_ sender: UIButton) {
        let svc = SFSafariViewController(url: URL(string: readingLink!)!)
        self.present(svc, animated: true, completion: nil)
    }
    
    @IBAction func bookmarkBook(_ sender: UIButton) {
        model.modifyBookshelf()
    }
    
    @IBAction func seeAllReviews(_ sender: UIButton) {
        if let vControl = storyboard?.instantiateViewController(withIdentifier: "Reviews") as? ReviewsTableViewController {
            vControl.reviewDetails = reviewDetailsToSend
            vControl.title = "Reviews for: \(reviewDetailsToSend ?? "Error - No book")"
            navigationController?.pushViewController(vControl, animated: true)
        }
    }
    
    @IBAction func leaveReview(_ sender: UIButton) {
        if let vControl = storyboard?.instantiateViewController(withIdentifier: "MyReview") as? MyReviewViewController {
            vControl.title = "Review for: \(reviewDetailsToSend ?? "Error - No book")"
            let detailModel = model.getModel()
            vControl.detailModel = detailModel
            navigationController?.pushViewController(vControl, animated: true)
        }
    }
    
    func doRemainingSetup() {
        if let publisher = newModel?.publisher {
            if let year = newModel?.yearPublished {
                self.bookPublisherInfo.text = "\(publisher) (\(year))"
            }
        }
        
        if let rating = newModel?.avgRating {
            self.bookAverageRating.rating = Double(rating)!
        }
        
        if let numRatings = newModel?.numReviews {
            self.bookNumRatings.text = numRatings
        }
        
        var count = 0
        if let similar = newModel?.similarBooks {
            for book in similar {
                if count < 4 {
                    switch count {
                    case 0: similarBook1.fetchImage(url: book.imageLink)
                        break
                    case 1: similarBook2.fetchImage(url: book.imageLink)
                        break
                    case 2: similarBook3.fetchImage(url: book.imageLink)
                        break
                    case 3: similarBook4.fetchImage(url: book.imageLink)
                        break
                    default:
                        break
                    }
                    count += 1
                }
            }
        }
        
    }
    
    func setupView() {
        if let titleToLoad = bookModel?.title {
            self.bookTitle.text = titleToLoad
        }
        
        if let authorToLoad = bookModel?.authors {
            self.bookAuthor.text = authorToLoad
        }
        
        if let descriptionToLoad = bookModel?.description {
            self.bookSynopsis.text = descriptionToLoad
        }
        
        if let pagesToLoad = bookModel?.pageNumbers {
            self.bookPages.text = pagesToLoad
        }
        
        if let url = bookModel?.largeImageUrl {
            self.bookImage.fetchImage(url: url)
        }
        
        readingLink = bookModel?.webLink
        if readingLink == nil {
            self.bookLinkButton.isHidden = true
        }
        reviewDetailsToSend = bookModel?.reviewInfo
        
        if let reviewDetailsToSend = reviewDetailsToSend {
            model.checkIfInList(reviewDetailsToSend)
            model.checkReviews(reviewDetailsToSend)
        }
        
    }
}
extension NewDetailViewController: DetailViewControllable {
    
    func setReadStatus(read: Bool) {
        if read {
            self.bookmarkButton.setImage(UIImage(named: "bookmarkFilled2"), for: .normal)
        } else {
            self.bookmarkButton.setImage(UIImage(named: "bookmark2"), for: .normal)
        }
    }
    
    func setReviewVisibility(hasReviews: Bool) {
        if !hasReviews {
            //self.reviewsButton.isHidden = true
            //Hide reviews if none
        }
    }
    
    func displayErrorPopup(_ error: String, _ title: String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setNewModel(model: ExtraDetailsModel) {
        self.newModel = model
        doRemainingSetup()
    }
    
    func setReviewInfo(review: ReviewModel) {
        self.reviewerTitle.text = review.reviewerName
        self.reviewerRating.rating = Double(review.rating)!
        
        if review.reviewerImageLink != nil {
            self.reviewerImage.fetchImage(url: review.reviewerImageLink!)
        } else {
            //Set default image
        }
        
        self.reviewText.text = review.review
    }
}
