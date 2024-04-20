//
//  SearchViewController.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private var viewModel: SearchViewModel!
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        return table
    }()
    
    private var searchController: UISearchController!
    
    private var resultsController: SearchResultsViewController = {
        let view = SearchResultsCoordinator().start()
        return view
    }()
    
    convenience init(viewModel: SearchViewModel) {
        self.init()
        self.viewModel = viewModel
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchBar.placeholder = "Search for a Movie or a Tv show"
        searchController.searchBar.searchBarStyle = .minimal
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.backgroundColor = .systemBackground
        
        resultsController.delegate = self
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.tintColor = .label
        
        Task {
            do {
                let titles = try await viewModel.fetchDiscoverMovies()
                viewModel.movies = titles
                discoverTable.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    func titlePreviewConfigure(with videoElement: VideoElement) {
        let previewItem = MoviePreviewItem(title: viewModel.movie?.original_title ?? "", youtubeView: videoElement, titleOverview: viewModel.movie?.overview ?? "")
        
        viewModel.coordinator.showTitlePreview(with: previewItem)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
        
        guard let title = viewModel.movies?[indexPath.row] else { return UITableViewCell() }
        let model = PosterItem(name: title.original_name ?? title.original_title ?? "Unknown name", url: title.poster_path ?? "")
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let titleItem = viewModel.movies?[indexPath.row] else { return }
        viewModel.movie = titleItem
        
        Task {
            do {
                let videoElement = try await viewModel.getYoutubeVideo(from: K.Youtube.search,
                                                                       with: titleItem.original_name ?? titleItem.original_title ?? "")
                titlePreviewConfigure(with: videoElement)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3 else {
            return
        }
        
        Task {
            do {
                let titles = try await viewModel.updateSearchResults(from: K.TheMovieDB.searchMovie, with: query)
                resultsController.titles = titles
                resultsController.searchResultsCollectionView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func searchResultsViewDidTapItem(_ previewItem: MoviePreviewItem) {
        viewModel.coordinator.showTitlePreview(with: previewItem)
    }
}
