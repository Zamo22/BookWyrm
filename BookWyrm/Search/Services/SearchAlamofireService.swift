//
//  SearchAlamofireService.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/18.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class SearchAlamofireService: SearchAlamofireServicing {
    var repo: SearchRepositorable?
    
    init(repo: SearchRepositorable) {
        self.repo = repo
    }
    
    func getSearchResults(_ searchText: String) {
        let uiTesting = ProcessInfo.processInfo.arguments.contains("Testing")
        
        if uiTesting {
            if let path = Bundle.main.path(forResource: "\(searchText)_Result", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    let jsonObj = try JSON(data: data)
                    repo?.decodeResults(json: jsonObj)
                } catch let error {
                    print("parse error: \(error.localizedDescription)")
                }
            } else {
                print("Invalid filename/path.")
            }
        }
        else {
            let urlToSearch = "https://www.googleapis.com/books/v1/volumes?q=\(searchText)&printType=books&AIzaSyCfP80tkDzTVuCI5jcUf_AfQixydJcHpOM"
            //Clean url to avoid errors from spaces
            guard let encodedUrlToSearch = urlToSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return
            }
            
            Alamofire.request(encodedUrlToSearch).responseJSON { response in
                guard let data = response.data else {
                    self.repo?.errorBuilder("error1")
                    return
                }
                
                let json = try? JSON(data: data)
                self.repo?.decodeResults(json: json)
            }
        }
    }
}
