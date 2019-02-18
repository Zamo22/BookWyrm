//
//  SearchResultsTableViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/12.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchResultsTableViewController: UITableViewController {

    //My note: We use this variable throughout the controller to show the current search data
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    //Setting background view to display no books found, that way when there are no search results,
    //it just shows the background
    
    private func setupTableViewBackgroundView() {
        let backgroundViewLabel = UILabel(frame: .zero)
        backgroundViewLabel.textColor = .white
        backgroundViewLabel.numberOfLines = 0
        backgroundViewLabel.text = " Sorry, No books found "
        backgroundViewLabel.textAlignment = NSTextAlignment.center
        backgroundViewLabel.font.withSize(20)
        tableView.backgroundView = backgroundViewLabel
        tableView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    }
    
    //Sets up the search bar element
    
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a Book"
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    //Populates each cell of the table with data from the respective search results
    //Work on making this code neater
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as! CustomTableViewCell
        
        cell.bookTitleLabel.text = searchResults[indexPath.row]["volumeInfo"]["title"].stringValue
        
        let authors = searchResults[indexPath.row]["volumeInfo"]["authors"].arrayValue
        cell.bookAuthorLabel.text = "By: \(authors.first?.stringValue ?? "None Found")"
        
        var skipFirst = true
        
        for author in authors{
            if (skipFirst)
            {
                skipFirst = false
            }
            else{
                cell.bookAuthorLabel.text = "\(cell.bookAuthorLabel.text ?? "") , \(author.stringValue)"
            }
        }
        
        if let url = searchResults[indexPath.row]["volumeInfo"]["imageLinks"]["smallThumbnail"].string {
            apiFetcher.fetchImage(imageUrl: url, completionHandler: { image, _ in
                cell.bookImage.image = image
            })
        }
        
        cell.backgroundColor = ThemeManager.currentTheme().secondaryColor
        cell.bookAuthorLabel.textColor = .white
        cell.bookTitleLabel.textColor = .white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    //When selecting an item on the list, before moving to detail page, copy out necessary details at that point and send it to the detail page to display there
    //**Consider just sending the entire JSON object at this point to shorten code
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            vc.selectedTitle = searchResults[indexPath.row]["volumeInfo"]["title"].stringValue
            
            let authors = searchResults[indexPath.row]["volumeInfo"]["authors"].arrayValue
            vc.selectedAuthor = "By: \(authors.first?.stringValue ?? "None Found")"
            
            var skipFirst = true
            
            for author in authors{
                if (skipFirst)
                {
                    skipFirst = false
                }
                else{
                    vc.selectedAuthor = "\(vc.selectedAuthor ?? "") , \(author.stringValue)"
                }
            }
            
            vc.selectedPublishedDate  = "Date Published: \(searchResults[indexPath.row]["volumeInfo"]["publishedDate"].stringValue)"
            
            //Must check first if reviews are available then error avoided
            vc.reviewDetailsToSend = searchResults[indexPath.row]["volumeInfo"]["title"].stringValue
            
            vc.selectedIsbn = "ISBN_13: \(searchResults[indexPath.row]["volumeInfo"]["industryIdentifiers"].arrayValue.first?["identifier"].stringValue ?? "No ISBN found")"
            vc.selectedNumPages = "Pages: \(searchResults[indexPath.row]["volumeInfo"]["pageCount"].stringValue)"
            
            let genres =  searchResults[indexPath.row]["volumeInfo"]["categories"].arrayValue
            vc.selectedGenre = "Genres: \(genres.first?.stringValue ?? "No genres")"
            skipFirst = true
            
            for genre in genres{
                if (skipFirst)
                {
                    skipFirst = false
                }
                else{
                    vc.selectedGenre = "\(vc.selectedGenre ?? "") , \(genre.stringValue)"
                }
            }
            
            vc.selectedDescription = searchResults[indexPath.row]["volumeInfo"]["description"].stringValue.removingPercentEncoding
            
            vc.readingLink = searchResults[indexPath.row]["accessInfo"]["webReaderLink"].stringValue
            
            
            if let url = searchResults[indexPath.row]["volumeInfo"]["imageLinks"]["thumbnail"].string {
                apiFetcher.fetchImage(imageUrl: url, completionHandler: { image, _ in
                    vc.bookImageView.image = image
                })
            }
            
            //push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    

}

extension SearchResultsTableViewController: UISearchBarDelegate {
    
    //Called whenever text changes, checks if minimum time interval has passed, and if so, calls fetchResults
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
    
    //Calls the apiFetcher class to perform search and resturn json results
    func fetchResults(for text: String) {
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
    
    //Empty out search results
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults.removeAll()
    }
    
}
