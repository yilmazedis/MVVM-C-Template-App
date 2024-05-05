//
//  PosterList.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import UIKit

private typealias ListDataSource = UICollectionViewDiffableDataSource<PosterListCell.Section, Movie>
private typealias ListSnapshot = NSDiffableDataSourceSnapshot<PosterListCell.Section, Movie>

protocol PosterListDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: PosterListCell, item: MoviePreviewItem)
    func posterListCell(cell: PosterListCell, downloadFor movie: Movie)
}

final class PosterListCell: UITableViewCell {

    static let identifier = "PosterListCell"

    @IBOutlet private weak var collectionView: UICollectionView!
    
    weak var delegate: PosterListDelegate?
    private var dataSource: ListDataSource!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: PosterCell.identifier, bundle: nil), forCellWithReuseIdentifier: PosterCell.identifier)
        collectionView.delegate = self
        configureDataSource()
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

    private func downloadTitleAt(indexPath: IndexPath) {
        guard let movie = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        delegate?.posterListCell(cell: self, downloadFor: movie)
    }
}

extension PosterListCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let movie = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        Task {
            do {
                
                let response: YoutubeSearchResponse = try await NetworkManager.shared.search(from:  K.Youtube.search, with: movie.title)
                let videoElement = response.items[0]                
                let viewModel = MoviePreviewItem(movie: movie, youtubeView: videoElement)
                delegate?.collectionViewTableViewCellDidTapCell(self, item: viewModel)
                
            } catch {
                print(error)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath:
                        IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: indexPath as NSCopying,
            previewProvider: nil) { [weak self] _ in
                guard let self = self else { return nil } // Ensure self is not nil
                let downloadAction = UIAction(title: "Download", image: nil) { _ in
                    self.downloadTitleAt(indexPath: indexPath)
                }
                return UIMenu(title: "", children: [downloadAction])
            }

        return config
    }
}

extension PosterListCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

private extension PosterListCell {
    enum Section: Int {
        case main
    }
}
