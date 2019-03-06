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
    
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "https://www.goodreads.com/recommendations") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

}
