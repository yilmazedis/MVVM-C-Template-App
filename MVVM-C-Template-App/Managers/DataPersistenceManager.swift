//
//  DataPersistenceManager.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import UIKit
import CoreData

class DataPersistenceManager {

    enum DatabasError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }

    static let shared = DataPersistenceManager()

    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        let item = MovieItem(context: context)

        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.original_name = model.original_name
        item.overview = model.overview
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average

        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabasError.failedToSaveData))
        }
    }

    func fetchingTitlesFromDataBase(completion: @escaping (Result<[MovieItem], Error>) -> Void) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        let request: NSFetchRequest<MovieItem>

        request = MovieItem.fetchRequest()

        do {

            let titles = try context.fetch(request)
            completion(.success(titles))

        } catch {
            completion(.failure(DatabasError.failedToFetchData))
        }
    }

    func deleteTitleWith(model: MovieItem, completion: @escaping (Result<Void, Error>)-> Void) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        context.delete(model)

        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabasError.failedToDeleteData))
        }
    }
}
