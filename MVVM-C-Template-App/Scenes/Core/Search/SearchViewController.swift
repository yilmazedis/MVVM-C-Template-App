//
//  SearchViewController.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var viewModel: SearchViewModel!
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
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
        
        navigationController?.navigationBar.tintColor = .white
        
        Task {
            do {
                let titles = try await viewModel.fetchDiscoverMovies()
                viewModel.titles = titles
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
        let previewItem = TitlePreviewItem(title: viewModel.title?.original_title ?? "", youtubeView: videoElement, titleOverview: viewModel.title?.overview ?? "")
        
        viewModel.coordinator.showTitlePreview(with: previewItem)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.titles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        guard let title = viewModel.titles?[indexPath.row] else { return UITableViewCell() }
        let model = TitleItem(titleName: title.original_name ?? title.original_title ?? "Unknown name", posterURL: title.poster_path ?? "")
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let titleItem = viewModel.titles?[indexPath.row] else { return }
        viewModel.title = titleItem
        
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
    
    func searchResultsViewDidTapItem(_ previewItem: TitlePreviewItem) {
        viewModel.coordinator.showTitlePreview(with: previewItem)
    }
}
