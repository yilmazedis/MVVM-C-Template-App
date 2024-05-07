//
//  SearchResultsViewModel.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import Foundation

final class SearchResultsViewModel {
    
    var coordinator: SearchResultsCoordinator
    
    let networkManager: NetworkManagerProtocol
        
    init(coordinator: SearchResultsCoordinator, 
         networkManager: NetworkManagerProtocol) {
        self.coordinator = coordinator
        self.networkManager = networkManager
    }
    
    func searchYoutubeVideo(from address: String, with query: String) async throws -> VideoElement {
        let response: YoutubeSearchResponse = try await networkManager.search(from: address, with: query)
        return response.items[0]
    }
}

extension SearchResultsViewModel {
    enum Section: Int {
        case main
    }
}
