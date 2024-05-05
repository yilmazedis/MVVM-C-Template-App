//
//  NetworkManager.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    func get<T: Decodable>(from address: String) async throws -> T {
        guard let url = URL(string: address) else { throw URLError(.badURL) }
        let (data, response) = try await URLSession.shared.data(from: url)
        return try handleResponse(data: data, response: response)
    }
    
    func search<T: Decodable>(from address: String, with query: String) async throws -> T {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            throw URLError(.badServerResponse)
        }
        
        guard let url = URL(string: address + query) else {
            throw URLError(.badServerResponse)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        return try handleResponse(data: data, response: response)
    }
    
    private func handleResponse<T: Decodable>(data: Data?, response: URLResponse?) throws -> T {
        guard let data = data,
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

class DownloadImageAsyncImageLoader {
    static let shared = DownloadImageAsyncImageLoader()
    
    private func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard let data = data,
              let image = UIImage(data: data),
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
    }
    
    func downloadWithAsync(url: URL) async throws -> UIImage? {
        let (data, response) = try await URLSession.shared.data(from: url)
        return handleResponse(data: data, response: response)
    }
}
