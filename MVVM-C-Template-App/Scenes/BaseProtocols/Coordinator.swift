//
//  Coordinator.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import UIKit

protocol Coordinator: AnyObject {
    
    associatedtype Controller: ViewController
    
    func createViewController() -> Controller
}

extension Coordinator where Controller: UIViewController {
    
    func createViewController() -> Controller {
        return Controller.controller()
    }
}
