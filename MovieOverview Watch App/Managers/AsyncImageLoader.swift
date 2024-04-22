//
//  AsyncImageLoader.swift
//  MovieOverview Watch App
//
//  Created by yilmaz on 21.04.2024.
//

import Foundation

protocol ImageLoaderProtocol {
    func imageData(with url: URL) async throws -> Data
}

final class AsyncImageLoader: ImageLoaderProtocol {
    func imageData(with url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        return try handleResponse(data: data, response: response)
    }
    
    private func handleResponse(data: Data?, response: URLResponse?) throws -> Data {
        guard let data = data,
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.cannotDecodeRawData)
        }
        return data
    }
}
