//
//  DownloadsViewController.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import UIKit

private typealias ListDataSource = UITableViewDiffableDataSource<DownloadsViewModel.Section, MovieItem>
private typealias ListSnapshot = NSDiffableDataSourceSnapshot<DownloadsViewModel.Section, MovieItem>

final class DownloadsViewController: UIViewController {
    private var viewModel: DownloadsViewModel!
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var dataSource: ListDataSource!
    private var snapshot = ListSnapshot()
    
    convenience init(viewModel: DownloadsViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        tableView.register(UINib(nibName: MovieCell.identifier, bundle: nil), forCellReuseIdentifier: MovieCell.identifier)
        tableView.delegate = self
        
        configureDataSource()
        fetchLocalStorageForDownload()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification(_:)),
                                               name: NSNotification.Name("downloaded"),
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureDataSource() {
        snapshot.appendSections([.main])
        dataSource = ListDataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
            
            cell.configure(with: PosterItem(name: item.title.empty, path: item.posterPath.empty))
            return cell
        }
    }
    
    @objc func handleNotification(_ notification: Notification) {
        if let movieItem = notification.object as? MovieItem {
            applySnapshot(from: [movieItem])
        }
    }
    
    private func applySnapshot(from movies: [MovieItem]) {
        snapshot.appendItems(movies)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func delete(at indexPath: IndexPath) {
        Task {
            do {
                guard let movie = dataSource.itemIdentifier(for: indexPath) else {
                    return
                }
                
                try await viewModel.deleteTitleWith(movie: movie)
                snapshot.deleteItems([movie])
                await MainActor.run {
                    dataSource.apply(snapshot, animatingDifferences: true)
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func fetchLocalStorageForDownload() {
        Task {
            do {
                let movies = try await viewModel.fetchLocalStorageForDownload()
                applySnapshot(from: movies)
            } catch {
                print(error)
            }
        }
    }
    
    private func titlePreviewConfigure(with videoElement: VideoElement, movie: MovieItem) {
        
        let previewItem = MoviePreviewItem(title: movie.title.empty,
                                           youtubeView: videoElement,
                                           titleOverview: movie.overview.empty)
        
        viewModel.coordinator.showTitlePreview(with: previewItem)
    }
}

extension DownloadsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, handler in
            self.delete(at: indexPath)
        }
        
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let movie = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        Task {
            do {
                let videoElement = try await viewModel.getYoutubeVideo(from: K.Youtube.search,
                                                                       with: movie.title.empty)
                titlePreviewConfigure(with: videoElement, movie: movie)
            } catch {
                print(error)
            }
        }
    }
}
