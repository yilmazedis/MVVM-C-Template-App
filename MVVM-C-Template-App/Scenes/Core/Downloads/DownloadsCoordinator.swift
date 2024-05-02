//
//  DownloadsCoordinator.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import UIKit

final class DownloadsCoordinator {
    weak var navigator: UINavigationController?
    
    public init(navigator: UINavigationController? = nil) {
        self.navigator = navigator
    }
    
    public func start() {
        let dataPersistenceManager = DataPersistenceManager()
        let viewModel = DownloadsViewModel(coordinator: self, dataPersistenceManager: dataPersistenceManager)
        let viewController = DownloadsViewController(viewModel: viewModel)
        
        viewController.hidesBottomBarWhenPushed = true
        navigator?.pushViewController(viewController, animated: true)
    }
    
    // For Tabbar
    func startTabbar() -> UINavigationController {
        let dataPersistenceManager = DataPersistenceManager()
        let viewModel = DownloadsViewModel(coordinator: self, dataPersistenceManager: dataPersistenceManager)
        let viewController = DownloadsViewController(viewModel: viewModel)
        
        let navigator = UINavigationController()
        defer { self.navigator = navigator }
        navigator.setViewControllers([viewController], animated: false)
        return navigator
    }
    
    func showTitlePreview(with item: MoviePreviewItem) {
        MoviePreviewCoordinator(navigator: navigator).start(with: item)
    }
}
