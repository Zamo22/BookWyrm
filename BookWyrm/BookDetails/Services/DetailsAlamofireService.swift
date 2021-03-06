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
import SWXMLHash

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
            guard let iDreamKey = Bundle.main.object(forInfoDictionaryKey: "iDreamBooks_Key") else {
                return
            }
            let urlWithSpaces = "https://idreambooks.com/api/books/reviews.json?q=\(reviewData)&key=\(iDreamKey)"
            
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
    
    func getBook(_ bookId: String) {
        let uiTesting = ProcessInfo.processInfo.arguments.contains("Testing")
        if uiTesting {
            if let path = Bundle.main.path(forResource: "\(bookId)_Details", ofType: "xml") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    let xml = SWXMLHash.parse(data)
                    repo?.parseExtraDetails(xml)
                } catch let error {
                    print("parse error: \(error.localizedDescription)")
                }
            } else {
                print("Invalid filename/path.")
            }
        } else {
            guard let goodreadsKey = Bundle.main.object(forInfoDictionaryKey: "Goodreads_Key") else {
                return
            }
            let url = "https://www.goodreads.com/book/show/\(bookId)?key=\(goodreadsKey)"
            Alamofire.request(url, method: .get).response { response in
                
                guard let data = response.data else {
                    self.repo?.errorAlert("error4") //Add error 4 or fix code
                    return
                }
                //Add another guard
                let xml = SWXMLHash.parse(data)
                self.repo?.parseExtraDetails(xml)
            }
        }
    }
}
