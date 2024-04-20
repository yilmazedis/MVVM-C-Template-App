//
//  HomeViewController.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 11.04.2024.
//

import UIKit

private typealias ListDataSource = UITableViewDiffableDataSource<HomeViewController.Section, [Movie]>
private typealias ListSnapshot = NSDiffableDataSourceSnapshot<HomeViewController.Section, [Movie]>

final class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewModel!

    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: ListDataSource!
    private var snapshot = ListSnapshot()

    convenience init(viewModel: HomeViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home Page"
        
        configureView()
        Task { await fetchSections() }
    }
    
    private func configureView() {
        tableView.register(PosterListCell.self, forCellReuseIdentifier: PosterListCell.identifier)
        
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
                let selectedTitle = titles.randomElement()
                headerView.configure(with: PosterItem(name: selectedTitle?.original_title ?? "",
                                                          url: selectedTitle?.poster_path ?? ""))
            } catch {
                print(error.localizedDescription)
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
        snapshot.appendSections(Section.allCases)
        dataSource = HomeDataSource(tableView: tableView) { tableView, indexPath, item in
            /// I already registered ListViewCell, so I dont worry it to put under guard let condition. So it is guarantee not to be crashed.
            let cell = tableView.dequeueReusableCell(withIdentifier: PosterListCell.identifier, for: indexPath) as! PosterListCell
            
            cell.delegate = self
            cell.configure(with: item)
            return cell
        }
    }
    
    private func applySnapshot(from items: [Movie], section: Section) {
        snapshot.appendItems([items], toSection: section)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func fetchSections() async {
        do {
            for section in Section.allCases {
                let titles = try await viewModel.getSectionData(from: section.movieUrl)
                applySnapshot(from: titles, section: section)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension HomeViewController {
    fileprivate enum Section: Int, CaseIterable {
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

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension HomeViewController: PosterListDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: PosterListCell, item: MoviePreviewItem) {
        viewModel.coordinator.showMoviePreview(with: item)
    }
}

private class HomeDataSource: UITableViewDiffableDataSource<HomeViewController.Section, [Movie]> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.snapshot().sectionIdentifiers[section].header
    }
}
