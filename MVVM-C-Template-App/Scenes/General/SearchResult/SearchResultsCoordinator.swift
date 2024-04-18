//
//  SearchResultsCoordinator.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import UIKit

final class SearchResultsCoordinator {
    public func start() -> SearchResultsViewController {
        let viewModel = SearchResultsViewModel(coordinator: self)
        let viewController = SearchResultsViewController(viewModel: viewModel)
        return viewController
    }
}
