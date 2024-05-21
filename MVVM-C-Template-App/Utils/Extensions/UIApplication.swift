//
//  UIApplication.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 28.04.2024.
//

import UIKit

extension UIApplication {
    static var rootViewController: UIViewController? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first(where: { $0.isKeyWindow })?.rootViewController
    }
}

// TODO: Test topViewController
extension UIViewController {
    static func topViewController(base: UIViewController? = UIApplication.rootViewController) -> UIViewController? {
            if let navigationController = base as? UINavigationController {
                return topViewController(base: navigationController.visibleViewController)
            }
            if let tabBarController = base as? UITabBarController,
               let selected = tabBarController.selectedViewController {
                return topViewController(base: selected)
            }
            if let presented = base?.presentedViewController {
                return topViewController(base: presented)
            }
            return base
        }
}
