//
//  ReviewsTableViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/15.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit

class ReviewsTableViewController: UITableViewController {
    
    var reviewDetails: String?
    
    lazy var vModel: CriticReviewsViewModelling = { return CriticReviewsViewModel(view: self, repo: CriticReviewsRepository()) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        
        if let reviewData = reviewDetails {
            vModel.fetchResults(for: reviewData)
        }
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        if let reviewData = reviewDetails {
            vModel.fetchResults(for: reviewData)
        }
        
        // somewhere in your code you might need to call:
        refreshControl.endRefreshing()
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
        let cellInfo =  vModel.getReview(index: indexPath.row)
        cell.reviewText.text = cellInfo.review
        cell.rating.rating = Double(cellInfo.rating)!
        cell.reviewerName.text = cellInfo.reviewerName
        if cellInfo.reviewerImageLink != "" {
            cell.reviewerImage.fetchImage(url: cellInfo.reviewerImageLink!)
        } else {
            cell.reviewerImage.image = UIImage(named: "default")
        }
        cell.reviewText.font = italicFont
        cell.reviewerImage.layer.borderWidth = 1
        cell.reviewerImage.layer.masksToBounds = false
        cell.reviewerImage.layer.borderColor = UIColor.black.cgColor
        cell.reviewerImage.layer.cornerRadius = cell.reviewerImage.frame.height / 2
        cell.reviewerImage.clipsToBounds = true
        return cell
    }
}

extension ReviewsTableViewController: ReviewsControllable {
    
    func reloadTable() {
        tableView.reloadData()
    }

    func displayErrorPopup(_ error: String, _ title: String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
