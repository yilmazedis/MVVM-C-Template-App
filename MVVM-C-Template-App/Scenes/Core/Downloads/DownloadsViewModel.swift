//
//  DownloadsViewModel.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import Foundation

final class DownloadsViewModel {
    
    var coordinator: DownloadsCoordinator
        
    init(coordinator: DownloadsCoordinator) {
        self.coordinator = coordinator
    }
    
    func getYoutubeVideo(from address: String, with query: String) async throws -> VideoElement {
        try await Youtube.shared.search(from: address, with: query)
    }
    
    func fetchLocalStorageForDownload() async throws -> [MovieItem] {
        try await DataPersistenceManager.shared.fetchingTitlesFromDataBase()
    }
    
    func deleteTitleWith(movie: MovieItem) async throws {
        try await DataPersistenceManager.shared.deleteTitleWith(model: movie)
    }
}

extension DownloadsViewModel {
    enum Section: Int {
        case main
    }
}
