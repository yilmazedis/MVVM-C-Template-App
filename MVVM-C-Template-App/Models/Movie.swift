//
//  Title.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable, Hashable {
    let id: Int
    let mediaType: String
    let title: String
    let posterPath: String
    let overview: String
    let voteCount: Int
    let voteAverage: Double
    
    private let originalName: String?
    private let originalTitle: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case originalName = "original_name"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case overview
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        mediaType = try container.decodeIfPresent(String.self, forKey: .mediaType).empty
        originalName = try container.decodeIfPresent(String.self, forKey: .originalName)
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath).empty
        overview = try container.decodeIfPresent(String.self, forKey: .overview).empty
        voteCount = try container.decode(Int.self, forKey: .voteCount)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        
        self.title = originalName ?? originalTitle.empty
    }
}
