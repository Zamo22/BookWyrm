//
//  ReviewsTableViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/15.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ReviewsControllable: class {
    func reloadTable()
}

class ReviewsTableViewController: UITableViewController {
    
    var reviewDetails: String?
    
    private var reviewResults = [JSON]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var vModel: CriticReviewsViewModelling = { return CriticReviewsViewModel(view: self) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        
        if let reviewData = reviewDetails {
            vModel.fetchResults(for: reviewData)
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
        return vModel.countResults()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReviewsTableViewCell
        let italicFont = UIFont.italicSystemFont(ofSize: 16)
        cell.reviewText.text = vModel.getReview(index: indexPath.row)
        cell.backgroundColor = ThemeManager.currentTheme().secondaryColor
        cell.reviewText.textColor = .white
        cell.reviewText.font = italicFont
        return cell
    }
}

extension ReviewsTableViewController: ReviewsControllable {
    func reloadTable() {
        tableView.reloadData()
    }
}
