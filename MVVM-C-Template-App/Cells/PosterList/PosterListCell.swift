//
//  PosterList.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import UIKit

protocol PosterListDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: PosterListCell, item: MoviePreviewItem)
}

final class PosterListCell: UITableViewCell {

    static let identifier = "PosterListCell"

    @IBOutlet private weak var collectionView: UICollectionView!
    
    weak var delegate: PosterListDelegate?
    private var titles: [Movie] = [Movie]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: PosterCell.identifier, bundle: nil), forCellWithReuseIdentifier: PosterCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    public func configure(with titles: [Movie]) {
        self.titles = titles
        collectionView.reloadData()
    }

    private func downloadTitleAt(indexPath: IndexPath) {
        let movie = titles[indexPath.row]
        Task {
            let movieItem = try await DataPersistenceManager.shared.download(movie: movie)
            InfoAlertView.shared.showAlert(message: "Successfully Downloaded", completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: movieItem)
        }
    }
}

extension PosterListCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.identifier, for: indexPath) as? PosterCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: titles[indexPath.row].posterPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let movie = titles[indexPath.row]
        
        Task {
            do {
                let videoElement = try await Youtube.shared.search(from: K.Youtube.search, with: movie.title)
                
                let title = titles[indexPath.row]
                let viewModel = MoviePreviewItem(movie: title, youtubeView: videoElement)
                delegate?.collectionViewTableViewCellDidTapCell(self, item: viewModel)
                
            } catch {
                print(error.localizedDescription)
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
