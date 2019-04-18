//
//  SearchResultsTableViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/12.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit
import SwiftyJSON
import OAuthSwift
import SafariServices

class SearchResultsTableViewController: UITableViewController {
    
    private var searchResults = [SearchModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var model: SearchViewModelling = { return SearchViewModel(view: self, repo: SearchRepository()) }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
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
        //***Change***
        return model.countResults(searchResults)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        cell.bookTitleLabel.text = searchResults[indexPath.row].title
        cell.bookAuthorLabel.text = searchResults[indexPath.row].authors
        cell.bookImage.fetchImage(url: searchResults[indexPath.row].smallImageUrl)
        cell.backgroundColor = ThemeManager.currentTheme().secondaryColor
        cell.bookAuthorLabel.textColor = .white
        cell.bookTitleLabel.textColor = .white
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    //When selecting an item on the list, before moving to detail page,
    //copy out necessary details at that point and send it to the detail page to display there
    //**Consider just sending the entire JSON object at this point to shorten code
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // try loading the "Detail" view controller and typecasting it to be DetailViewController
            model.detailsForPage(result: searchResults[indexPath.row])
    }
    
}
extension SearchResultsTableViewController: SearchResultsTableViewControllable {
    
    func setResults(results: [SearchModel]) {
        searchResults = results
    }
    
    func moveToDetailsPage(bookModel: SearchModel) {
        if let vControl = storyboard?.instantiateViewController(withIdentifier: "NewDetail") as? NewDetailViewController {
            vControl.bookModel = bookModel
            navigationController?.pushViewController(vControl, animated: true)
        }
    }
    
    func displayErrorPopup(_ error: String, _ title: String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SearchResultsTableViewController: UISearchBarDelegate {
    
    //Called whenever text changes, checks if minimum time interval has passed, and if so, calls fetchResults
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            return
        }
        model.searchText(textToSearch: textToSearch)
    }

    //Empty out search results
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults.removeAll()
    }
}
