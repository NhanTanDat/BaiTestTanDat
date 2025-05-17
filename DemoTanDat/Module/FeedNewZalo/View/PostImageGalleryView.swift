//
//  PostImageGalleryView.swift
//  DemoTanDat
//
//  Created by Đại Lợi Đẹp Trai on 17/5/25.
//

import UIKit

class PostImageGalleryView: UIView {
    private var images: [UIImage] = []

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = false
        cv.backgroundColor = .clear
        return cv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: "ImageViewCell")

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func configure(with images: [UIImage]) {
        self.images = images
        collectionView.reloadData()
    }
}

extension PostImageGalleryView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(images.count, 9)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell
        cell.configure(with: images[indexPath.item])

        if indexPath.item == 8 && images.count > 9 {
            let remaining = images.count - 9
            cell.setOverlayText("+\(remaining)")
        } else {
            cell.setOverlayText(nil)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 4
        let width = collectionView.bounds.width
        let image = images[indexPath.item]
        let aspectRatio = image.size.height / image.size.width

        switch images.count {
        case 1:
            let targetWidth = width
            let targetHeight = targetWidth * aspectRatio
            return CGSize(width: targetWidth, height: targetHeight)

        case 2:
            let targetWidth = (width - spacing) / 2
            let targetHeight = targetWidth * aspectRatio
            return CGSize(width: targetWidth, height: targetHeight)

        case 3:
            if indexPath.item == 0 {
                let targetWidth = (width - spacing) * 2 / 3
                let targetHeight = targetWidth * aspectRatio
                return CGSize(width: targetWidth, height: targetHeight)
            } else {
                let targetWidth = (width - spacing) / 3
                let targetHeight = targetWidth * aspectRatio
                return CGSize(width: targetWidth, height: targetHeight)
            }

        case 4:
            let targetWidth = (width - spacing) / 2
            let targetHeight = targetWidth * aspectRatio
            return CGSize(width: targetWidth, height: targetHeight)

        default:
            let targetWidth = (width - 2 * spacing) / 3
            let targetHeight = targetWidth * aspectRatio
            return CGSize(width: targetWidth, height: targetHeight)
        }
    }

}
