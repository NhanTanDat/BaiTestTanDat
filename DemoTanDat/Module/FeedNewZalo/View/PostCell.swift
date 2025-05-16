import UIKit

protocol PostCellDelegate: AnyObject {
    func didUpdateCell(_ cell: PostCell)
}

class PostCell: UITableViewCell, ExpandableTextViewDelegate {
    static let identifier = "PostCell"

    private let headerView = PostHeaderView()
    private let textView = ExpandableTextView()
    private let postImageView = UIImageView()
    private let linkView = LinkPreviewView()
    private let likeView = LikeView()
    private let commentButton = UIButton(type: .system)
    private let actionStack = UIStackView()

    weak var delegate: PostCellDelegate?

    var isExpanded = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        selectionStyle = .none

        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        commentButton.setTitle("Bình luận", for: .normal)
        commentButton.setTitleColor(.darkGray, for: .normal)
        commentButton.titleLabel?.font = .systemFont(ofSize: 14)
        commentButton.backgroundColor = .systemGray6
        commentButton.layer.cornerRadius = 15
        commentButton.clipsToBounds = true
        commentButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

        actionStack.axis = .horizontal
        actionStack.spacing = 12
        actionStack.alignment = .center
        actionStack.translatesAutoresizingMaskIntoConstraints = false
        actionStack.addArrangedSubview(likeView)
        actionStack.addArrangedSubview(commentButton)

        likeView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        commentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        [headerView, textView, postImageView, linkView, actionStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            textView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            postImageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            linkView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 8),
            linkView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            linkView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            actionStack.topAnchor.constraint(equalTo: linkView.bottomAnchor, constant: 12),
            actionStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            actionStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        textView.expandDelegate = self
    }

    func configure(with post: PostModel) {
        self.isExpanded = post.isExpandedStates
        headerView.configure(avatar: post.avatar, name: post.username, time: post.time)
        textView.fullText = post.text
        textView.isExpanded = isExpanded
        postImageView.image = post.image
        linkView.configure(title: post.linkTitle, subtitle: post.linkSubtitle)
        likeView.configure(count: 123)
    }

    // MARK: - ExpandableTextViewDelegate
    func didTapSeeMore() {
        isExpanded = true
        textView.isExpanded = true
        delegate?.didUpdateCell(self)
    }

    func didTapCollapse() {
        isExpanded = false
        textView.isExpanded = false
        delegate?.didUpdateCell(self)
    }
}

