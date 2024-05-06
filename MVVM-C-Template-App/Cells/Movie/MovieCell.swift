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
        Task {
            do {
                posterImageView.image = try await DownloadImageManager.shared.getImage(with: model.path)
            } catch {
                print("Error downloading or converting image: \(error)")
            }
        }
        titleLabel.text = model.name
    }
}
