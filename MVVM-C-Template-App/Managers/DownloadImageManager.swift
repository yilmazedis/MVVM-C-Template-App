//
//  DownloadImageManager.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 25.04.2024.
//

import UIKit

enum ImageError: Error {
    case invalidImageData
}

final class DownloadImageManager {
    static let shared = DownloadImageManager()
    let baseURL = "https://image.tmdb.org/t/p/w200/"
    
    private func handleResponse(data: Data?, response: URLResponse?) throws -> Data {
        guard let data = data,
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.cannotDecodeRawData)
        }
        return data
    }
    
    private func downloadWithAsync(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        return try handleResponse(data: data, response: response)
    }
    
    func getImage(with path: String) async throws -> UIImage {
        
        guard let url = URL(string: baseURL + path) else { throw URLError(.badURL) }
        
        if let cachedImage = ImageCacheFileManager.shared.get(key: path) {
            print("Cache")
            return cachedImage
        }
        
        let imageData = try await downloadWithAsync(url: url)
        guard let image = UIImage(data: imageData) else {
            throw ImageError.invalidImageData
        }
        ImageCacheFileManager.shared.add(key: path, value: image)
        print("Network")
        return image
    }
}
