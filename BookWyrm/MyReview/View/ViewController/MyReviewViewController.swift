//
//  MyReviewViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/25.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit
import OAuthSwift

class MyReviewViewController: UIViewController {

    @IBOutlet weak var textReview: UITextView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var buttonPost: UIButton!
    
    lazy var vModel: MyReviewViewModelling = { return MyReviewViewModel(view: self, repo: MyReviewRepository()) }()
    
    var oauthswift: OAuthSwift?
    var bookId: String?
    var reviewId: String?
    
    var detailModel: DetailsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let revId = detailModel?.reviewId {
            vModel.getReview(reviewId: revId)
        }
    }

    @IBAction func postReview(_ sender: UIBarButtonItem) {
        let review = textReview.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let rating = cosmosView.rating
        guard let model: DetailsModel = detailModel else {
            return
        }
        vModel.postReview(review, rating, model)
    }
    
}

extension MyReviewViewController: MyReviewViewControllable {
    func returnToPrevScreen() {
        self.navigationController?.popViewController(animated: true)
    }

    func setReviewInfo(_ review: String, _ rating: Double) {
        //Had to write code badly like this or it wasnt working weirdly
        if review != "" && review != "\n"{
           self.textReview.text = review
        }
        self.cosmosView.rating = rating
    }
    
    func displayErrorPopup(_ error: String, _ title: String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
