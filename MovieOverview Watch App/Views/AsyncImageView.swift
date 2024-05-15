//
//  AsyncImageView.swift
//  MovieOverview Watch App
//
//  Created by yilmaz on 26.04.2024.
//

import SwiftUI

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
