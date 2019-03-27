//
//  googleBooksService.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/27.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

class RecommendationsGoogleBooksService: RecommendationsGoogleBooksServicing {
    
    weak var repo: RecommendationsRepositorable?
    
    init(repo: RecommendationsRepositorable) {
        self.repo = repo
    }
    
    
}
