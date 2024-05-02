//
//  MoviePreviewCoordinator.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import UIKit

final class MoviePreviewCoordinator {
    weak var navigator: UINavigationController?
    
    public init(navigator: UINavigationController?) {
        self.navigator = navigator
    }
    
    public func start(with item: MoviePreviewItem) {
        let dataPersistenceManager = DataPersistenceManager()
        let viewModel = MoviePreviewViewModel(coordinator: self, dataPersistenceManager: dataPersistenceManager)
        let viewController = MoviePreviewViewController(viewModel: viewModel, with: item)
        viewController.hidesBottomBarWhenPushed = true
        navigator?.pushViewController(viewController, animated: true)
    }
}
