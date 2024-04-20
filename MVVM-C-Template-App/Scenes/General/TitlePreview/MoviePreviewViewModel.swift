//
//  MoviePreviewViewModel.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import Foundation

final class MoviePreviewViewModel {
    
    var coordinator: MoviePreviewCoordinator
        
    init(coordinator: MoviePreviewCoordinator) {
        self.coordinator = coordinator
    }
}
