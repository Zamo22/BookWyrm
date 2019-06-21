//
//  ProfileCoordinator.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/06/21.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import UIKit

class ProfileCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        let vc = ProfileViewController.instantiate()
        guard let image = UIImage(named: "profile") else {
            return
        }
        vc.tabBarItem = UITabBarItem(title: "Profile", image: image, tag: 0)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
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
        
    }
    
}
