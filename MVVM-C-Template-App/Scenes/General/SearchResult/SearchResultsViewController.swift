//
//  SearchResultsViewController.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import UIKit

protocol SearchResultsViewDelegate: AnyObject {
    func searchResultsViewDidTapItem(_ previewItem: MoviePreviewItem)
}

class SearchResultsViewController: UIViewController {
    
    private var viewModel: SearchResultsViewModel!
    
    var movies: [Movie] = [Movie]()
    
    weak var delegate: SearchResultsViewDelegate?
    
    let searchResultsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: PosterCell.identifier, bundle: nil), forCellWithReuseIdentifier: PosterCell.identifier)
        return collectionView
    }()
    
    convenience init(viewModel: SearchResultsViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.identifier, for: indexPath) as? PosterCell else {
            return UICollectionViewCell()
        }
        
        
        let title = movies[indexPath.row]
        cell.configure(with: title.posterPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        let titleName = movie.title
        Task {
            do {
                let videoElement = try await viewModel.searchYoutubeVideo(from: K.Youtube.search, with: titleName)
                
                let previewItem = MoviePreviewItem(title: movie.title, youtubeView: videoElement, titleOverview: movie.overview)
                
                delegate?.searchResultsViewDidTapItem(previewItem)
            } catch {
                print(error)
            }
        }
    }
}
