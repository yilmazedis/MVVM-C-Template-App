//
//  MoviePreviewViewController.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import UIKit
import WebKit

final class MoviePreviewViewController: UIViewController {
    
    private var viewModel: MoviePreviewViewModel!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var downloadButton: UIButton!
    @IBOutlet private weak var webView: WKWebView!
    
    private var item: MoviePreviewItem!
    
    convenience init(viewModel: MoviePreviewViewModel, with item: MoviePreviewItem) {
        self.init()
        self.viewModel = viewModel
        self.item = item
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadHTMLString("", baseURL: nil)
        prepareView()
    }
    
    private func prepareView() {
        downloadButton.backgroundColor = .red
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.setTitleColor(.white, for: .normal)
        downloadButton.layer.cornerRadius = 8
        
        configure()
    }
    
    func configure() {
        titleLabel.text = item.movie.title
        overviewLabel.text = item.movie.overview
        guard let url = URL(string: "https://www.youtube.com/embed/\(item.youtubeView.id.videoId)") else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    @IBAction func downloadButtonAction(_ sender: UIButton) {
        downloadTitleAt(title: item.movie)
    }
    
    private func downloadTitleAt(title: Movie) {
        Task {
            try await viewModel.download(movie: title)
            InfoAlertView.shared.showAlert(message: "Successfully Downloaded", completion: nil)
        }
    }
}
