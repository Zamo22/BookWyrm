//
//  ImageExtension.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/04.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import Alamofire

protocol ImageFetcher {
    func fetchImage(url: String)
}

extension UIImageView: ImageFetcher {
    
    func fetchImage(url: String) {
        fetchImageFromUrl(imageUrl: url) { image, _ in
            self.image = image
        }
    }
    
    func fetchImageFromUrl(imageUrl: String, completionHandler: @escaping (UIImage?, NetworkError) -> Void) {
        Alamofire.request(imageUrl, method: .get).responseImage { response in
            guard let image = response.result.value else {
                completionHandler(nil, .failure)
                return
            }
            completionHandler(image, .success)
        }
    }
}
