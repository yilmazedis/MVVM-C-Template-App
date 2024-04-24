//
//  SearchViewController.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import UIKit

private typealias ListDataSource = UITableViewDiffableDataSource<UpcomingViewModel.Section, Movie>
private typealias ListSnapshot = NSDiffableDataSourceSnapshot<UpcomingViewModel.Section, Movie>

final class SearchViewController: UIViewController {
    
    private var viewModel: SearchViewModel!
    
    @IBOutlet private weak var tableView: UITableView!
        
    private lazy var resultsController: SearchResultsViewController = {
        let view = SearchResultsCoordinator().start()
        view.delegate = self
        return view
    }()
    
    private var dataSource: ListDataSource!
    
    convenience init(viewModel: SearchViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.backgroundColor = .systemBackground
        
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.delegate = self
        
        navigationController?.navigationBar.tintColor = .label
        prepareSearchController()
        configureDataSource()
        
        Task {
            do {
                let movies = try await viewModel.fetchDiscoverMovies()
                applySnapshot(from: movies)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func prepareSearchController() {
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchBar.placeholder = "Search for a Movie or a Tv show"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    private func configureDataSource() {
        dataSource = ListDataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
            
            cell.configure(with: PosterItem(name: (item.original_title ?? item.original_name) ?? "Unknown movie name", url: item.poster_path ?? ""))
            return cell
        }
    }
    
    private func applySnapshot(from movies: [Movie]) {
        var snapshot = ListSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func navigateToTitlePreviewView(with model: VideoElement, movie: Movie) {
        let previewItem = MoviePreviewItem(title: movie.original_title ?? "", youtubeView: model, titleOverview: movie.overview ?? "")
        viewModel.coordinator.showTitlePreview(with: previewItem)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let movie = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
                
        Task {
            do {
                let videoElement = try await viewModel.getYoutubeVideo(from: K.Youtube.search,
                                                                       with: movie.original_name ?? "")
                navigateToTitlePreviewView(with: videoElement, movie: movie)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3 else {
            return
        }
        
        Task {
            do {
                let movies = try await viewModel.updateSearchResults(from: K.TheMovieDB.searchMovie, with: query)
                resultsController.movies = movies
                resultsController.searchResultsCollectionView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - SearchResultsViewDelegate

extension SearchViewController: SearchResultsViewDelegate {
    func searchResultsViewDidTapItem(_ previewItem: MoviePreviewItem) {
        viewModel.coordinator.showTitlePreview(with: previewItem)
    }
}
