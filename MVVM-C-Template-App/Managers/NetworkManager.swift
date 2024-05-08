//
//  NetworkManager.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import UIKit

protocol NetworkManagerProtocol {
    func get<T: Decodable>(from address: String) async throws -> T
    func search<T: Decodable>(from address: String, with query: String) async throws -> T
}

final class NetworkManager: NetworkManagerProtocol {
    
    private let delegateQueue: OperationQueue
    
    init(qualityOfService: QualityOfService = .userInteractive) {
        self.delegateQueue = OperationQueue()
        self.delegateQueue.qualityOfService = qualityOfService
    }
    
    func get<T: Decodable>(from address: String) async throws -> T {
        guard let url = URL(string: address) else { throw URLError(.badURL) }
        let (data, response) = try await URLSession(configuration: .default, delegate: nil, delegateQueue: delegateQueue).data(from: url)
        return try handleResponse(data: data, response: response)
    }
    
    func search<T: Decodable>(from address: String, with query: String) async throws -> T {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            throw URLError(.badServerResponse)
        }
        
        guard let url = URL(string: address + query) else {
            throw URLError(.badServerResponse)
        }
        
        let (data, response) = try await URLSession(configuration: .default, delegate: nil, delegateQueue: delegateQueue).data(from: url)
        return try handleResponse(data: data, response: response)
    }
    
    private func handleResponse<T: Decodable>(data: Data?, response: URLResponse?) throws -> T {
        guard let data = data,
              let response = response as? HTTPURLResponse,
              (200..<300).contains(response.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
