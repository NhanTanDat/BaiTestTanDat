import UIKit

class FeedCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let videoIcon = UIImageView()
    let playerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        contentView.addSubview(playerView)
        contentView.addSubview(videoIcon)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        playerView.backgroundColor = .clear
        playerView.isUserInteractionEnabled = false

        videoIcon.image = UIImage(systemName: "video.fill")
        videoIcon.tintColor = .white
        videoIcon.translatesAutoresizingMaskIntoConstraints = false

        imageView.frame = contentView.bounds
        playerView.frame = contentView.bounds

        NSLayoutConstraint.activate([
            videoIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            videoIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            videoIcon.widthAnchor.constraint(equalToConstant: 24),
            videoIcon.heightAnchor.constraint(equalToConstant: 24),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil

        videoIcon.isHidden = true
        playerView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }

    func configure(with image: UIImage?, isVideo: Bool) {
        imageView.image = image
        videoIcon.isHidden = !isVideo
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

