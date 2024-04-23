//
//  UpcomingViewController.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import UIKit

private typealias ListDataSource = UITableViewDiffableDataSource<UpcomingViewModel.Section, Movie>
private typealias ListSnapshot = NSDiffableDataSourceSnapshot<UpcomingViewModel.Section, Movie>

final class UpcomingViewController: UIViewController {
    
    private var viewModel: UpcomingViewModel!
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var dataSource: ListDataSource!
    
    convenience init(viewModel: UpcomingViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.delegate = self
        
        configureDataSource()
        fetchUpcoming()
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

    private func fetchUpcoming() {
        Task {
            do {
                let movies = try await viewModel.getCellData(from: K.TheMovieDB.upcomingMovies)
                applySnapshot(from: movies)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func navigateToTitlePreviewView(with model: VideoElement, movie: Movie) {
        let previewItem = MoviePreviewItem(title: movie.original_title ?? "", youtubeView: model, titleOverview: movie.overview ?? "")
        viewModel.coordinator.showTitlePreview(with: previewItem)
    }
}

extension UpcomingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let movie = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        guard let titleName = movie.original_title ?? movie.original_name else {
            return
        }
                
        Task {
            do {
                let videoElement = try await viewModel.getYoutubeVideo(from: titleName)
                navigateToTitlePreviewView(with: videoElement, movie: movie)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
