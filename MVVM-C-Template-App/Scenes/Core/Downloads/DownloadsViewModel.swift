//
//  DownloadsViewModel.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import Foundation

final class DownloadsViewModel {
    
    var coordinator: DownloadsCoordinator
    
    let dataPersistenceManager: DataPersistenceManagerProtocol
        
    init(coordinator: DownloadsCoordinator, dataPersistenceManager: DataPersistenceManagerProtocol) {
        self.coordinator = coordinator
        self.dataPersistenceManager = dataPersistenceManager
    }
    
    func getYoutubeVideo(from address: String, with query: String) async throws -> VideoElement {
        let response: YoutubeSearchResponse = try await TheMovieDB.shared.search(from: address, with: query)
        return response.items[0]
    }
    
    func fetchLocalStorageForDownload() async throws -> [MovieItem] {
        try await dataPersistenceManager.fetchingTitlesFromDataBase()
    }
    
    func deleteTitleWith(movie: MovieItem) async throws {
        try await dataPersistenceManager.deleteTitleWith(model: movie)
    }
}

extension DownloadsViewModel {
    enum Section: Int {
        case main
    }
}
