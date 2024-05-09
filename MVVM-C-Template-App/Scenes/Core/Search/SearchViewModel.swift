//
//  SearchViewModel.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import Foundation

final class SearchViewModel {
    
    var coordinator: SearchCoordinator
    
    let networkManager: NetworkManagerProtocol
        
    init(coordinator: SearchCoordinator, networkManager: NetworkManagerProtocol) {
        self.coordinator = coordinator
        self.networkManager = networkManager
    }
    
    func fetchDiscoverMovies() async throws -> [Movie] {        
        let response: MovieResponse = try await networkManager.get(from: K.TheMovieDB.discoverMovies)
        return response.results
    }
    
    func getYoutubeVideo(from address: String, with query: String) async throws -> VideoElement{
        let response: YoutubeSearchResponse = try await networkManager.search(from: address, with: query)
        return response.items.firstIfNilDummy()
    }
    
    func updateSearchResults(from address: String, with query: String) async throws -> [Movie] {
        let response: MovieResponse = try await networkManager.search(from: address, with: query)
        return response.results
    }
}

extension SearchViewModel {
    enum Section: Int {
        case main
    }
}
