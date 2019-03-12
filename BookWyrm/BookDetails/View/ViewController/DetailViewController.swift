//
//  DetailViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/11.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit
import OAuthSwift
import SafariServices
import SWXMLHash
import PopMenu

class DetailViewController: UIViewController {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var pagesLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var reviewsButton: UIButton!
    @IBOutlet weak var readingListButton: UIButton!
    @IBOutlet weak var readingLinkButton: UIButton!
    
    var reviewDetailsToSend: String?
    var readingLink: String?
    
    var bookModel: SearchModel?
    
    lazy var model: DetailViewModelling = { return DetailViewModel(view: self, repo: DetailRepository()) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        if let titleToLoad = bookModel?.title {
            self.titleLabel.text = titleToLoad
            self.titleLabel.textColor = .white
        }
        
        if let authorToLoad = bookModel?.authors {
            self.authorLabel.text = authorToLoad
            self.authorLabel.textColor = .white
        }
        
        if let descriptionToLoad = bookModel?.description {
            self.descriptionText.text = descriptionToLoad
            self.descriptionText.textColor = .white
        }
        
        if let genreToLoad = bookModel?.genres {
            self.genreLabel.text = genreToLoad
            self.genreLabel.textColor = .white
        } else {
            self.genreLabel.isHidden = true
        }
        
        if let publishedToLoad = bookModel?.publishedDate {
            self.publishedLabel.text = publishedToLoad
            self.publishedLabel.textColor = .white
        }
        
        if let isbnToLoad = bookModel?.isbn {
            self.isbnLabel.text = isbnToLoad
            self.isbnLabel.textColor = .white
        }
        
        if let pagesToLoad = bookModel?.pageNumbers {
            self.pagesLabel.text = pagesToLoad
            self.pagesLabel.textColor = .white
        }
        
        if let url = bookModel?.largeImageUrl {
            self.bookImageView.fetchImage(url: url)
        }
        
        readingLink = bookModel?.webLink
        reviewDetailsToSend = bookModel?.reviewInfo
        
        if let reviewDetailsToSend = reviewDetailsToSend {
            model.checkIfInList(reviewDetailsToSend) { [weak self] check in
                if !check {
                    self?.readingListButton.setImage(UIImage(named: "bookmark"), for: .normal)
                } else {
                    self?.readingListButton.setImage(UIImage(named: "bookmarkFilled"), for: .normal)
                }
            }
            
            model.checkReviews(reviewDetailsToSend)
        }
        
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        
        if readingLink == nil {
            self.readingLinkButton.isHidden = true
        }
    }
    
    @IBAction func clickReviews(_ sender: UIButton) {
        let manager = PopMenuManager.default
        manager.actions = [
            PopMenuDefaultAction(title: "Critic Reviews"),
            PopMenuDefaultAction(title: "My Review")
        ]
        
        manager.popMenuDelegate = self
        manager.present(sourceView: reviewsButton)
    }
    
    @IBAction func clickReadingList(_ sender: UIButton) {
        //Add or remove item from reading list
        model.modifyBookshelf()
    }
    
    @IBAction func clickReadingLink(_ sender: UIButton) {
        //open webview with link to buy/read book
        //Might do this directly in Safari
        let svc = SFSafariViewController(url: URL(string: readingLink!)!)
        self.present(svc, animated: true, completion: nil)
    }
}

extension DetailViewController: PopMenuViewControllerDelegate {
    func popMenuDidSelectItem(_ popMenuViewController: PopMenuViewController, at index: Int) {
        if index == 0 {
            if let vControl = storyboard?.instantiateViewController(withIdentifier: "Reviews") as? ReviewsTableViewController {
                vControl.reviewDetails = reviewDetailsToSend
                vControl.title = "Reviews for: \(reviewDetailsToSend ?? "Error - No book")"
                navigationController?.pushViewController(vControl, animated: true)
            }
        } else {
            if let vControl = storyboard?.instantiateViewController(withIdentifier: "MyReview") as? MyReviewViewController {
                vControl.title = "Review for: \(reviewDetailsToSend ?? "Error - No book")"
                let detailModel = model.getModel()
                vControl.detailModel = detailModel
                navigationController?.pushViewController(vControl, animated: true)
            }
        }
    }
}

extension DetailViewController: DetailViewControllable {
    
    func setReadStatus(read: Bool) {
        if read {
        self.readingListButton.setImage(UIImage(named: "bookmarkFilled"), for: .normal)
        } else {
         self.readingListButton.setImage(UIImage(named: "bookmark"), for: .normal)
        }
    }

    func setReviewVisibility(hasReviews: Bool) {
        if !hasReviews {
           self.reviewsButton.isHidden = true
        }
    }
}
