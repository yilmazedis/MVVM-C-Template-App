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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
    }

    public func configure(with model: PosterItem) {
        posterImageView.getImage(on: model.path)
        titleLabel.text = model.name
    }
}
