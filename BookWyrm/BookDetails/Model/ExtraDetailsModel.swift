//
//  ExtraDetailsModel.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/04/17.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

struct ExtraDetailsModel {
    var avgRating: String
    var numReviews: String
    var yearPublished: String
    var publisher: String
    var details: String
    var similarBooks: [SimilarBook]
}
