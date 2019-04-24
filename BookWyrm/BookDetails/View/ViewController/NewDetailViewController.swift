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
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var secondLoadActivity: UIActivityIndicatorView!
    
    var reviewDetailsToSend: String?
    var readingLink: String?
    
    var bookModel: SearchModel?
    var newModel: ExtraDetailsModel?
    
    lazy var model: DetailViewModelling = { return DetailViewModel(view: self, repo: DetailRepository()) }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        secondLoadActivity.startAnimating()
        secondLoadActivity.hidesWhenStopped = true
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
            vControl.title = "Review for: \(bookTitle.text ?? "Error - No book")"
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
            if let convertedRating = Double(rating) {
                self.bookAverageRating.rating = convertedRating
            }
        }
        
        if let numRatings = newModel?.numReviews {
            self.bookNumRatings.text = numRatings
        }
        
        if let desc = newModel?.details {
            if self.bookSynopsis.text == "" {
                self.bookSynopsis.text = desc
            }
        }
        
        var count = 0
        if let similar = newModel?.similarBooks {
            for book in similar {
                if count < 4 {
                    switch count {
                    case 0: similarBook1.fetchImage(url: book.imageLink)
                    let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(NewDetailViewController.image1Tapped(gesture:)))
                    similarBook1.addGestureRecognizer(tapGesture1)
                    similarBook1.isUserInteractionEnabled = true
                        break
                    case 1: similarBook2.fetchImage(url: book.imageLink)
                    let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(NewDetailViewController.image2Tapped(gesture:)))
                    similarBook2.addGestureRecognizer(tapGesture2)
                    similarBook2.isUserInteractionEnabled = true
                        break
                    case 2: similarBook3.fetchImage(url: book.imageLink)
                    let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(NewDetailViewController.image3Tapped(gesture:)))
                    similarBook3.addGestureRecognizer(tapGesture3)
                    similarBook3.isUserInteractionEnabled = true
                        break
                    case 3: similarBook4.fetchImage(url: book.imageLink)
                    let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(NewDetailViewController.image4Tapped(gesture:)))
                    similarBook4.addGestureRecognizer(tapGesture4)
                    similarBook4.isUserInteractionEnabled = true
                    default: break
                    }
                    count += 1
                }
            }
        }
    }
    
    @objc func image1Tapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            let book = newModel?.similarBooks[0]
            openSimilarBook(book: book)
        }
    }
    
    func openSimilarBook(book: SimilarBook?) {
        if let title = book?.title {
            let bookModel = SearchModel(title: title, authors: book!.author, smallImageUrl: book!.imageLink, largeImageUrl: book!.imageLink, publishedDate: "", reviewInfo: book!.isbn, isbn: book!.isbn, pageNumbers: book!.pages, genres: nil, description: "", webLink: book!.bookLink)
            if let vControl = storyboard?.instantiateViewController(withIdentifier: "NewDetail") as? NewDetailViewController {
                vControl.bookModel = bookModel
                navigationController?.pushViewController(vControl, animated: true)
            }
        }
    }
    
    @objc func image2Tapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            let book = newModel?.similarBooks[1]
            openSimilarBook(book: book)
            
        }
    }
    
    @objc func image3Tapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            let book = newModel?.similarBooks[2]
            openSimilarBook(book: book)
            
        }
    }
    
    @objc func image4Tapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            let book = newModel?.similarBooks[3]
            openSimilarBook(book: book)
            
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
        secondLoadActivity.stopAnimating()
        if read {
            self.bookmarkButton.setImage(UIImage(named: "bookmarkFilled2"), for: .normal)
        } else {
            self.bookmarkButton.setImage(UIImage(named: "bookmark2"), for: .normal)
        }
    }
    
    func setReviewVisibility(hasReviews: Bool) {
        if !hasReviews {
            self.reviewerTitle.text = ""
            self.reviewerRating.isHidden = true
            self.reviewText.text = "\n \t NO CRITIC REVIEWS FOUND"
            self.reviewText.font = UIFont(name: "Helvetica-Bold", size: 18)
            self.seeAllButton.isHidden = true
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
        guard let convertedRating = Double(review.rating) else {
            return
        }
        self.reviewerRating.rating = convertedRating
        
        if review.reviewerImageLink != nil && review.reviewerImageLink != ""{
            self.reviewerImage.fetchImage(url: review.reviewerImageLink!)
        } else {
            self.reviewerImage.image = UIImage(named: "default")
        }
        
        self.reviewerImage.layer.borderWidth = 1
        self.reviewerImage.layer.masksToBounds = false
        self.reviewerImage.layer.borderColor = UIColor.black.cgColor
        self.reviewerImage.layer.cornerRadius = self.reviewerImage.frame.height / 2
        self.reviewerImage.clipsToBounds = true
        
        self.reviewText.text = review.review
    }
}
