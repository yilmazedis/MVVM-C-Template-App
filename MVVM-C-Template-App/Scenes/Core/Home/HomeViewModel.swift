//
//  HomeModelView.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

final class HomeViewModel {
    
    var coordinator: HomeCoordinator
    
    let dataPersistenceManager: DataPersistenceManagerProtocol
    let networkManager: NetworkManagerProtocol
    
    var allSections: [Section] {
        Section.allCases
    }
    
    init(coordinator: HomeCoordinator, 
         dataPersistenceManager: DataPersistenceManagerProtocol,
         networkManager: NetworkManagerProtocol) {
        self.coordinator = coordinator
        self.dataPersistenceManager = dataPersistenceManager
        self.networkManager = networkManager
    }
    
    func getHeaderData(from address: String) async throws -> [Movie] {
        try await getSectionData(from: address)
    }
    
    func getSectionData(from address: String) async throws -> [Movie] {
        let response: MovieResponse = try await networkManager.get(from: address)
        return response.results
    }
    
    func getYoutubeVideo(from address: String, with query: String) async throws -> VideoElement{
        let response: YoutubeSearchResponse = try await networkManager.search(from: address, with: query)
        return response.items.firstIfNilDummy()
    }
    
    func download(movie: Movie) async throws -> MovieItem {
        try await dataPersistenceManager.download(movie: movie)
    }
}

extension HomeViewModel {
    enum Section: Int, CaseIterable {
        case TrendingMovies = 0
        case TrendingTv = 1
        case Popular = 2
        case Upcoming = 3
        case TopRated = 4
        
        var movieUrl: String {
            switch self {
            case .TrendingMovies:
                K.TheMovieDB.trendingMovie
            case .TrendingTv:
                K.TheMovieDB.trendingTvs
            case .Popular:
                K.TheMovieDB.popular
            case .Upcoming:
                K.TheMovieDB.upcomingMovies
            case .TopRated:
                K.TheMovieDB.topRated
            }
        }
        
        var header: String {
            switch self {
            case .TrendingMovies:
                "Trending Movies"
            case .TrendingTv:
                "Trending Tv"
            case .Popular:
                "Popular"
            case .Upcoming:
                "Upcoming Movies"
            case .TopRated:
                "Top rated"
            }
        }
    }
}
