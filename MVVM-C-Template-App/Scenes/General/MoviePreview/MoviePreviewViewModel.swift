//
//  MoviePreviewViewModel.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import Foundation

// If it has behaviour, state, it can be class but you need to be very careful with race conditions
// If you just represent data you can make struct
struct MoviePreviewViewModel {
    
    var coordinator: MoviePreviewCoordinator
    
    let dataPersistenceManager: DataPersistenceManagerProtocol
        
    init(coordinator: MoviePreviewCoordinator, dataPersistenceManager: DataPersistenceManagerProtocol) {
        self.coordinator = coordinator
        self.dataPersistenceManager = dataPersistenceManager
    }
    
    func download(movie: Movie) async throws {
        let movieItem = try await dataPersistenceManager.download(movie: movie)
        NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: movieItem)
    }
}
