//
//  HomeModelView.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

final class HomeViewModel {
    
    var coordinator: HomeCoordinator!
        
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", 
                                   "Popular", "Upcoming Movies", "Top rated"]
    
    let display = Display.empty
    
    func start() {}
    
    func getHeaderData(from address: String) async throws -> [Title] {
        try await TheMovieDB.shared.get(from: address)
    }
    
    func getSectionData(from address: String) async throws -> [Title] {
        try await TheMovieDB.shared.get(from: address)
    }
}

// MARK: - Storage

extension HomeViewModel {
    struct Display {
        static let empty = Display()
    }
}
