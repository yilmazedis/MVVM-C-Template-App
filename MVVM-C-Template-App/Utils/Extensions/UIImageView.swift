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
                /// https://www.swiftwithvincent.com/blog/bad-practice-loading-a-large-image-on-the-main-thread
                image = try await DownloadImageManager.shared.getImage(with: path).byPreparingForDisplay()
            } catch {
                print("Error downloading or converting image: \(error)")
            }
        }
    }
}
