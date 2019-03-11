//
//  PlainShelfController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/19.
//  Copyright © 2019 DVT. All rights reserved.
//

import ShelfView

class PlainShelfController: UIViewController, PlainShelfViewDelegate {
    var shelfView: PlainShelfView!

    lazy var vModel: ShelfViewModelling = { return ShelfViewModel(view: self, repo: ShelfRepository()) }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Create shelfview
        shelfView = PlainShelfView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
                                   bookModel: vModel.getModel(), bookSource: PlainShelfView.BOOK_SOURCE_URL)
        shelfView.tag = 100
        shelfView.delegate = self
        self.view.addSubview(shelfView)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if let viewWithTag = self.view.viewWithTag(100) {
//            viewWithTag.removeFromSuperview()
//        }
//        shelfView = PlainShelfView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
//                                   bookModel: vModel.getModel(), bookSource: PlainShelfView.BOOK_SOURCE_URL)
//        shelfView.tag = 100
//        self.view.addSubview(shelfView)
//    }
    
    //Will Add code here to animate clicking book
    func onBookClicked(_ shelfView: PlainShelfView, index: Int, bookId: String, bookTitle: String) {
            vModel.getBook(bookId)
    }

    //Handles removing current subview and
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        shelfView = PlainShelfView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
                                   bookModel: vModel.getModel(), bookSource: PlainShelfView.BOOK_SOURCE_URL)
        shelfView.tag = 100
        self.view.addSubview(shelfView)
    }
}

extension PlainShelfController: PlainShelfControllable {
    func reloadData(_ bookModel: [BookModel]) {
        self.shelfView.reloadBooks(bookModel: bookModel)
    }
    
    func moveToDetailsPage(_ bookInfo: SearchModel) {
        if let vControl = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                vControl.bookModel = bookInfo
                navigationController?.pushViewController(vControl, animated: true)
        }
    }
}
