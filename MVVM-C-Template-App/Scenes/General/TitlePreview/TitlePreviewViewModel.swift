//
//  TitlePreviewViewModel.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import Foundation

final class TitlePreviewViewModel {
    
    var coordinator: TitlePreviewCoordinator
    
    var model: Title?
    
    init(coordinator: TitlePreviewCoordinator) {
        self.coordinator = coordinator
    }
}
