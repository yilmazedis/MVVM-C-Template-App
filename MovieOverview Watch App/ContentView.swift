//
//  ContentView.swift
//  MovieOverview Watch App
//
//  Created by yilmaz on 21.04.2024.
//

import SwiftUI

struct ContentView: View {
    
    let imageLoader = AsyncImageLoader()
    let imageURL = URL(string: "https://picsum.photos/200")!
    
    let imageURLs: [Movie] = [
        Movie(title: "Movie 1", url: URL(string: "https://picsum.photos/200")!),
        Movie(title: "Movie 2", url: URL(string: "https://picsum.photos/200")!),
        Movie(title: "Movie 3", url: URL(string: "https://picsum.photos/200")!),
        Movie(title: "Movie 4", url: URL(string: "https://picsum.photos/200")!),
        Movie(title: "Movie 5", url: URL(string: "https://picsum.photos/200")!),
        Movie(title: "Movie 6", url: URL(string: "https://picsum.photos/200")!)
    ]
    
    var body: some View {
        TabView {
            GeometryReader { geo in
                ScrollView(.vertical) {
                    LazyVStack(spacing: 0) {
                        ForEach(imageURLs) { item in
                            ZStack {
                                MovieView(title: item.title, imageURL: item.url)
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
    }
}

struct MovieView: View {
    let imageLoader = AsyncImageLoader()
    let title: String
    let imageURL: URL
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                AsyncImageView(url: imageURL, imageLoader: imageLoader)
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
    
    let imageLoader: ImageLoaderProtocol
    let url: URL
    
    init(url: URL, imageLoader: ImageLoaderProtocol) {
        self.url = url
        self.imageLoader = imageLoader
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
                let data = try await imageLoader.imageData(with: url)
                if let image = UIImage(data: data) {
                    state = .success(image)
                } else {
                    state = .failure(URLError(.badURL))
                }
            } catch {
                state = .failure(URLError(.badURL))
            }
        }
    }
}
