//
//  SearchResultsViewModel.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import Foundation

final class SearchResultsViewModel {
    
    var coordinator: SearchResultsCoordinator
        
    init(coordinator: SearchResultsCoordinator) {
        self.coordinator = coordinator
    }
    
    func searchYoutubeVideo(from address: String, with query: String) async throws -> VideoElement {
        try await Youtube.shared.search(from: address, with: query)
    }
}
