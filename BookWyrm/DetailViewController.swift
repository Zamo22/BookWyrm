//
//  DetailViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/11.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit

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
    
    //Maybe change these to lazy variables ?
    //Why do I not just directly assign?? --research
    var selectedTitle: String?
    var selectedAuthor: String?
    var selectedGenre: String?
    var selectedPublishedDate: String?
    var selectedIsbn: String?
    var selectedNumPages: String?
    var selectedDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
    }
    
    func setupView () {
        if let titleToLoad = selectedTitle {
            self.titleLabel.text = titleToLoad
        }
        
        if let authorToLoad = selectedAuthor {
            self.authorLabel.text = authorToLoad
        }
        
        if let descriptionToLoad = selectedDescription {
            self.descriptionText.text = descriptionToLoad
        }
        
        if let genreToLoad = selectedGenre {
            self.genreLabel.text = genreToLoad
        }
        
        if let publishedToLoad = selectedPublishedDate {
            self.publishedLabel.text = publishedToLoad
        }
        
        if let isbnToLoad = selectedIsbn {
            self.isbnLabel.text = isbnToLoad
        }
        
        if let pagesToLoad = selectedNumPages {
            self.pagesLabel.text = pagesToLoad
        }
        
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        
        if(true) { //Modify this later
            readingListButton.setImage(UIImage(named: "bookmark"), for:  .normal)
        }
    }
    
    
    @IBAction func clickReviews(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Reviews") as? ReviewsTableViewController {
        navigationController?.pushViewController(vc, animated: true)
    }
        
    }
    
    
    @IBAction func clickReadingList(_ sender: UIButton) {
    }
    
    @IBAction func clickReadingLink(_ sender: UIButton) {
    }
    
}
