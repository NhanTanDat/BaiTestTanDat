import UIKit
import AVKit

class ImageDetailVC: UIViewController, UIScrollViewDelegate {

    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private var currentIndex: Int = 0
    private let mediaItems: [MediaItem]
    
    private var playerViewController: AVPlayerViewController?
    private let videoContainerView = UIView()

    typealias MediaItem = (thumbnail: UIImage, url: URL, isVideo: Bool, isFavorite: Bool)

    init(mediaItems: [MediaItem], initialIndex: Int = 0) {
        self.mediaItems = mediaItems
        self.currentIndex = initialIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupScrollView()
        setupImageView()
        setupGestures()
        setupPlayerViewController()
        setupVideoContainerView()
        displayMedia(at: currentIndex)
    }

    private func setupScrollView() {
        scrollView.frame = view.bounds
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
    }

    private func setupImageView() {
        imageView.frame = scrollView.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        scrollView.addSubview(imageView)
    }

    private func setupGestures() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        leftSwipe.direction = .left
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        rightSwipe.direction = .right
        scrollView.addGestureRecognizer(leftSwipe)
        scrollView.addGestureRecognizer(rightSwipe)
    }

    private func setupPlayerViewController() {
        playerViewController = AVPlayerViewController()
        guard let playerVC = playerViewController else { return }
        playerVC.view.frame = videoContainerView.bounds
        playerVC.view.isHidden = true // Ban đầu ẩn player
        videoContainerView.addSubview(playerVC.view)
        addChild(playerVC)
        playerVC.didMove(toParent: self)
    }

    private func setupVideoContainerView() {
        videoContainerView.frame = view.bounds
        videoContainerView.isHidden = true
        view.addSubview(videoContainerView)
    }

    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale != 1 {
            scrollView.setZoomScale(1.0, animated: true)
        } else {
            let point = gesture.location(in: imageView)
            let newZoomScale = scrollView.maximumZoomScale
            let size = CGSize(width: scrollView.bounds.size.width / newZoomScale,
                              height: scrollView.bounds.size.height / newZoomScale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)
            scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
        }
    }

    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        guard mediaItems.count > 1 else { return }

        if gesture.direction == .left {
            currentIndex = (currentIndex + 1) % mediaItems.count
        } else if gesture.direction == .right {
            currentIndex = (currentIndex - 1 + mediaItems.count) % mediaItems.count
        }

        displayMedia(at: currentIndex)
    }

    private func displayMedia(at index: Int) {
        let item = mediaItems[index]
        
        if item.isVideo {
            let player = AVPlayer(url: item.url)
            playerViewController?.player = player
            playerViewController?.view.isHidden = false
            videoContainerView.isHidden = false
            player.play()

            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
            leftSwipe.direction = .left
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
            rightSwipe.direction = .right
            
            videoContainerView.addGestureRecognizer(leftSwipe)
            videoContainerView.addGestureRecognizer(rightSwipe)
            
            imageView.isHidden = true
        } else {
            imageView.image = item.thumbnail
            imageView.isHidden = false
            videoContainerView.isHidden = true
            playerViewController?.view.isHidden = true
        }
    }


    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

