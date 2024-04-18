//
//  TheMovieDB.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import UIKit

class TheMovieDB {
    static let shared = TheMovieDB()
    
    private func handleResponse(data: Data?, response: URLResponse?) throws -> [Title] {
        guard let data = data,
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        
        do {
            let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
            return result.results
        } catch {
            throw error
        }
    }
    
    func get(from address: String) async throws -> [Title] {
        guard let url = URL(string: address) else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        let titles = try handleResponse(data: data, response: response)
        return titles
    }
    
    func search(from address: String, with query: String) async throws -> [Title]{
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            throw URLError(.badServerResponse)
        }
        
        guard let url = URL(string: address + query) else {
            throw URLError(.badServerResponse)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        let titles = try handleResponse(data: data, response: response)
        return titles
    }
}

class DownloadImageAsyncImageLoader {
    
    static let shared = DownloadImageAsyncImageLoader()
    
    private func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                return nil
            }
        return image
    }
    
    func downloadWithAsync(url: URL) async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            return handleResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
}
