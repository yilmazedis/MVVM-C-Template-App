//
//  MovieView.swift
//  MovieOverview Watch App
//
//  Created by yilmaz on 26.04.2024.
//

import SwiftUI

struct MovieView: View {
    let movie: Movie
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                AsyncImageView(path: movie.posterPath)
                    .cornerRadius(10)
                VStack {
                    Spacer()
                    Text(movie.title)
                        .padding()
                        .background(.black.opacity(0.45))
                        .cornerRadius(4)
                }
            }
            Button {
                PhoneConnector.shared.sendDataToPhone(movie)
            } label: {
                Text("Download")
            }
        }
        .ignoresSafeArea()
    }
}
