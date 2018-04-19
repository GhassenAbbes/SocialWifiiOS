//
//  CustomTabBarController.swift
//  SocialWifi
//
//  Created by Ahmed BHD on 4/18/18.
//  Copyright © 2018 esprit. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let MapController = FavouriteViewController()
        //let navigationController = UINavigationController(rootViewController: MapViewController)
        MapController.title="Map"
        MapController.tabBarItem.title = "Map"
        MapController.tabBarItem.image = UIImage(named: "wifimap")
        self.viewControllers = [MapController]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
