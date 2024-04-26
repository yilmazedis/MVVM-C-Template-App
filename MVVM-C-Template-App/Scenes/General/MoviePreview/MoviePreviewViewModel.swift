//
//  MoviePreviewViewModel.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import Foundation

final class MoviePreviewViewModel {
    
    var coordinator: MoviePreviewCoordinator
        
    init(coordinator: MoviePreviewCoordinator) {
        self.coordinator = coordinator
    }
    
    func download(movie: Movie) async throws {
        let movieItem = try await DataPersistenceManager.shared.download(movie: movie)
        NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: movieItem)
    }
}
