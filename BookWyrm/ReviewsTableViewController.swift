//
//  ReviewsTableViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/15.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReviewsTableViewController: UITableViewController {
    
    var reviewDetails: String?
    
    private var reviewResults = [JSON]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let apiFetcher = APIRequestFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        
        if let reviewData = reviewDetails{
            fetchResults(for: reviewData)
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reviewResults.count
    }
    
    func fetchResults(for text: String) {
        apiFetcher.fetchReviews(reviewData: text, completionHandler: {
            [weak self] results, error in
            if case .failure = error {
                return
            }
            
            guard let results = results, !results.isEmpty else {
                return
            }
            
            self?.reviewResults = results
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as! ReviewsTableViewCell
        
        let italicFont = UIFont.italicSystemFont(ofSize: 16)
        
        let snippet = reviewResults[indexPath.row]["snippet"].stringValue
        cell.reviewText.text = snippet
        
        cell.backgroundColor = ThemeManager.currentTheme().secondaryColor
        cell.reviewText.textColor = .white
        cell.reviewText.font = italicFont
        return cell
    }
    
    
}
