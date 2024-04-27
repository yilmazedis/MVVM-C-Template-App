//
//  PosterCell.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import UIKit

final class PosterCell: UICollectionViewCell {

    static let identifier = "PosterCell"

    @IBOutlet private weak var posterImageView: UIImageView!
    
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
            return
        }
        
        Task {
            let image = try await DownloadImageAsyncImageLoader.shared.downloadWithAsync(url: url)
            await MainActor.run {
                posterImageView.image = image
            }
        }
    }
}
