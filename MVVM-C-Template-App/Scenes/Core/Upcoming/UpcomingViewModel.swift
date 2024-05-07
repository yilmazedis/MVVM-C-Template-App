//
//  UpcomingViewModel.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import Foundation

final class UpcomingViewModel {
    
    var coordinator: UpcomingCoordinator
    
    let networkManager: NetworkManagerProtocol

    init(coordinator: UpcomingCoordinator, networkManager: NetworkManagerProtocol) {
        self.coordinator = coordinator
        self.networkManager = networkManager
    }
    
    func getCellData(from address: String) async throws -> [Movie] {
        let response: MovieResponse = try await networkManager.get(from: address)
        return response.results
    }
    
    func getYoutubeVideo(from query: String) async throws -> VideoElement {
        let response: YoutubeSearchResponse = try await networkManager.search(from: K.Youtube.search, with: query)
        return response.items[0]
    }
}

extension UpcomingViewModel {
    enum Section: Int {
        case main
    }
}
