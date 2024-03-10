//
//  TitleCollectionViewCell.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import UIKit

class TitleCollectionViewCell: UICollectionViewCell {

    static let identifier = "TitleCollectionViewCell"

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }

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
