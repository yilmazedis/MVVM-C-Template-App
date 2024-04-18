//
//  TitlePreviewCoordinator.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import UIKit

final class TitlePreviewCoordinator {
    weak var navigator: UINavigationController?
    
    public init(navigator: UINavigationController?) {
        self.navigator = navigator
    }
    
    public func start(with item: TitlePreviewItem) {
        let viewModel = TitlePreviewViewModel(coordinator: self)
        let viewController = TitlePreviewViewController(viewModel: viewModel)
        
        viewController.configure(with: item)
        
        viewController.hidesBottomBarWhenPushed = true
        navigator?.pushViewController(viewController, animated: true)
    }
}
