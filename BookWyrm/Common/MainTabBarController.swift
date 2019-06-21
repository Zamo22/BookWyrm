//
//  MainTabBarController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/06/21.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let search = SearchCoordinator(navigationController: UINavigationController())
    let shelf = ShelfCoordinator(navigationController: UINavigationController())
    let recommend = RecommendationsCoordinator(navigationController: UINavigationController())
    let profile = ProfileCoordinator(navigationController: UINavigationController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.start()
        shelf.start()
        recommend.start()
        profile.start()
        viewControllers = [search.navigationController, shelf.navigationController, recommend.navigationController, profile.navigationController]
    }
    
}
