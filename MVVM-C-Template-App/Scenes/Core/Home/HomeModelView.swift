//
//  HomeModelView.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

final class HomeViewModel {
    
    var coordinator: HomeCoordinator!
    
    func start() {
    }
}

// MARK: - Storage

private extension HomeViewModel {
    
    struct Storage {
        public static let empty = Storage()
    }
}
