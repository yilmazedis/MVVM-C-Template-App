//
//  ContentView.swift
//  MovieOverview Watch App
//
//  Created by yilmaz on 21.04.2024.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    let networkManager = NetworkManager()
}

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        TabView {
            GeometryReader { geo in
                ScrollView(.vertical) {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.movies) { item in
                            ZStack {
                                MovieView(title: item.title, path: item.posterPath)
                            }
                            .frame(height: geo.size.height + geo.safeAreaInsets.top + geo.safeAreaInsets.bottom)
//                            //Or LazyVStack spacing
//                            .padding(.bottom, geo.safeAreaInsets.bottom)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .ignoresSafeArea(.container, edges: [.top, .bottom])
            }
        }
        .task {
            do {
                let movieResponse: MovieResponse = try await viewModel.networkManager.get(from: K.TheMovieDB.trendingMovie)
                viewModel.movies = movieResponse.results
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    ContentView()
}
