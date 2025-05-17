//
//  ImageCell.swift
//  DemoTanDat
//
//  Created by Đại Lợi Đẹp Trai on 17/5/25.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let overlayLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 0, alpha: 0.5)
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(overlayLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            overlayLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            overlayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            overlayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            overlayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with image: UIImage) {
        imageView.image = image
        overlayLabel.isHidden = true
    }

    func setOverlayText(_ text: String?) {
        if let text = text, !text.isEmpty {
            overlayLabel.text = text
            overlayLabel.isHidden = false
        } else {
            overlayLabel.isHidden = true
            overlayLabel.text = nil
        }
    }
}
