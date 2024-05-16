//
//  Movie.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 27.04.2024.
//

import Foundation

extension Movie {
    init(item: MovieItem) {
        self.id = Int(item.id)
        self.mediaType = item.mediaType.empty
        self.title = item.title.empty
        self.posterPath = item.posterPath.empty
        self.overview = item.overview.empty
        self.voteCount = Int(item.voteCount)
        self.voteAverage = item.voteAverage
        self.originalName = nil
        self.originalTitle = nil
    }
    
    func getMovieItem() -> MovieItem {
        let item = MovieItem()
        item.id = Int64(id)
        item.mediaType = mediaType
        item.overview = overview
        item.posterPath = posterPath
        item.title = title
        item.voteAverage = voteAverage
        item.voteCount = Int64(voteCount)
        return item
    }
}
