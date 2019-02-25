//
//  MyReviewViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/25.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit

class MyReviewViewController: UIViewController {

    @IBOutlet weak var textReview: UITextView!
    @IBOutlet weak var cosmosView: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor

        //Set current rating if user already has a review here
    }
    


}
