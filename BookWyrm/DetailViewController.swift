//
//  DetailViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/11.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController {

    @IBOutlet var detailDescriptionLabel: UILabel!
    
    
    var detailBook: Book? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detailBook = detailBook {
            if let detailDescriptionLabel = detailDescriptionLabel {
                detailDescriptionLabel.text = detailBook.author
                title = detailBook.title
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
}
