//
//  SearchResultsTableViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/12.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SafariServices

class SearchResultsTableViewController: UITableViewController {

    private var searchResults = [JSON]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let apiFetcher = APIRequestFetcher()
    
    //To avoid the search running constantly as we type
    private var previousRun = Date()
    private let minInterval = 0.05
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        setupTableViewBackgroundView()
        setupSearchBar()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }
    
    private func setupTableViewBackgroundView() {
        let backgroundViewLabel = UILabel(frame: .zero)
        backgroundViewLabel.textColor = .darkGray
        backgroundViewLabel.numberOfLines = 0
        backgroundViewLabel.text = " Sorry, No books found "
        backgroundViewLabel.textAlignment = NSTextAlignment.center
        backgroundViewLabel.font.withSize(20)
        tableView.backgroundView = backgroundViewLabel
    }
    
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a Book"
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as! CustomTableViewCell
        
        cell.bookTitleLabel.text = searchResults[indexPath.row]["volumeInfo"]["title"].stringValue
        
        let authors = searchResults[indexPath.row]["volumeInfo"]["authors"].arrayValue
        cell.bookAuthorLabel.text = authors.first?.stringValue
        
        //Add other authors later
        /*
        for author in authors{
            cell.bookAuthorLabel.text? += "\(author.stringValue) "
        }
         */
        
        if let url = searchResults[indexPath.row]["volumeInfo"]["imageLinks"]["smallThumbnail"].string {
            apiFetcher.fetchImage(imageUrl: url, completionHandler: { image, _ in
                cell.bookImage.image = image
            })
        }
 
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = searchResults[indexPath.row]["title"].stringValue
        guard let url = URL.init(string: "https://en.wikipedia.org/wiki/\(title)")
            else { return }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
 */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedTitle = searchResults[indexPath.row]["volumeInfo"]["title"].stringValue
            let authors = searchResults[indexPath.row]["volumeInfo"]["authors"].arrayValue
            vc.selectedAuthor = authors.first?.stringValue
            
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    

}

extension SearchResultsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            return
        }
        
        if Date().timeIntervalSince(previousRun) > minInterval {
            previousRun = Date()
            fetchResults(for: textToSearch)
        }
    }
    
    func fetchResults(for text: String) {
        print("Text Searched: \(text)")
        apiFetcher.search(searchText: text, completionHandler: {
            [weak self] results, error in
            if case .failure = error {
                return
            }
            
            guard let results = results, !results.isEmpty else {
                return
            }
            
            self?.searchResults = results
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults.removeAll()
    }
    
}
