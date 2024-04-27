//
//  MovieCell.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import UIKit

final class MovieCell: UITableViewCell {

    static let identifier = "MovieCell"

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var playIconImage: UIImageView!
    @IBOutlet private weak var posterImageView: UIImageView!

    public func configure(with model: PosterItem) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.path)") else {
            return
        }
        
        Task {
            let image = try await DownloadImageAsyncImageLoader.shared.downloadWithAsync(url: url)
            await MainActor.run {
                posterImageView.image = image
            }
        }
        titleLabel.text = model.name
    }
}
