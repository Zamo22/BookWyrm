//
//  RecommendationsViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/06.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit

class RecommendationsViewController: UIViewController {
    
    @IBOutlet weak var booksCollectionView: UICollectionView!
    
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    @IBOutlet weak var fetchingActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var secondFetchingActivity: UIActivityIndicatorView!
    
    lazy var vModel: RecommendationsViewModelling = { return RecommendationsViewModel(view: self, repo: RecommendationsRepository()) }()
    
    private var books = [RecommendedBooksModel]() {
        didSet {
            booksCollectionView.reloadData()
            fetchingActivity.hidesWhenStopped = true
            fetchingActivity.stopAnimating()
        }
    }
    
    private var popularBooks = [RecommendedBooksModel]() {
        didSet {
            popularCollectionView.reloadData()
            secondFetchingActivity.hidesWhenStopped = true
            secondFetchingActivity.stopAnimating()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        vModel.fetchBookList()
        fetchingActivity.startAnimating()
        secondFetchingActivity.startAnimating()
    }
}

extension RecommendationsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.booksCollectionView {
        return books.count
        } else {
            return popularBooks.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.booksCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath as IndexPath)
                as? CustomCollectionViewCell else {
                    return CustomCollectionViewCell()
            }
            //cell.bookImage.fetchHighQualityImage(isbn: books[indexPath.row].isbn)
            cell.bookImage.fetchImage(url: books[indexPath.row].largeImageUrl)
            cell.titleLabel.text = books[indexPath.row].title
            cell.authorLabel.text = books[indexPath.row].authors
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallBookCell", for: indexPath as IndexPath)
                as? SmallerCollectionViewCell else {
                    return SmallerCollectionViewCell()
            }
            cell.smallAuthorLabel.text = ""
            cell.smallTitleLabel.text = ""
            return cell
        }
    }
}

extension RecommendationsViewController: RecommendationsControllable {
    
     func setBooksModel(_ books: [RecommendedBooksModel]) {
        self.books = books
    }
    
    func setPopularBooksModel(_ books: [RecommendedBooksModel]) {
        self.popularBooks = books
    }
}
