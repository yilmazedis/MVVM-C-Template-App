//
//  UpcomingViewModel.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import Foundation

final class UpcomingViewModel {
    
    var coordinator: UpcomingCoordinator

    init(coordinator: UpcomingCoordinator) {
        self.coordinator = coordinator
    }
    
    func getCellData(from address: String) async throws -> [Movie] {
        let response: MovieResponse = try await NetworkManager.shared.get(from: address)
        return response.results
    }
    
    func getYoutubeVideo(from query: String) async throws -> VideoElement {
        let response: YoutubeSearchResponse = try await NetworkManager.shared.search(from: K.Youtube.search, with: query)
        return response.items[0]
    }
}

extension UpcomingViewModel {
    enum Section: Int {
        case main
    }
}
