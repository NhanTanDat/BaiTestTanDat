import UIKit
import AVKit
import AVFoundation

protocol PostCellDelegate: AnyObject {
    func didUpdateCell(_ cell: PostCell)
}

class PostCell: UITableViewCell, ExpandableTextViewDelegate {
    static let identifier = "PostCell"

    private let headerView = PostHeaderView()
    private let textView = ExpandableTextView()
    private let imageGalleryView = PostImageGalleryView()
    private let videoContainerView = UIView()
    private let linkView = LinkPreviewView()
    private let likeView = LikeView()
    private let commentButton = UIButton(type: .system)
    private let actionStack = UIStackView()

    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    weak var delegate: PostCellDelegate?

    var isExpanded = false

    private var imageGalleryHeightConstraint: NSLayoutConstraint?
    private var imageGalleryTopConstraint: NSLayoutConstraint?

    private var videoHeightConstraint: NSLayoutConstraint?
    private var videoTopConstraint: NSLayoutConstraint?

    private var linkViewHeightConstraint: NSLayoutConstraint?
    private var linkViewTopConstraint: NSLayoutConstraint?

    private var playerLayer: AVPlayerLayer?
    var player: AVPlayer?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        selectionStyle = .none

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

        [headerView, textView, imageGalleryView, videoContainerView, linkView, actionStack, separatorLine].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        imageGalleryTopConstraint = imageGalleryView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8)
        imageGalleryTopConstraint?.isActive = true
        imageGalleryHeightConstraint = imageGalleryView.heightAnchor.constraint(equalToConstant: 0)
        imageGalleryHeightConstraint?.priority = .defaultHigh
        imageGalleryHeightConstraint?.isActive = true

        videoTopConstraint = videoContainerView.topAnchor.constraint(equalTo: imageGalleryView.bottomAnchor, constant: 8)
        videoTopConstraint?.isActive = true
        videoHeightConstraint = videoContainerView.heightAnchor.constraint(equalToConstant: 0)
        videoHeightConstraint?.priority = .defaultHigh
        videoHeightConstraint?.isActive = true

        linkViewTopConstraint = linkView.topAnchor.constraint(equalTo: videoContainerView.bottomAnchor, constant: 8)
        linkViewTopConstraint?.isActive = true
        linkViewHeightConstraint = linkView.heightAnchor.constraint(equalToConstant: 0)
        linkViewHeightConstraint?.priority = .defaultHigh
        linkViewHeightConstraint?.isActive = false // mặc định tắt

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            textView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            imageGalleryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageGalleryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            videoContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            videoContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            linkView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            linkView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            actionStack.topAnchor.constraint(equalTo: linkView.bottomAnchor, constant: 12),
            actionStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),

            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorLine.topAnchor.constraint(equalTo: actionStack.bottomAnchor, constant: 12),
            separatorLine.heightAnchor.constraint(equalToConstant: 8),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        actionStack.bottomAnchor.constraint(equalTo: separatorLine.topAnchor, constant: -12).isActive = true

        textView.expandDelegate = self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        playerLayer?.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: videoHeightConstraint?.constant ?? 0)
    }

    func configure(with post: PostModel) {
        isExpanded = post.isExpandedStates
        headerView.configure(avatar: post.avatar, name: post.username, time: post.time)
        textView.fullText = post.text
        textView.isExpanded = isExpanded

        if !post.images.isEmpty {
            imageGalleryView.isHidden = false
            imageGalleryTopConstraint?.constant = 8
            let galleryHeight = calculateGalleryHeight(for: post.images, containerWidth: UIScreen.main.bounds.width - 24)
            imageGalleryHeightConstraint?.constant = galleryHeight
            imageGalleryView.configure(with: post.images)
        } else {
            imageGalleryView.isHidden = true
            imageGalleryTopConstraint?.constant = 0
            imageGalleryHeightConstraint?.constant = 0
        }

        if let videoName = post.videoName, !videoName.isEmpty,
           let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
            videoContainerView.isHidden = false
            videoTopConstraint?.constant = 16
            videoHeightConstraint?.constant = 450

            player?.pause()
            playerLayer?.removeFromSuperlayer()

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Failed to setup audio session: \(error)")
            }

            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = .resizeAspect
            if let playerLayer = playerLayer {
                videoContainerView.layer.addSublayer(playerLayer)
            }

            DispatchQueue.main.async { [weak self] in
                self?.player?.play()
            }
        } else {
            videoContainerView.isHidden = true
            videoTopConstraint?.constant = 0
            videoHeightConstraint?.constant = 0
            player?.pause()
            playerLayer?.removeFromSuperlayer()
            player?.replaceCurrentItem(with: nil)
            player = nil
            playerLayer = nil
        }

        if post.linkTitle.isEmpty {
            linkView.isHidden = true
            linkViewTopConstraint?.constant = 0
            linkViewHeightConstraint?.isActive = true
        } else {
            linkView.isHidden = false
            linkView.configure(title: post.linkTitle, subtitle: post.linkSubtitle)
            linkViewTopConstraint?.constant = 8
            linkViewHeightConstraint?.isActive = false
        }

        likeView.configure(count: 123)
    }

    private func calculateGalleryHeight(for images: [UIImage], containerWidth: CGFloat) -> CGFloat {
        let maxImages = min(images.count, 9)
        let imagesPerRow = 3
        let spacing: CGFloat = 4
        let totalSpacing = spacing * CGFloat(imagesPerRow - 1)
        let rowWidth = containerWidth - totalSpacing
        var totalHeight: CGFloat = 0

        for rowIndex in 0..<Int(ceil(Double(maxImages) / Double(imagesPerRow))) {
            let startIndex = rowIndex * imagesPerRow
            let endIndex = min(startIndex + imagesPerRow, maxImages)
            let rowImages = images[startIndex..<endIndex]
            let itemWidth = rowWidth / CGFloat(rowImages.count)
            let rowHeight = rowImages.map { image -> CGFloat in
                let aspectRatio = image.size.height / image.size.width
                return itemWidth * aspectRatio
            }.max() ?? 0
            totalHeight += rowHeight
            if rowIndex < Int(ceil(Double(maxImages) / Double(imagesPerRow))) - 1 {
                totalHeight += spacing
            }
        }
        return totalHeight
    }

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
    
    func pauseVideo() {
        player?.pause()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player?.replaceCurrentItem(with: nil)
        player = nil
        playerLayer = nil
    }
}

