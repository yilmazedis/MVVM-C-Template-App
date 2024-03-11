//
//  HomeViewController.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 9.03.2024.
//

import UIKit

class HomeViewController: UIViewController, ViewController {

    static var storyboardName: UIStoryboard.Name = .home

    var viewModel: HomeViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home Page"
        
        configureView()
    }
    
    private func configureView() {
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self

        configureNavbar()
        configureHeaderView()
    }
    
    private func configureHeaderView() {
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, 
                                                        width: view.bounds.width,
                                                        height: 500))
        tableView.tableHeaderView = headerView
        
        Task {
            do {
                let titles = try await viewModel.getHeaderData(from: K.TheMovieDB.trendingMovie)
                let selectedTitle = titles.randomElement()
                headerView.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "",
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
        navigationController?.navigationBar.tintColor = .white
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }

        cell.delegate = self
        
        guard let movieUrl = Sections(rawValue: indexPath.section)?.description else {
            return UITableViewCell()
        }
        
        Task {
            do {
                let titles = try await viewModel.getSectionData(from: movieUrl)
                
                await MainActor.run {
                    cell.configure(with: titles)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitles[section]
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
//        DispatchQueue.main.async { [weak self] in
//            guard let vc = TitlePreviewRouter.start().entry as? TitlePreviewView else { return }
//            vc.configure(with: viewModel)
//            self?.navigationController?.pushViewController(vc, animated: false)
//        }
    }
}
