//
//  HomeViewController.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 11.04.2024.
//

import UIKit
import Combine

private typealias ListDataSource = UITableViewDiffableDataSource<HomeViewModel.Section, [Movie]>
private typealias ListSnapshot = NSDiffableDataSourceSnapshot<HomeViewModel.Section, [Movie]>

final class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: ListDataSource!
    private var snapshot = ListSnapshot()
    private var cancellables = Set<AnyCancellable>()
    
    convenience init(viewModel: HomeViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home Page"
        
        configureView()
        Task { await fetchSections() }
        
        WatchConnector.shared.$movies
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching Pokemon items: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] items in
                if let movie = items.last {
                    self?.downloadDataBase(movie: movie)
                }
            }
            .store(in: &cancellables)
        
    }
    
    private func configureView() {
        tableView.register(UINib(nibName: PosterListCell.identifier, bundle: nil), forCellReuseIdentifier: PosterListCell.identifier)
        
        tableView.delegate = self
        
        configureNavbar()
        configureDataSource()
        configureHeaderView()
    }
    
    private func configureHeaderView() {
        let headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0,
                                                      width: view.bounds.width,
                                                      height: 500))
        tableView.tableHeaderView = headerView
        
        Task {
            do {
                let titles = try await viewModel.getHeaderData(from: K.TheMovieDB.trendingMovie)
                guard let randomMovie = titles.randomElement() else { return }
                headerView.configure(with: PosterItem(name: randomMovie.title,
                                                      path: randomMovie.posterPath))
            } catch {
                print(error)
            }
        }
    }
    
    private func configureNavbar() {
        let image = UIImage(named: "netflixLogo")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configureDataSource() {
        snapshot.appendSections(viewModel.allSections)
        dataSource = HomeDataSource(tableView: tableView) { tableView, indexPath, item in
            /// I already registered ListViewCell, so I dont worry it to put under guard let condition. So it is guarantee not to be crashed.
            let cell = tableView.dequeueReusableCell(withIdentifier: PosterListCell.identifier, for: indexPath) as! PosterListCell
            
            cell.delegate = self
            cell.applySnapshot(from: item)
            return cell
        }
    }
    
    private func applySnapshot(from items: [Movie], section: HomeViewModel.Section) {
        snapshot.appendItems([items], toSection: section)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func fetchSections() async {
        do {
            for section in viewModel.allSections {
                let titles = try await viewModel.getSectionData(from: section.movieUrl)
                applySnapshot(from: titles, section: section)
            }
        } catch {
            print(error)
        }
    }
    
    private func downloadDataBase(movie: Movie) {
        Task {
            let movieItem = try await viewModel.download(movie: movie)
            InfoAlertView.shared.showAlert(message: "Successfully Downloaded", completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: movieItem)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension HomeViewController: PosterListDelegate {
    func posterListCell(_ cell: PosterListCell, didSelectItemAt movie: Movie) {
        Task {
            do {
                let videoElement = try await viewModel.getYoutubeVideo(from: K.Youtube.search, with: movie.title)
                let item = MoviePreviewItem(movie: movie, youtubeView: videoElement)
                viewModel.coordinator.showMoviePreview(with: item)
            } catch {
                print(error)
            }
        }
    }
    
    func posterListCell(_ cell: PosterListCell, downloadFor movie: Movie) {
        downloadDataBase(movie: movie)
    }
}

private class HomeDataSource: UITableViewDiffableDataSource<HomeViewModel.Section, [Movie]> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.snapshot().sectionIdentifiers[section].header
    }
}
