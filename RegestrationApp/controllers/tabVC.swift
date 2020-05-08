//
//  tabVC.swift
//  RegestrationApp
//
//  Created by ahmedelbasha on 5/4/20.
//  Copyright © 2020 ahmedelbasha. All rights reserved.
//

import UIKit

class tabVC: UITabBarController {



        override func viewDidLoad() {
            super.viewDidLoad()

            let tabBarController = UITabBarController()
            let moviesListVC = UIStoryboard.init(name: Storyboards.media, bundle: nil).instantiateViewController(withIdentifier: VCs.mediaTable) as! MediaTable
            let moviesListPath = UINavigationController.init(rootViewController: moviesListVC)

            let profileVC = UIStoryboard.init(name: Storyboards.profile, bundle: nil).instantiateViewController(withIdentifier: VCs.profileVC) as! ProfileVC
           
            let profilePath = UINavigationController.init(rootViewController: profileVC)

            tabBarController.viewControllers = [moviesListPath, profileVC]

            moviesListPath.tabBarItem.title = "media"
            moviesListPath.tabBarItem.image = UIImage(named: "movie")
            profilePath.tabBarItem.title = "Profile"
            profilePath.tabBarItem.image = UIImage(named: "profile")



            self.tabBarController?.tabBar.isHidden = false
}

}
