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
    
    public func configure(with path: String) {
        posterImageView.getImage(on: path)
    }
}
