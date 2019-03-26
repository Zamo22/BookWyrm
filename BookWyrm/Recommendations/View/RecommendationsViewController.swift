//
//  RecommendationsViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/06.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit
import WebKit

class RecommendationsViewController: UIViewController {
    
    @IBOutlet weak var booksCollectionView: UICollectionView!
    
    lazy var vModel: RecommendationsViewModelling = { return RecommendationsViewModel(view: self, repo: RecommendationsRepository()) }()
    var shit = ["https://images.gr-assets.com/books/1474169725m/15881.jpg","https://images.gr-assets.com/books/1474169725m/15881.jpg","https://images.gr-assets.com/books/1474169725m/15881.jpg"]

    override func viewDidLoad() {
        super.viewDidLoad()
        vModel.fetchBookList()
        booksCollectionView.reloadData()
    }
}

extension RecommendationsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath as IndexPath)
            as? CustomCollectionViewCell else {
                return CustomCollectionViewCell()
        }
        cell.bookImage.fetchImage(url: shit[indexPath.row])
        return cell
    }
}

extension RecommendationsViewController: RecommendationsControllable {
    
}
