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
        
        let urlToSearch = "https://www.googleapis.com/books/v1/volumes?q=\(searchText)&AIzaSyCfP80tkDzTVuCI5jcUf_AfQixydJcHpOM"
        
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
    
}
