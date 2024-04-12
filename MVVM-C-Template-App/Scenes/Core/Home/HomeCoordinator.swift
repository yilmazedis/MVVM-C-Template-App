//
//  HomeCoordinator.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import UIKit

final class HomeCoordinator {
    weak var navigator: UINavigationController?
    
    public init(navigator: UINavigationController? = nil) {
        self.navigator = navigator
    }
    
    public func start() {
        let viewModel = HomeViewModel(coordinator: self)
        let viewController = HomeViewController(viewModel: viewModel)
        
        viewController.hidesBottomBarWhenPushed = true
        navigator?.pushViewController(viewController, animated: true)
    }
    
    // For Tabbar
    func startTabbar() -> UINavigationController {
        let viewModel = HomeViewModel(coordinator: self)
        let viewController = HomeViewController(viewModel: viewModel)
        return  UINavigationController(rootViewController: viewController)
    }
    
    func showAnotherPage() {
        HomeCoordinator(navigator: navigator).start()
    }
}
