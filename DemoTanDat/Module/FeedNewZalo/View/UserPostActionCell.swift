import UIKit


class UserPostActionCell: UITableViewCell {
    static let identifier = "SimpleTableViewCell"
    
    let imgAvatar: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "person.circle")
        imgView.tintColor = .systemBlue
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 30
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "How are you today?"
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var actionScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    lazy var actionStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            makeButton(image: "photo", title: "Ảnh"),
            makeButton(image: "video", title: "Video"),
            makeButton(image: "square.stack", title: "Album"),
            makeButton(image: "gift", title: "Kỷ niệm"),
            makeButton(image: "star", title: "Yêu thích"),
            makeButton(image: "clock", title: "Gần đây")
        ])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func makeButton(image: String, title: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let imgView = UIImageView()
        imgView.image = UIImage(systemName: image)
        imgView.tintColor = .systemBlue
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imgView)

        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.text = title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            imgView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imgView.widthAnchor.constraint(equalToConstant: 24),
            imgView.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            containerView.heightAnchor.constraint(equalToConstant: 40),
        ])

        return containerView
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selectionStyle = .none
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(imgAvatar)
        contentView.addSubview(titleLabel)
        contentView.addSubview(actionScrollView)
        contentView.addSubview(separatorLine)
        
        actionScrollView.addSubview(actionStack)
        
        NSLayoutConstraint.activate([
            imgAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imgAvatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imgAvatar.widthAnchor.constraint(equalToConstant: 60),
            imgAvatar.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.leadingAnchor.constraint(equalTo: imgAvatar.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: imgAvatar.centerYAnchor),

            actionScrollView.topAnchor.constraint(equalTo: imgAvatar.bottomAnchor, constant: 12),
            actionScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            actionScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            actionScrollView.heightAnchor.constraint(equalToConstant: 40),

            actionStack.topAnchor.constraint(equalTo: actionScrollView.topAnchor),
            actionStack.bottomAnchor.constraint(equalTo: actionScrollView.bottomAnchor),
            actionStack.leadingAnchor.constraint(equalTo: actionScrollView.leadingAnchor),
           
            actionStack.trailingAnchor.constraint(greaterThanOrEqualTo: actionScrollView.trailingAnchor),
            actionStack.heightAnchor.constraint(equalToConstant: 40),

           
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorLine.topAnchor.constraint(equalTo: actionScrollView.bottomAnchor, constant: 12),
            separatorLine.heightAnchor.constraint(equalToConstant: 8),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

    }
}
