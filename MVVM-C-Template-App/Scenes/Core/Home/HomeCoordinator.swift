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
        let networkManager = NetworkManager()
        let dataPersistenceManager = DataPersistenceManager()
        let viewModel = HomeViewModel(coordinator: self, dataPersistenceManager: dataPersistenceManager, networkManager: networkManager)
        let viewController = HomeViewController(viewModel: viewModel)
        
        viewController.hidesBottomBarWhenPushed = true
        navigator?.pushViewController(viewController, animated: true)
    }
    
    // For Tabbar
    func startTabbar() -> UINavigationController {
        let networkManager = NetworkManager()
        let dataPersistenceManager = DataPersistenceManager()
        let viewModel = HomeViewModel(coordinator: self, dataPersistenceManager: dataPersistenceManager, networkManager: networkManager)
        let viewController = HomeViewController(viewModel: viewModel)
        
        let navigator = UINavigationController()
        defer { self.navigator = navigator }
        navigator.setViewControllers([viewController], animated: false)
        return navigator
    }
    
    func showMoviePreview(with item: MoviePreviewItem) {
        MoviePreviewCoordinator(navigator: navigator).start(with: item)
    }
}
