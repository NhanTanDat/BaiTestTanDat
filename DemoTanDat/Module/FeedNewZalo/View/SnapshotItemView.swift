import UIKit

struct SnapshotItem {
    let image: UIImage
    let avatar: UIImage
    let name: String
}

class SnapshotItemView: UIView {
    private let mainImageView = UIImageView()
    private let avatarImageView = UIImageView()
    private let avatarContainerView = UIView()
    private let nameLabel = UILabel()
    private let infoStackView = UIStackView()
    
    init(item: SnapshotItem) {
        super.init(frame: .zero)
        setupViews(item: item)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews(item: SnapshotItem) {
        translatesAutoresizingMaskIntoConstraints = false
       
        mainImageView.image = item.image
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        mainImageView.layer.cornerRadius = 8
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainImageView)

        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainImageView.widthAnchor.constraint(equalToConstant: 130),
            mainImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        let gradientView = UIView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.isUserInteractionEnabled = false
        mainImageView.addSubview(gradientView)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.6).cgColor
        ]
        gradientLayer.locations = [0.5, 1.0]
        gradientLayer.cornerRadius = 8
        gradientView.layer.insertSublayer(gradientLayer, at: 0)

        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: mainImageView.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor)
        ])
        layoutIfNeeded()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 130, height: 200)

        avatarImageView.image = item.avatar
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 30
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        avatarContainerView.translatesAutoresizingMaskIntoConstraints = false
        avatarContainerView.addSubview(avatarImageView)

        NSLayoutConstraint.activate([
            avatarContainerView.widthAnchor.constraint(equalToConstant: 68),
            avatarContainerView.heightAnchor.constraint(equalToConstant: 68),
            
            avatarImageView.centerXAnchor.constraint(equalTo: avatarContainerView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: avatarContainerView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        let ringLayer = CAShapeLayer()
        let center = CGPoint(x: 34, y: 34)
        let radius: CGFloat = 30 + 2
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        ringLayer.path = circlePath.cgPath
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeColor = UIColor.blue.cgColor
        ringLayer.lineWidth = 1.5
        
        avatarContainerView.layer.insertSublayer(ringLayer, at: 0)

        nameLabel.text = item.name
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .clear
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        infoStackView.axis = .vertical
        infoStackView.spacing = 4
        infoStackView.alignment = .center
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.addArrangedSubview(avatarContainerView)
        infoStackView.addArrangedSubview(nameLabel)

        mainImageView.addSubview(infoStackView)

        NSLayoutConstraint.activate([
            infoStackView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -8),
            infoStackView.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor)
        ])
    }
}

