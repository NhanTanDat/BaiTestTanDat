import UIKit
import AVKit

protocol FeedVCDelegate: AnyObject {
    func pushVC(at vc: UIViewController)
    func presentVC(at vc: UIViewController)
}

class FeedVC: BaseVC, UICollectionViewDataSource, UICollectionViewDelegate {
    
    weak var delegate: FeedVCDelegate?
    
    private var mediaItems: [(thumbnail: UIImage, url: URL, isVideo: Bool)] = []
    private var collectionView: UICollectionView!
    private var currentPlayerLayer: AVPlayerLayer?
    private var currentPlayer: AVPlayer?
    private var currentPlayingIndexPath: IndexPath?
    
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Dừng video khi chuyển ra khỏi màn hình
        stopCurrentVideo()
    }
    
    private func loadSavedMedia() {
        mediaItems.removeAll()  // Clear trước
        let files = try? FileManager.default.contentsOfDirectory(at: getFavoritesDirectory(), includingPropertiesForKeys: nil)

        files?.forEach { file in
            if file.pathExtension == "jpg", let image = UIImage(contentsOfFile: file.path) {
                mediaItems.append((thumbnail: image, url: file, isVideo: false))
            } else if file.pathExtension == "mov" {
                let asset = AVAsset(url: file)
                let generator = AVAssetImageGenerator(asset: asset)
                if let cgImage = try? generator.copyCGImage(at: .zero, actualTime: nil) {
                    let thumbnail = UIImage(cgImage: cgImage)
                    mediaItems.append((thumbnail: thumbnail, url: file, isVideo: true))
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
        layout.itemSize = CGSize(width: view.frame.width - 40, height: (view.frame.width - 40) * 0.75)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

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
        let item = mediaItems[indexPath.item]
        if item.isVideo {
            let player = AVPlayer(url: item.url)
            let vc = CustomPlayerVC()
            vc.player = player
            delegate?.presentVC(at: vc)
            player.play()
        } else {
            let vc = ImageDetailVC(image: item.thumbnail)
            delegate?.pushVC(at: vc) 
        }
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

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func playVideo(at indexPath: IndexPath) {
        let item = mediaItems[indexPath.item]
        guard item.isVideo else { return }

        stopCurrentVideo()

        let cell = collectionView.cellForItem(at: indexPath) as! FeedCell
        currentPlayer = AVPlayer(url: item.url)
        currentPlayerLayer = AVPlayerLayer(player: currentPlayer)
        currentPlayerLayer?.frame = cell.bounds
        currentPlayerLayer?.videoGravity = .resizeAspectFill
        cell.layer.addSublayer(currentPlayerLayer!)

        currentPlayer?.play()
        currentPlayingIndexPath = indexPath
    }

    private func stopCurrentVideo() {
        // Dừng video hiện tại nếu có
        currentPlayer?.pause()
        currentPlayerLayer?.removeFromSuperlayer()
        currentPlayer = nil
        currentPlayerLayer = nil
        currentPlayingIndexPath = nil
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCells = collectionView.visibleCells
        let collectionViewCenter = scrollView.bounds.midY

        for cell in visibleCells {
            guard let indexPath = collectionView.indexPath(for: cell) else { continue }
            let item = mediaItems[indexPath.item]

            if item.isVideo {
                
                let cellFrame = collectionView.layoutAttributesForItem(at: indexPath)?.frame ?? .zero
                let cellCenterY = cellFrame.midY
                let threshold: CGFloat = 0.5
                let distanceFromCenter = abs(collectionViewCenter - cellCenterY)
                let screenHeight = scrollView.bounds.height

                if distanceFromCenter < screenHeight * threshold && currentPlayingIndexPath != indexPath {
                    playVideo(at: indexPath)
                } else if distanceFromCenter > screenHeight * threshold && currentPlayingIndexPath == indexPath {
                    stopCurrentVideo()
                }
            }
        }
    }
}

