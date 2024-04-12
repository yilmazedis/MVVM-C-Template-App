//
//  HomeViewController.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 11.04.2024.
//

import UIKit

private typealias ListDataSource = UITableViewDiffableDataSource<HomeViewController.Section, [Title]>
private typealias ListSnapshot = NSDiffableDataSourceSnapshot<HomeViewController.Section, [Title]>

class HomeViewController: UIViewController {
    
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
        fetchSections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func configureView() {
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
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
                headerView.configure(with: TitleItem(titleName: selectedTitle?.original_title ?? "",
                                                          posterURL: selectedTitle?.poster_path ?? ""))
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
            let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as! CollectionViewTableViewCell
            
            cell.delegate = self
            cell.configure(with: item)
            return cell
        }
    }
    
    private func applySnapshot(from items: [Title], section: Section) {
        snapshot.appendItems([items], toSection: section)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func fetchSections() {
        for rawValue in 0..<Section.allCases.count {
            guard let movieUrl = Section(rawValue: rawValue)?.description else { continue }
            
            Task {
                do {
                    let titles = try await viewModel.getSectionData(from: movieUrl)
                    
                    applySnapshot(from: titles, section: Section(rawValue: rawValue)!)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

}

extension HomeViewController {
    fileprivate enum Section: Int, CaseIterable, CustomStringConvertible {
        case TrendingMovies = 0
        case TrendingTv = 1
        case Popular = 2
        case Upcoming = 3
        case TopRated = 4
        
        var description: String {
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

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewItem) {
//        DispatchQueue.main.async { [weak self] in
//            guard let vc = TitlePreviewRouter.start().entry as? TitlePreviewView else { return }
//            vc.configure(with: viewModel)
//            self?.navigationController?.pushViewController(vc, animated: false)
//        }
    }
}

private class HomeDataSource: UITableViewDiffableDataSource<HomeViewController.Section, [Title]> {

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.snapshot().sectionIdentifiers[section].header
    }
}
