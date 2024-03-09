//
//  HomeViewController.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 9.03.2024.
//

import UIKit

class HomeViewController: UIViewController, ViewController {

    static var storyboardName: UIStoryboard.Name = .home

    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home Page"
    }
    
    @IBAction func PressME(_ sender: UIButton) {
        viewModel.coordinator.showAnotherPage()
    }
}
