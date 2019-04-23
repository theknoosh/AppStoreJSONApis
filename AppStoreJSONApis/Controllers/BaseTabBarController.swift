//
//  BaseTabBarController.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 4/16/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // How to change the colors on the tabbar
//        tabBar.tintColor = .yellow
//        tabBar.barTintColor = .blue
        
        viewControllers = [
            createNavController(viewController: AppsController(), title: "Apps", imageName: "apps"),
            createNavController(viewController: AppSearchController(), title: "Search", imageName: "search"),
            createNavController(viewController: UIViewController(), title: "Today", imageName: "today_icon")
        ]
//        UICollectionViewController(collectionViewLayout: UICollectionViewLayout())
        
    }
    
    fileprivate func createNavController(viewController:UIViewController, title:String, imageName:String)-> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        
        return navController
        
    }
}
