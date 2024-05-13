//
//  Movie.swift
//  MovieOverview Watch App
//
//  Created by yilmaz on 21.04.2024.
//

import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
}

struct Movie: Identifiable, Decodable {
    let id: Int
    let title: String
    let posterPath: String
    
    private let originalName: String?
    private let originalTitle: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case originalName = "original_name"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        originalName = try container.decodeIfPresent(String.self, forKey: .originalName)
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath).empty
        self.title = originalName ?? originalTitle.empty
    }
}
