//
//  Movie.swift
//  MovieOverview Watch App
//
//  Created by yilmaz on 21.04.2024.
//

import Foundation

struct Movie: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let url: URL
}
