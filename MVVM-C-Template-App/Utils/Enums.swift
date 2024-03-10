//
//  Enums.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

enum ManagerError: Error {
    case noData
}

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}
