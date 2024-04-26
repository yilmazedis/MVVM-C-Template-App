//
//  Youtube.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import Foundation

class Youtube {
    
    static let shared = Youtube()
    
    func search(from address: String, with query: String) async throws -> VideoElement {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            throw URLError(.badURL)
        }
        
        guard let url = URL(string: address + query) else {
            throw URLError(.badURL)
        }
                
        let (data, response) = try await URLSession.shared.data(from: url)
        let titles = try handleResponse(data: data, response: response)
        return titles
    }
    
    private func handleResponse(data: Data?, response: URLResponse?) throws -> VideoElement {
        guard let data = data,
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        let result = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
        return result.items[0]
    }
}
