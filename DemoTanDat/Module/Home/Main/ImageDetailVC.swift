import UIKit

class ImageDetailVC: UIViewController, UIScrollViewDelegate {

    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private var currentIndex: Int = 0
    private let images: [UIImage]

    init(image: UIImage) {
        self.images = [image]
        self.imageView.image = image
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
        guard images.count > 1 else { return }

        if gesture.direction == .left {
            currentIndex = (currentIndex + 1) % images.count
        } else if gesture.direction == .right {
            currentIndex = (currentIndex - 1 + images.count) % images.count
        }

        imageView.image = images[currentIndex]
        scrollView.setZoomScale(1.0, animated: false)
    }

    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

