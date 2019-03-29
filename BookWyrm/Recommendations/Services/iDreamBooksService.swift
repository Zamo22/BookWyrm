//
//  iDreamBooksService.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/28.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

class iDreamBooksService: iDreamBooksServicing {
    weak var repo: RecommendationsRepositorable?
    
    init(repo: RecommendationsRepositorable) {
        self.repo = repo
    }
}
