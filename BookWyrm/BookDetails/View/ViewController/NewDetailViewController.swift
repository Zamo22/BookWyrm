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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        doRemainingSetup()
    }
    

    @IBAction func openBookLink(_ sender: UIButton) {
        let svc = SFSafariViewController(url: URL(string: readingLink!)!)
        self.present(svc, animated: true, completion: nil)
    }
    
    @IBAction func bookmarkBook(_ sender: UIButton) {
        
    }
    @IBAction func seeAllReviews(_ sender: UIButton) {
        
    }
    
    @IBAction func leaveReview(_ sender: UIButton) {
        
    }
    
    func doRemainingSetup() {
        if let publisher = newModel?.publisher {
            if let year = newModel?.yearPublished {
                self.bookPublisherInfo.text = "\(publisher) (\(year))"
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
        
//        if let reviewDetailsToSend = reviewDetailsToSend {
//            model.checkIfInList(reviewDetailsToSend)
//            model.checkReviews(reviewDetailsToSend)
//        }
        
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
        //self.newModel = model
    }
}
