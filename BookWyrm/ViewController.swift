//
//  ViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/07.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    
    @IBOutlet var tableView: UITableView!
    
    struct Book{
        var title: String
        var author: String
    }
    
    //Populate array with default books
    var books = [Book(title: "Harry Potter", author: "JK Rowling"),
                 Book(title: "Lord of the Rings", author: "JRR Tolkien"),
                 Book(title: "Game of Thrones", author: "George RR Martin"),
                 Book(title: "The Final Empire", author: "Brandon Sanderson")]
    
    var filteredBooks = [Book]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "wallpaper"))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        filteredBooks = books;
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        //Setting search text to white to be readable with minimal search bar style
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = UIColor.white
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // If we have not typed anything into the search bar then don't do anything
        if searchController.searchBar.text! == "" {
            filteredBooks = books
        } else {
            //If we have, then filter
            filteredBooks = books.filter { $0.title.lowercased().contains(searchController.searchBar.text!.lowercased()) || $0.author.lowercased().contains(searchController.searchBar.text!.lowercased())}
        }
        
        //Repopulate table
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = self.filteredBooks[indexPath.row].title
        cell.detailTextLabel?.text = self.filteredBooks[indexPath.row].author
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row) selected")
    }
        
        
    }




