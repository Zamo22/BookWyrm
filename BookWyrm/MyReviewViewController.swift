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

class MyReviewViewController: UIViewController {

    @IBOutlet weak var textReview: UITextView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var buttonPost: UIButton!
    
    var userId: String?
    var oauthswift: OAuthSwift?
    var bookId: String?
    var reviewId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        
        textReview.layer.borderWidth = 1.2
        textReview.layer.cornerRadius = 5
        textReview.layer.borderColor = UIColor.black.cgColor
        
        if reviewId != nil {
            getReview {[weak self] review, rating in
                self?.textReview.text = review
                self?.cosmosView.rating = Double(rating)!
            }
        }
    }
    
    func getReview(callback: @escaping (_ review: String, _ rating: String) -> Void) {
        let oauthSwift : OAuth1Swift = oauthswift as! OAuth1Swift
        
        _ = oauthSwift.client.get(
            "https://www.goodreads.com/review/show.xml?id=\(reviewId ?? "")&key=9VcjOWtKzmFGW8o91rxXg",
            success: { response in
                
                /** parse the returned xml to read user id **/
                let dataString = response.string!
                let xml = SWXMLHash.parse(dataString)
                let review =  (xml["GoodreadsResponse"]["review"]["body"].element?.text)
                let rating = (xml["GoodreadsResponse"]["review"]["rating"].element?.text)
                
                callback(review!,rating!)
                
        }, failure: { error in
            print(error)
        }
        )
        
    }

    @IBAction func clickPostReview(_ sender: UIButton) {
        let review = textReview.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let rating = cosmosView.rating
        let oauthSwift : OAuth1Swift = oauthswift as! OAuth1Swift
        
        if reviewId == nil {
        //Add further options later on (set read status)
        let params: [String : Any] = [
            "book_id": bookId!,
            "review[review]": review,
            "review[rating]": rating
        ]
            
        _ = oauthSwift.client.post("https://www.goodreads.com/review.xml", parameters: params,
                                   success: {[weak self] response in
                                    self?.navigationController?.popViewController(animated: true)},
                                   failure: {error in
                                    print(error)
        })
        } else {
            let params: [String : Any] = [
                "review[review]": review,
                "review[rating]": rating
            ]
            
            _ = oauthSwift.client.post("https://www.goodreads.com/review/\(reviewId ?? "").xml", parameters: params,
                                       success: {[weak self] response in
                                        self?.navigationController?.popViewController(animated: true)},
                                       failure: {error in
                                        print(error)
            })
    }
    

 }
}
