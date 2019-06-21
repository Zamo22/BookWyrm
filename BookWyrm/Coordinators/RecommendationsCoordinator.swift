//
//  RecommendationsCoordinator.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/06/21.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import UIKit

class RecommendationsCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        let vc = RecommendationsViewController.instantiate()
        guard let image = UIImage(named: "recommend") else {
            return
        }
        vc.tabBarItem = UITabBarItem(title: "Recommendations", image: image, tag: 0)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func selectBook(for book: SearchModel) {
        let child = DetailsCoordinator(navigationController: navigationController)
        child.selectedBook = book
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
            
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let detailsViewController = fromViewController as? NewDetailViewController {
            childDidFinish(detailsViewController.coordinator)
        }
    }
    
}
