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
            self.booksCollectionView.reloadData()
            fetchingActivity.hidesWhenStopped = true
            fetchingActivity.stopAnimating()
        }
    }
    
    private var popularBooks = [RecommendedBooksModel]() {
        didSet {
            self.popularCollectionView.reloadData()
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
            cell.popularBookImage.fetchImage(url: popularBooks[indexPath.row].largeImageUrl)
            cell.smallAuthorLabel.text = popularBooks[indexPath.row].authors
            cell.smallTitleLabel.text = popularBooks[indexPath.row].title
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.booksCollectionView {
            vModel.setBook(books[indexPath.row])
        } else {
            vModel.setBook(popularBooks[indexPath.row])
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
    
    func moveToDetailsPage(_ bookInfo: SearchModel) {
        if let vControl = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vControl.bookModel = bookInfo
            navigationController?.pushViewController(vControl, animated: true)
        }
    }
}
