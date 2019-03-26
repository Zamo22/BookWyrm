//
//  DetailsAlamofireService.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/19.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DetailsAlamofireService: DetailsAlamofireServicing {
    weak var repo: DetailRepositorable?
    
    init(repo: DetailRepositorable) {
        self.repo = repo
    }
    
    func checkReviews(_ reviewData: String) {
        let uiTesting = ProcessInfo.processInfo.arguments.contains("Testing")
        
        if uiTesting {
            if let path = Bundle.main.path(forResource: "\(reviewData)_Reviews", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    let jsonObj = try JSON(data: data)
                    repo?.decodeReviewCheck(json: jsonObj)
                } catch let error {
                    print("parse error: \(error.localizedDescription)")
                }
            } else {
                print("Invalid filename/path.")
            }

        } else {
            let urlWithSpaces = "https://idreambooks.com/api/books/reviews.json?q=\(reviewData)&key=64f959b1d802bf39f22b52e8114cace510662582"
            
            guard let url = urlWithSpaces.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return
            }
            
            Alamofire.request(url).responseJSON { response in
                guard let data = response.data else {
                    self.repo?.errorAlert("error1")
                    return
                }
                let json = try? JSON(data: data)
                self.repo?.decodeReviewCheck(json: json)
            }
        }
    }
}