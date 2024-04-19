//
//  DownloadsViewModel.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import Foundation

final class DownloadsViewModel {
    
    var coordinator: DownloadsCoordinator
    
    var title: MovieItem?
    var titles: [MovieItem]?
    
    init(coordinator: DownloadsCoordinator) {
        self.coordinator = coordinator
    }
    
    func getYoutubeVideo(from address: String, with query: String) async throws -> VideoElement {
        try await Youtube.shared.search(from: address, with: query)
    }
    
    func fetchLocalStorageForDownload() async throws -> [MovieItem] {
        try await DataPersistenceManager.shared.fetchingTitlesFromDataBase()
    }
    
    func deleteTitleWith(index: IndexPath) async throws {
        
        guard let model = titles?[index.row] else { return }
        
        try await DataPersistenceManager.shared.deleteTitleWith(model: model)
    }
}
