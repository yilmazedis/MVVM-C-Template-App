//
//  HeroHeaderUIView.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import UIKit

class HeroHeaderView: UIView, NibLoadable {
    // MARK: - Outlets
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    // MARK: - Properties
    
    // MARK: - View's Lifecycle
    override init(frame: CGRect) {
      super.init(frame: frame)
      setupFromNib()
      prepareView()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupFromNib()
      prepareView()
    }
    
    // MARK: - Preparation
    private func prepareView() {
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.layer.borderColor = UIColor.white.cgColor
        downloadButton.layer.borderWidth = 1
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.layer.cornerRadius = 5
        
        playButton.setTitle("Play", for: .normal)
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.borderWidth = 1
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.layer.cornerRadius = 5
        
        addGradient()
    }

    // MARK: - Configuration
    
    public func configure(with model: PosterItem) {
        heroImageView.getImage(on: model.path)
    }
    
    // MARK: - Helper Functions
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        heroImageView.layer.addSublayer(gradientLayer)
    }

}
