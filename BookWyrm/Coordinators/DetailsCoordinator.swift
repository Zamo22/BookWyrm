//
//  DetailsCoordinator.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/06/21.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import UIKit

class DetailsCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    var selectedBook: SearchModel?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func openAllReviews(for reviewInfo: String?) {
        let child = AllReviewsCoordinator(navigationController: navigationController)
        child.reviewInformation = reviewInfo
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func openSimilarBook() {
        
    }
    
    func openMyReview() {
        
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func start() {
        let vc = NewDetailViewController.instantiate()
        vc.coordinator = self
        vc.bookModel = selectedBook
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let reviewsViewController = fromViewController as? ReviewsTableViewController {
            childDidFinish(reviewsViewController.coordinator)
        }
    }
}
