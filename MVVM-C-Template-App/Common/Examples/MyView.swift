//
//  MyView.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 12.03.2024.
//

import UIKit

// This is an example of a making UIView
final class MyView: UIView, NibLoadable {
    
    // MARK: - Outlets
    
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
        
    }
    
    // MARK: - Configuration
    func configure(with display: [Int]) {
        
    }
    
    // MARK: - Helper Functions
}
