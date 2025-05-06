import UIKit
import AVKit

protocol FeedVCDelegate: AnyObject {
    func pushVC(at vc: UIViewController)
    func presentVC(at vc: UIViewController)
}

class FeedVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: FeedVCDelegate?
    
    private var mediaItems: [(thumbnail: UIImage, url: URL, isVideo: Bool, isFavorite: Bool)] = []
    private var collectionView: UICollectionView!
    private var currentPlayerLayer: AVPlayerLayer?
    private var currentPlayer: AVPlayer?
    private var currentPlayingIndexPath: IndexPath?
    private var playbackWorkItem: DispatchWorkItem?

    @objc private func favoritesUpdated() {
        loadSavedMedia()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated), name: Notification.Name("FavoritesUpdated"), object: nil)
        view.backgroundColor = .white
        setupCollectionView()
        loadSavedMedia()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        stopCurrentVideo()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func loadSavedMedia() {
        mediaItems.removeAll()
        let files = try? FileManager.default.contentsOfDirectory(at: getFavoritesDirectory(), includingPropertiesForKeys: nil)
        
        files?.forEach { file in
            if file.pathExtension == "jpg", let image = UIImage(contentsOfFile: file.path) {
                if let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 200, height: 200)) {
                    mediaItems.append((thumbnail: resizedImage, url: file, isVideo: false, isFavorite: true))
                }
            } else if file.pathExtension == "mov" {
                let asset = AVAsset(url: file)
                let generator = AVAssetImageGenerator(asset: asset)
                if let cgImage = try? generator.copyCGImage(at: .zero, actualTime: nil) {
                    let thumbnail = UIImage(cgImage: cgImage)
                    if let resizedImage = resizeImage(image: thumbnail, targetSize: CGSize(width: 200, height: 200)) {
                        mediaItems.append((thumbnail: resizedImage, url: file, isVideo: true, isFavorite: true))
                    }
                }
            }
        }

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    private func getFavoritesDirectory() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let favoritesURL = documentsURL.appendingPathComponent("Favorites")
        if !FileManager.default.fileExists(atPath: favoritesURL.path) {
            try? FileManager.default.createDirectory(at: favoritesURL, withIntermediateDirectories: true)
        }
        return favoritesURL
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "FeedCell")
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        stopCurrentVideo()
        let viewerVC = ImageDetailVC(mediaItems: mediaItems, initialIndex: indexPath.item)
        delegate?.pushVC(at: viewerVC)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = mediaItems[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as! FeedCell
        cell.imageView.image = item.thumbnail
        cell.videoIcon.isHidden = !item.isVideo
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 40
        return CGSize(width: width, height: width * 1.5)
    }

    private func playVideo(at indexPath: IndexPath) {
        let item = mediaItems[indexPath.item]
        guard item.isVideo else { return }

        stopCurrentVideo()

        guard let cell = collectionView.cellForItem(at: indexPath) as? FeedCell else { return }

        currentPlayer = AVPlayer(url: item.url)
        currentPlayerLayer = AVPlayerLayer(player: currentPlayer)
        currentPlayerLayer?.frame = cell.playerView.bounds
        currentPlayerLayer?.videoGravity = .resizeAspectFill

        if let layer = currentPlayerLayer {
            cell.playerView.layer.addSublayer(layer)
        }

        currentPlayer?.play()
        currentPlayingIndexPath = indexPath
    }

    private func stopCurrentVideo() {
        currentPlayer?.pause()
        currentPlayer = nil
        currentPlayerLayer?.removeFromSuperlayer()
        currentPlayerLayer = nil
        currentPlayingIndexPath = nil
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        playbackWorkItem?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            let visibleCells = self.collectionView.visibleCells
            let collectionViewCenter = scrollView.bounds.midY

            for cell in visibleCells {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { continue }
                let item = self.mediaItems[indexPath.item]
                guard item.isVideo else { continue }

                let cellFrame = self.collectionView.layoutAttributesForItem(at: indexPath)?.frame ?? .zero
                let cellCenterY = cellFrame.midY
                let threshold: CGFloat = 0.5
                let distance = abs(collectionViewCenter - cellCenterY)
                let screenHeight = scrollView.bounds.height

                if distance < screenHeight * threshold, self.currentPlayingIndexPath != indexPath {
                    self.playVideo(at: indexPath)
                } else if distance > screenHeight * threshold, self.currentPlayingIndexPath == indexPath {
                    self.stopCurrentVideo()
                }
            }
        }

        playbackWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: workItem)
    }

    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Tính toán tỷ lệ sao cho ảnh không bị méo
        let scaleFactor = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)

        // Vẽ ảnh mới với kích thước đã thay đổi
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}

