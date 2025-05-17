import UIKit

class CustomTabView: UIView {

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let badgeLabel = UILabel()

    var tapAction: (() -> Void)?

    init(title: String, image: UIImage?) {
        super.init(frame: .zero)
        setupView(title: title, image: image)
        setupGesture()
        setupBadge()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(title: String, image: UIImage?) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
        ])
    }

    private func setupBadge() {
        badgeLabel.backgroundColor = .systemRed
        badgeLabel.textColor = .white
        badgeLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 10
        badgeLabel.layer.borderWidth = 2
        badgeLabel.layer.borderColor = UIColor.white.cgColor
        badgeLabel.layer.masksToBounds = true
        badgeLabel.isHidden = true
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(badgeLabel)

        NSLayoutConstraint.activate([
            badgeLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -6),
            badgeLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 18),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            badgeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func setBadge(text: String) {
        if text.count > 0 {
            badgeLabel.isHidden = false
            badgeLabel.text = text 
        } else {
            badgeLabel.isHidden = true
        }
    }

    func setActive(_ active: Bool) {
        titleLabel.textColor = active ? .systemBlue : .gray
        imageView.tintColor = active ? .systemBlue : .gray
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }

    @objc private func handleTap() {
        tapAction?()
    }
}
