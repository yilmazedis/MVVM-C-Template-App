//
//  DownloadsViewController.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import UIKit

final class DownloadsViewController: UIViewController {
    private var viewModel: DownloadsViewModel!
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    convenience init(viewModel: DownloadsViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        view.addSubview(tableView)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        tableView.delegate = self
        tableView.dataSource = self
        
        
        fetchLocalStorageForDownload()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"),
                                               object: nil,
                                               queue: nil) { [weak self] _ in
            self?.fetchLocalStorageForDownload()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchLocalStorageForDownload() {
        Task {
            do {
                let movieItems = try await viewModel.fetchLocalStorageForDownload()
                viewModel.titles = movieItems
                tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func titlePreviewConfigure(with videoElement: VideoElement) {
        
        let previewItem = TitlePreviewItem(title: viewModel.title?.original_name ?? "",
                                           youtubeView: videoElement,
                                           titleOverview: viewModel.title?.overview ?? "")
        
        viewModel.coordinator.showTitlePreview(with: previewItem)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func deleteRow(index: IndexPath) {
        tableView.deleteRows(at: [index], with: .fade)
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            Task {
                do {
                    try await viewModel.deleteTitleWith(index: indexPath)
                    print("Deleted fromt the database")
                    viewModel.titles?.remove(at: indexPath.row)
                    deleteRow(index: indexPath)
                } catch {
                    print(error.localizedDescription)
                }
            }
        default:
            break;
        }
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
