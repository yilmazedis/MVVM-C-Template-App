//
//  MainTabBarViewController.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 9.03.2024.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabbar()
        SetUINavigationBar()
    }
    
    private func setTabbar() {
        let home = HomeCoordinator().startTabbar()
        let upcoming = UINavigationController(rootViewController: DownloadsViewController())
        let search = UINavigationController(rootViewController: SearchViewController())
        let download = UINavigationController(rootViewController: DownloadsViewController())
        
        home.tabBarItem.image = UIImage(systemName: "house")
        upcoming.tabBarItem.image = UIImage(systemName: "play.circle")
        search.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        download.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        home.title = "Home"
        upcoming.title = "Upcoming"
        search.title = "Search"
        download.title = "Downloads"
        
        tabBar.tintColor = .label
        
        setViewControllers([home, upcoming, search, download], animated: true)
    }
    
    private func SetUINavigationBar() {
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .white
    }
}
