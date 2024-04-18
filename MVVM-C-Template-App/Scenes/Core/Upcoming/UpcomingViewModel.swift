//
//  UpcomingViewModel.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import Foundation

final class UpcomingViewModel {
    
    var coordinator: UpcomingCoordinator
    
    var title: Title?
    var titles: [Title]?
    
    init(coordinator: UpcomingCoordinator) {
        self.coordinator = coordinator
    }
    
    func getCellData(from address: String) async throws -> [Title] {
        try await TheMovieDB.shared.get(from: address)
    }
    
    func getYoutubeVideo(from query: String) async throws -> VideoElement {
        try await Youtube.shared.search(from: K.Youtube.search, with: query)
    }
}
