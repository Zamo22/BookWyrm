//
//  AllReviewsCoordinator.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/06/21.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import UIKit

class AllReviewsCoordinator: Coordinator {
    weak var parentCoordinator: DetailsCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    var reviewInformation: String?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ReviewsTableViewController.instantiate()
        vc.coordinator = self
        vc.reviewDetails = reviewInformation
        vc.title = "Reviews for: \(reviewInformation ?? "No book found")"
        navigationController.pushViewController(vc, animated: true)
    }
    
}
