//
//  InfoAlertView.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 24.04.2024.
//

import UIKit

final class InfoAlertView {
    static let shared = InfoAlertView()
    
    private init() {}
    
    func showAlert(message: String, completion: VoidHandler?) {
        guard let topViewController = UIApplication.rootViewController else {
            return
        }
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        
        topViewController.present(alertController, animated: true, completion: nil)
    }
}
