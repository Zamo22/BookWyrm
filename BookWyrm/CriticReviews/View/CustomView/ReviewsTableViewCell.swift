//
//  ReviewsTableViewCell.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/15.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit

class ReviewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reviewText: UILabel!
    @IBOutlet weak var reviewerImage: UIImageView!
    @IBOutlet weak var reviewerName: UILabel!
    @IBOutlet weak var rating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
