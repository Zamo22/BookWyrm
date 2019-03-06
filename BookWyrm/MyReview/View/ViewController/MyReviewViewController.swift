//
//  MyReviewViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/25.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit
import OAuthSwift
import SWXMLHash

protocol MyReviewViewControllable: class {
    func setReviewInfo(_ review: String, _ rating: Double)
    func returnToPrevScreen()
}

class MyReviewViewController: UIViewController {

    @IBOutlet weak var textReview: UITextView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var buttonPost: UIButton!
    
    lazy var vModel: MyReviewViewModelling = { return MyReviewViewModel(view: self) }()
    
    var oauthswift: OAuthSwift?
    var bookId: String?
    var reviewId: String?
    
    var detailModel: DetailsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        
        textReview.layer.borderWidth = 1.2
        textReview.layer.cornerRadius = 5
        textReview.layer.borderColor = UIColor.black.cgColor
        
        if let revId = detailModel?.reviewId {
            vModel.getReview(reviewId: revId)
        }
        
    }
    

    @IBAction func clickPostReview(_ sender: UIButton) {
        let review = textReview.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let rating = cosmosView.rating
        
        vModel.postReview(review, rating, detailModel)
 }
}

extension MyReviewViewController: MyReviewViewControllable {
    func returnToPrevScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setReviewInfo(_ review: String, _ rating: Double) {
        self.textReview.text = review
        self.cosmosView.rating = rating
    }
    
    
}
