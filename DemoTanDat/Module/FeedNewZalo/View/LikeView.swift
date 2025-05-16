//
//  LikeView.swift
//  DemoTanDat
//
//  Created by Đại Lợi Đẹp Trai on 16/5/25.
//

import UIKit

class LikeView: UIView {
    let likeButton = UIButton(type: .system)
    private let heartIcon = UIImageView()
    private let separator = UIView()
    private let heartFill = UIImageView()
    private let countLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6
        layer.cornerRadius = 15
        clipsToBounds = true
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        heartIcon.image = UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate)
        heartIcon.tintColor = .systemGray
        heartIcon.translatesAutoresizingMaskIntoConstraints = false
        heartIcon.contentMode = .scaleAspectFit

        heartFill.image = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
        heartFill.tintColor = .systemRed
        heartFill.translatesAutoresizingMaskIntoConstraints = false
        heartFill.contentMode = .scaleAspectFit

        likeButton.setTitle("Thích", for: .normal)
        likeButton.setTitleColor(.darkGray, for: .normal)
        likeButton.titleLabel?.font = .systemFont(ofSize: 14)
        likeButton.translatesAutoresizingMaskIntoConstraints = false

        separator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        separator.translatesAutoresizingMaskIntoConstraints = false

        countLabel.font = .systemFont(ofSize: 14)
        countLabel.textColor = .darkGray
        countLabel.translatesAutoresizingMaskIntoConstraints = false

        [heartIcon, likeButton, separator, heartFill, countLabel].forEach { addSubview($0) }

        NSLayoutConstraint.activate([
            heartIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            heartIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            heartIcon.widthAnchor.constraint(equalToConstant: 20),
            heartIcon.heightAnchor.constraint(equalToConstant: 20),

            likeButton.leadingAnchor.constraint(equalTo: heartIcon.trailingAnchor, constant: 4),
            likeButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            separator.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 8),
            separator.widthAnchor.constraint(equalToConstant: 1),
            separator.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),

            heartFill.leadingAnchor.constraint(equalTo: separator.trailingAnchor, constant: 8),
            heartFill.centerYAnchor.constraint(equalTo: centerYAnchor),
            heartFill.widthAnchor.constraint(equalToConstant: 20),
            heartFill.heightAnchor.constraint(equalToConstant: 20),

            countLabel.leadingAnchor.constraint(equalTo: heartFill.trailingAnchor, constant: 4),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configure(count: Int) {
        countLabel.text = "\(count)"
    }
}
