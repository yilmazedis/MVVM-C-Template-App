//
//  ViewController.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import UIKit

protocol ViewController: AnyObject {
    static var storyboardName: UIStoryboard.Name { get }
}

extension ViewController where Self: UIViewController {
    
    static func controller() -> Self {
        return allocate()
    }
    
    private static func allocate<T: UIViewController>() -> T {
        guard let identifier = "\(self)".components(separatedBy: "ViewController").first
        else {
            preconditionFailure("Unable to initialize view controller with name: \(self)")
        }
        return storyboardName.allocate(with: identifier)
    }
}
