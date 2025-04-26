import UIKit
import AVKit

class FeedCell: UICollectionViewCell {
    let imageView = UIImageView()
    let videoIcon = UIImageView()
    let playerContainerView = UIView() 

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(videoIcon)
        contentView.addSubview(playerContainerView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        videoIcon.translatesAutoresizingMaskIntoConstraints = false
        playerContainerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            videoIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            videoIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            videoIcon.widthAnchor.constraint(equalToConstant: 24),
            videoIcon.heightAnchor.constraint(equalToConstant: 24),

            playerContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playerContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playerContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            playerContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        playerContainerView.backgroundColor = .clear
        playerContainerView.isUserInteractionEnabled = false 
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

