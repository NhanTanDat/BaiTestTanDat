import UIKit



class ContactCell: UITableViewCell {
    
    static let identifier = "ContactCell"
    
    var didTapButton: ((String) -> Void)?


    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true // quan trọng để nhận tap
        label.textColor = .label
        return label
    }()

    let phoneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        button.tintColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let videoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "video.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        selectionStyle = .none
        addTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(phoneButton)
        contentView.addSubview(videoButton)

        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 15),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),

            videoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            videoButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            videoButton.widthAnchor.constraint(equalToConstant: 30),
            videoButton.heightAnchor.constraint(equalToConstant: 30),

            phoneButton.trailingAnchor.constraint(equalTo: videoButton.leadingAnchor, constant: -15),
            phoneButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            phoneButton.widthAnchor.constraint(equalToConstant: 30),
            phoneButton.heightAnchor.constraint(equalToConstant: 30),

            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: phoneButton.leadingAnchor, constant: -10)
        ])
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapNameLabel))
        nameLabel.addGestureRecognizer(tap)
    }
    
    @objc private func didTapNameLabel() {
        if let name = nameLabel.text {
            didTapButton?(name)
        }
    }

    func configure(with name: String, avatar: UIImage) {
        nameLabel.text = name
        avatarImageView.image = avatar
    }
}

