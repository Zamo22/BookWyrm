//
//  APIRequestFetcher.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/12.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import AlamofireImage
import SWXMLHash

enum NetworkError: Error {
    case failure
    case success
}

class APIRequestFetcher {
    var searchResults = [JSON]()
    
    func search(searchText: String, completionHandler: @escaping ([JSON]?, NetworkError) -> ()) {
        
        let urlToSearch = "https://www.googleapis.com/books/v1/volumes?q=\(searchText)&printType=books&AIzaSyCfP80tkDzTVuCI5jcUf_AfQixydJcHpOM"
        
        //Clean url to avoid errors from spaces
        guard let encodedUrlToSearch = urlToSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        
        Alamofire.request(encodedUrlToSearch).responseJSON { response in
            guard let data = response.data else {
                completionHandler(nil, .failure)
                return
            }
            
            let json = try? JSON(data: data)
            
            
            let results = json?["items"].arrayValue
            
            guard let empty = results?.isEmpty, !empty else {
                completionHandler(nil, .failure)
                return
            }
            
            completionHandler(results, .success)
        }
    }
    
    func fetchImage(imageUrl: String, completionHandler: @escaping (UIImage?, NetworkError) -> ()) {
        
        Alamofire.request(imageUrl, method: .get).responseImage { response in
            guard let image = response.result.value else {
                completionHandler(nil, .failure)
                return
            }
            completionHandler(image, .success)
        }
        
    }
    
    func searchBook(bookId: String, completionHandler: @escaping (XMLIndexer?, NetworkError) -> ()) {
        let url = "https://www.goodreads.com/book/show/\(bookId)?key=9VcjOWtKzmFGW8o91rxXg"
        Alamofire.request(url, method: .get).response{ response in
            
            guard let data = response.data else {
                completionHandler(nil,.failure)
                return
            }
            
            //Add another guard
            let xml = SWXMLHash.parse(data)
            completionHandler(xml, .success)
            
        }
    }
    
    //Fetch reviews given some kind of search data, we use book title as it's the most accurate
    func fetchReviews(reviewData: String, completionHandler: @escaping ([JSON]?, NetworkError) -> ()) {
        let urlWithSpaces = "https://idreambooks.com/api/books/reviews.json?q=\(reviewData)&key=64f959b1d802bf39f22b52e8114cace510662582"
        
        guard let url = urlWithSpaces.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            guard let data = response.data else {
                completionHandler(nil, .failure)
                return
            }
            
            let json = try? JSON(data: data)
            
            let results = json?["book"]["critic_reviews"].arrayValue
            
            guard let empty = results?.isEmpty, !empty else {
                completionHandler(nil, .failure)
                return
            }
            
            completionHandler(results, .success)
        }
    }
    
    //May rewrite, seems too long, does the exact same as above but returns whether reviews exist or not
    func checkReviews(reviewData: String, completionHandler: @escaping (Bool, NetworkError) -> ()) {
        let urlWithSpaces = "https://idreambooks.com/api/books/reviews.json?q=\(reviewData)&key=64f959b1d802bf39f22b52e8114cace510662582"
        
        guard let url = urlWithSpaces.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            guard let data = response.data else {
                completionHandler(false, .failure)
                return
            }
            
            let json = try? JSON(data: data)
            
            let results = json?["book"]["critic_reviews"].arrayValue
            
            guard let empty = results?.isEmpty, !empty else {
                completionHandler(false, .failure)
                return
            }
            
            completionHandler(true, .success)
        }
    }
    
}
