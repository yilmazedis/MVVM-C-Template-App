//
//  StoryboardLoader.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import UIKit

// MARK: - UIStoryboard

extension UIStoryboard {
    private func allocate<T: UIViewController>(with identifier: String) -> T {
        let view = instantiateViewController(withIdentifier: identifier) as! T
        view.modalPresentationStyle = .fullScreen
        return view
    }
    
    enum Name: String, CustomStringConvertible {
        case home
        case upcoming
        case search
        case downloads
        
        public var description: String {
            return rawValue.capitalized
        }
        
        func allocate<T: UIViewController>(with identifier: String, using loader: StoryboardLoader = .shared) -> T {
            let storyboard = loader.board(with: self)
            return storyboard.allocate(with: identifier)
        }
    }
}

final class StoryboardLoader: Cache<UIStoryboard.Name, UIStoryboard> {
    
    static let shared = StoryboardLoader()
    private var bundle: Bundle
    
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    public func board(with name: UIStoryboard.Name) -> UIStoryboard {
        if let storyboard = self[name] {
            return storyboard
        }
        else {
            let storyboard = UIStoryboard(name: name.description, bundle: bundle)
            self[name] = storyboard
            
            return storyboard
        }
    }
}
