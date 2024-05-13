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

struct MovieView: View {
    let title: String
    let path: String
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                AsyncImageView(path: path)
                    .cornerRadius(10)
                VStack {
                    Spacer()
                    Text(title)
                        .padding()
                        .background(.black.opacity(0.45))
                        .cornerRadius(4)
                }
            }
            Button {
                print("Downloaded")
            } label: {
                Text("Download")
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}

enum ImageNetworkState {
    case loading
    case success(UIImage)
    case failure(Error)
}

struct AsyncImageView: View {
    @State var state: ImageNetworkState = .loading
    
    let path: String
    
    init(path: String) {
        self.path = path
    }
    
    var body: some View {
        VStack {
            switch state {
            case .loading:
                ProgressView()
            case .success(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            case .failure(let error):
                Text(error.localizedDescription)
            }
        }
        .task {
            do {
                let image = try await DownloadImageManager.shared.getImage(with: path)
                state = .success(image)
            } catch {
                state = .failure(URLError(.badURL))
            }
        }
    }
}
