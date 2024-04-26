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

    weak var delegate: PosterListDelegate?

    private var titles: [Movie] = [Movie]()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.identifier)
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)

        collectionView.delegate = self
        collectionView.dataSource = self
    }


    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }


    public func configure(with titles: [Movie]) {
        self.titles = titles
        collectionView.reloadData()
    }

    private func downloadTitleAt(indexPath: IndexPath) {
        let movie = titles[indexPath.row]
        Task {
            let movieItem = try await DataPersistenceManager.shared.download(movie: movie)
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
                let viewModel = MoviePreviewItem(title: movie.title, youtubeView: videoElement, titleOverview: title.overview)
                delegate?.collectionViewTableViewCellDidTapCell(self, item: viewModel)
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.downloadTitleAt(indexPath: indexPath)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }

        return config
    }
}
