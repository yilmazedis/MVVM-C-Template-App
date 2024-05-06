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
        Task {
            do {
                posterImageView.image = try await DownloadImageManager.shared.getImage(with: path)
            } catch {
                print("Error downloading or converting image: \(error)")
            }
        }
    }
}
