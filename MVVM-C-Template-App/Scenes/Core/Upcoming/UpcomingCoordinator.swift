//
//  UpcomingCoordinator.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import UIKit

final class UpcomingCoordinator {
    weak var navigator: UINavigationController?
    
    public init(navigator: UINavigationController? = nil) {
        self.navigator = navigator
    }
    
    public func start() {
        let viewModel = UpcomingViewModel(coordinator: self)
        let viewController = UpcomingViewController(viewModel: viewModel)
        
        viewController.hidesBottomBarWhenPushed = true
        navigator?.pushViewController(viewController, animated: true)
    }
    
    // For Tabbar
    func startTabbar() -> UINavigationController {
        let viewModel = UpcomingViewModel(coordinator: self)
        let viewController = UpcomingViewController(viewModel: viewModel)
        
        let navigator = UINavigationController()
        defer { self.navigator = navigator }
        navigator.setViewControllers([viewController], animated: false)
        return navigator
    }
    
    func showTitlePreview(with item: TitlePreviewItem) {
        TitlePreviewCoordinator(navigator: navigator).start(with: item)
    }
}
