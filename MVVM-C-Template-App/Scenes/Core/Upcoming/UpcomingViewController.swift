//
//  UpcomingViewController.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import UIKit

final class UpcomingViewController: UIViewController {
    
    private var viewModel: UpcomingViewModel!
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    convenience init(viewModel: UpcomingViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self

        fetchUpcoming()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }

    private func fetchUpcoming() {
        Task {
            do {
                let titles = try await viewModel.getCellData(from: K.TheMovieDB.upcomingMovies)
                viewModel.titles = titles
                upcomingTable.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func navigateToTitlePreviewView(with model: VideoElement) {
        let title = viewModel.title
        let previewItem = TitlePreviewItem(title: title?.original_title ?? "", youtubeView: model, titleOverview: title?.overview ?? "")
        viewModel.coordinator.showTitlePreview(with: previewItem)
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.titles?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }

        guard let title = viewModel.titles?[indexPath.row] else { return UITableViewCell() }
        cell.configure(with: TitleItem(titleName: (title.original_title ?? title.original_name) ?? "Unknown title name", posterURL: title.poster_path ?? ""))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let title = viewModel.titles?[indexPath.row] else {
            return
        }

        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        viewModel.title = title
        
        Task {
            do {
                let videoElement = try await viewModel.getYoutubeVideo(from: titleName)
                navigateToTitlePreviewView(with: videoElement)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
