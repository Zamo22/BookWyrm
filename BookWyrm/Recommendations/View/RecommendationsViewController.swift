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
    
    lazy var vModel: RecommendationsViewModelling = { return RecommendationsViewModel(view: self, repo: RecommendationsRepository()) }()
    
    private var books = [RecommendedBooksModel]() {
        didSet {
            booksCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        vModel.fetchBookList()
        //booksCollectionView.reloadData()
    }
}

extension RecommendationsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath as IndexPath)
            as? CustomCollectionViewCell else {
                return CustomCollectionViewCell()
        }
        
        //cell.bookImage.fetchHighQualityImage(isbn: books[indexPath.row].isbn)
        cell.bookImage.fetchImage(url: books[indexPath.row].largeImageUrl)
        cell.titleLabel.text = books[indexPath.row].title
        cell.authorLabel.text = books[indexPath.row].authors
        return cell
    }
}

extension RecommendationsViewController: RecommendationsControllable {
    
     func setBooksModel(_ books: [RecommendedBooksModel]) {
        self.books = books
    }
}
