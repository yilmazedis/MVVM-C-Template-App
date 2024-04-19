//
//  UINavigationBarAppearance.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 20.04.2024.
//

import UIKit

extension UINavigationBarAppearance {
    static func configureGlobalAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
