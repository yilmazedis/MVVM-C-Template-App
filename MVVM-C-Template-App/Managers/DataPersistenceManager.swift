//
//  DataPersistenceManager.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import UIKit
import CoreData

@MainActor
class DataPersistenceManager {

    enum DatabaseError: Error {
        case saveData
        case fetchData
        case deleteData
        case invalidDelegate
    }

    static let shared = DataPersistenceManager()

    private func download(movie: Movie, completion: @escaping (Result<MovieItem, Error>) -> Void) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(.failure(DatabaseError.invalidDelegate))
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        let item = MovieItem(context: context)

        item.id = Int64(movie.id)
        item.title = movie.title
        item.overview = movie.overview
        item.mediaType = movie.mediaType
        item.posterPath = movie.posterPath
        item.voteCount = Int64(movie.voteCount)
        item.voteAverage = movie.voteAverage

        do {
            try context.save()
            completion(.success(item))
        } catch {
            completion(.failure(DatabaseError.saveData))
        }
    }

    private func fetchingTitlesFromDataBase(completion: @escaping (Result<[MovieItem], Error>) -> Void) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(.failure(DatabaseError.invalidDelegate))
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<MovieItem>
        request = MovieItem.fetchRequest()

        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DatabaseError.fetchData))
        }
    }

    private func deleteTitleWith(model: MovieItem, completion: @escaping (Result<Void, Error>)-> Void) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(.failure(DatabaseError.invalidDelegate))
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)

        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.deleteData))
        }
    }
}

extension DataPersistenceManager {
    
    func download(movie: Movie) async throws -> MovieItem {
        return try await withCheckedThrowingContinuation {(continuation: CheckedContinuation<MovieItem, Error>) in
            download(movie: movie) { result in
                switch result {
                case .success(let title):
                    continuation.resume(returning: title)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchingTitlesFromDataBase() async throws -> [MovieItem] {
        return try await withCheckedThrowingContinuation {(continuation: CheckedContinuation<[MovieItem], Error>) in
            fetchingTitlesFromDataBase { result in
                switch result {
                case .success(let titles):
                    continuation.resume(returning: titles)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func deleteTitleWith(model: MovieItem) async throws {
        return try await withCheckedThrowingContinuation {(continuation: CheckedContinuation<Void, Error>) in
            deleteTitleWith(model: model) { result in
                switch result {
                case .success(let status):
                    continuation.resume(returning: status)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
