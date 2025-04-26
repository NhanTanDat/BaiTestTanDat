import UIKit

protocol ImageCellDelegate: AnyObject {
    func didLongPress(at indexPath:IndexPath)
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
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        contentView.addSubview(videoIcon)
        NSLayoutConstraint.activate([
            videoIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            videoIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            videoIcon.widthAnchor.constraint(equalToConstant: 20),
            videoIcon.heightAnchor.constraint(equalToConstant: 20)
        ])

        contentView.addSubview(favoriteIcon)
        NSLayoutConstraint.activate([
            favoriteIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            favoriteIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            favoriteIcon.widthAnchor.constraint(equalToConstant: 20),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress)))
        self.isUserInteractionEnabled = true
    }
    
    @objc func longPress(_ gesture: UILongPressGestureRecognizer) {
        guard let indexPath, gesture.state == .began else { return }
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
}


