//
//  SearchViewModel.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import Foundation

final class SearchViewModel {
    
    var coordinator: SearchCoordinator
    
    var movie: Movie?
    var movies: [Movie]?
    
    init(coordinator: SearchCoordinator) {
        self.coordinator = coordinator
    }
    
    func fetchDiscoverMovies() async throws -> [Movie] {
        try await TheMovieDB.shared.get(from: K.TheMovieDB.discoverMovies)
    }
    
    func getYoutubeVideo(from address: String, with query: String) async throws -> VideoElement{
        try await Youtube.shared.search(from: address, with: query)
    }
    
    func updateSearchResults(from address: String, with query: String) async throws -> [Movie] {
        try await TheMovieDB.shared.search(from: address, with: query)
    }
}
