import UIKit

protocol ImageCellDelegate: AnyObject {
    func didLongPress(at indexPath: IndexPath)
}

class ImageCell: UICollectionViewCell {
    weak var delegate: ImageCellDelegate?

    var indexPath: IndexPath?

    let imageView = UIImageView()
    let videoIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: "play.circle.fill"))
        icon.tintColor = .white
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isHidden = true
        return icon
    }()
    
    let favoriteIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: "heart.fill"))
        icon.tintColor = .systemRed
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isHidden = true
        return icon
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        // Gesture recognizer for long press
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress)))
        self.isUserInteractionEnabled = true
    }

    private func setupViews() {
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        contentView.addSubview(videoIcon)
        contentView.addSubview(favoriteIcon)

        NSLayoutConstraint.activate([
            videoIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            videoIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            videoIcon.widthAnchor.constraint(equalToConstant: 20),
            videoIcon.heightAnchor.constraint(equalToConstant: 20),

            favoriteIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            favoriteIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            favoriteIcon.widthAnchor.constraint(equalToConstant: 20),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    @objc private func longPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began,
              let collectionView = self.superview as? UICollectionView,
              let indexPath = collectionView.indexPath(for: self) else { return }

        delegate?.didLongPress(at: indexPath)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setVideoIconVisible(_ visible: Bool) {
        videoIcon.isHidden = !visible
    }

    func setFavoriteVisible(_ visible: Bool) {
        favoriteIcon.isHidden = !visible
    }

    func setImage(_ image: UIImage) {
        let targetSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height)
        if let resizedImage = resizeImage(image: image, targetSize: targetSize) {
            imageView.image = resizedImage
        }
    }

    deinit {
        imageView.image = nil
    }

    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let scale = UIScreen.main.scale
        let newWidth = targetSize.width * scale
        let newHeight = targetSize.height * scale

        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, scale)
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}
