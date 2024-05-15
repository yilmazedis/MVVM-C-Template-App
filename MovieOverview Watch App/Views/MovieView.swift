//
//  MovieView.swift
//  MovieOverview Watch App
//
//  Created by yilmaz on 26.04.2024.
//

import SwiftUI

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
