//
//  UIImageView.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 26.04.2024.
//

import UIKit

extension UIImageView {
    func getImage(on path: String) {
        Task {
            do {
                self.image = try await DownloadImageManager.shared.getImage(with: path)
            } catch {
                print("Error downloading or converting image: \(error)")
            }
        }
    }
}
