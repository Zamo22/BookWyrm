//
//  googleBooksService.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/27.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

//Delete this later
class RecommendationsGoogleBooksService: RecommendationsGoogleBooksServicing {
    
    weak var repo: RecommendationsRepositorable?
    
    init(repo: RecommendationsRepositorable) {
        self.repo = repo
    }
    
    func getBookData(_ bookName: String, completionHandler: @escaping (JSON) -> Void) {
        let urlToSearch = "https://www.googleapis.com/books/v1/volumes?q=\(bookName)&printType=books&AIzaSyCfP80tkDzTVuCI5jcUf_AfQixydJcHpOM"
        //Clean url to avoid errors from spaces
        guard let encodedUrlToSearch = urlToSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        Alamofire.request(encodedUrlToSearch).responseJSON { response in
            guard let data = response.data else {
                self.repo?.errorAlert("error1")
                return
            }
            
            guard let json = try? JSON(data: data) else {
                return
            }
            completionHandler(json)
        }
    }
    
}
