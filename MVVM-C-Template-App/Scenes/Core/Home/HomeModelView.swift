//
//  HomeModelView.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

final class HomeViewModel {
    
    var coordinator: HomeCoordinator!
    
    var headerView: HeroHeaderUIView?
    var randomTrendingMovie: Title?
    
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    
    func start() {
    }
    
    func getHeaderData(from address: String) {
        TheMovieDB.shared.get(from: address) { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()

                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))

            case .failure(let erorr):
                print(erorr.localizedDescription)
            }
        }
    }
    
    func getSectionData(from address: String, make configure: @escaping (_ titles: [Title]) -> Void) {
        TheMovieDB.shared.get(from: address) { result in
            switch result {
            case .success(let titles):
                configure(titles)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Storage

private extension HomeViewModel {
    
    struct Storage {
        public static let empty = Storage()
    }
}
