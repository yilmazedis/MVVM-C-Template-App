//
//  SearchResultsViewController.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 19.04.2024.
//

import UIKit

private typealias ListDataSource = UICollectionViewDiffableDataSource<SearchResultsViewModel.Section, Movie>
private typealias ListSnapshot = NSDiffableDataSourceSnapshot<SearchResultsViewModel.Section, Movie>

protocol SearchResultsViewDelegate: AnyObject {
    func searchResultsViewDidTapItem(_ previewItem: MoviePreviewItem)
}

class SearchResultsViewController: UIViewController {
    
    private var viewModel: SearchResultsViewModel!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    weak var delegate: SearchResultsViewDelegate?
    private var dataSource: ListDataSource!
    
    convenience init(viewModel: SearchResultsViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        configureDataSource()
    }
    
    private func prepareView() {
        view.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.register(UINib(nibName: PosterCell.identifier, bundle: nil), forCellWithReuseIdentifier: PosterCell.identifier)
    }
    
    private func configureDataSource() {
        dataSource = ListDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.identifier, for: indexPath) as! PosterCell
            cell.configure(with: item.posterPath)
            return cell
        }
    }
    
    func applySnapshot(from movies: [Movie]) {
        var snapshot = ListSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let movie = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        Task {
            do {
                let videoElement = try await viewModel.searchYoutubeVideo(from: K.Youtube.search, with: movie.title)
                let previewItem = MoviePreviewItem(movie: movie, youtubeView: videoElement)
                delegate?.searchResultsViewDidTapItem(previewItem)
            } catch {
                print(error)
            }
        }
    }
}

extension SearchResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
