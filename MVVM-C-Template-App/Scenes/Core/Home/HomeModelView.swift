//
//  HomeModelView.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

final class HomeViewModel {
    
    var coordinator: HomeCoordinator
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    func getHeaderData(from address: String) async throws -> [Movie] {
        try await TheMovieDB.shared.get(from: address)
    }
    
    func getSectionData(from address: String) async throws -> [Movie] {
        try await TheMovieDB.shared.get(from: address)
    }
}
