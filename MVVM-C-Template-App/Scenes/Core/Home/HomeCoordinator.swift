//
//  HomeCoordinator.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import UIKit

final class HomeCoordinator: Coordinator {
    
    typealias Controller = HomeViewController
    
    weak var navigator: UINavigationController!
    
    // Used by Tabbar, so, we dont have to force to pass navigator through init.
    public init(navigator: UINavigationController? = nil) {
      self.navigator = navigator
    }

    public func start() {
      let view = createViewController()
      view.viewModel = HomeViewModel()
      view.viewModel.coordinator = self

      view.hidesBottomBarWhenPushed = true
//      navigator.navigationBar.isHidden = true

      navigator.pushViewController(view, animated: true)
    }
    
    // For Tabbar
    func startTabbar() -> UINavigationController {
        let view = createViewController()
        view.viewModel = HomeViewModel()
        view.viewModel.coordinator = self
        
        let navigator = UINavigationController()
//        navigator.navigationBar.isHidden = true
        defer { self.navigator = navigator }
        
        navigator.setViewControllers([view], animated: true)
        return navigator
    }
    
    func showAnotherPage() {
        HomeCoordinator(navigator: navigator).start()
    }
}
