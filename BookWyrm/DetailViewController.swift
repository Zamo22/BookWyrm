//
//  DetailViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/11.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    
    //Maybe change these to lazy variables ?
    //Why do I not just directly assign?? --research
    var selectedTitle: String?
    var selectedAuthor: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let titleToLoad = selectedTitle {
            self.titleLabel.text = titleToLoad
        }
        
        if let authorToLoad = selectedAuthor {
            self.authorLabel.text = authorToLoad
        }
    }

}
