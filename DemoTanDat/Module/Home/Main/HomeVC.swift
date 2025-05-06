import UIKit
import PhotosUI
import AVKit
import UniformTypeIdentifiers


protocol HomeVCDelegate: AnyObject {
    func pushVC(at vc: UIViewController)
    func presentVC(at vc: UIViewController)
}

class HomeVC: BaseVC, UICollectionViewDataSource, UICollectionViewDelegate {
    
    weak var delegate: HomeVCDelegate?
    
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupChooseButton()
        AlbumManager.shared.loadMedia()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupChooseButton() {
        let button = UIButton(type: .system)
        button.setTitle("Chọn ảnh / video", for: .normal)
        button.addTarget(self, action: #selector(openPicker), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AlbumManager.shared.mediaItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = AlbumManager.shared.mediaItems[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.indexPath = indexPath
        cell.delegate = self
        cell.imageView.image = item.thumbnail
        cell.setVideoIconVisible(item.isVideo)
        cell.setFavoriteVisible(item.isFavorite)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewerVC = ImageDetailVC(mediaItems: AlbumManager.shared.mediaItems, initialIndex: indexPath.item)
        delegate?.pushVC(at: viewerVC)
    }
    

    @objc private func openPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0
        config.filter = .any(of: [.images, .videos])
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension HomeVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        for result in results {
            let itemProvider = result.itemProvider

            if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    guard let image = object as? UIImage else { return }
                    if let savedUrl = AlbumManager.shared.saveImageToDisk(image) {
                        DispatchQueue.main.async {
                            AlbumManager.shared.mediaItems.append((thumbnail: image, url: savedUrl, isVideo: false, isFavorite: false))
                            self.collectionView.reloadData()
                        }
                    }
                }
            }

            if itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                    guard let url = url else { return }
                    if let savedUrl = AlbumManager.shared.saveVideoToDisk(url) {
                        // Tạo thumbnail từ video sau khi lưu
                        let asset = AVAsset(url: savedUrl)
                        let generator = AVAssetImageGenerator(asset: asset)
                        if let cgImage = try? generator.copyCGImage(at: .zero, actualTime: nil) {
                            let thumbnail = UIImage(cgImage: cgImage)
                            DispatchQueue.main.async {
                                // Lưu URL video thay vì video trực tiếp
                                AlbumManager.shared.mediaItems.append((thumbnail: thumbnail, url: savedUrl, isVideo: true, isFavorite: false))
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension HomeVC: ImageCellDelegate {
    func didLongPress(at indexPath: IndexPath) {
        
        guard AlbumManager.shared.mediaItems.indices.contains(indexPath.item) else {
                print("Index \(indexPath.item) is out of range.")
                return
        }

        let item = AlbumManager.shared.mediaItems[indexPath.item]

        let alert = UIAlertController(title: "Tùy chọn", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Xoá", style: .destructive, handler: { _ in
                   self.collectionView.performBatchUpdates({
                       AlbumManager.shared.deleteItem(at: indexPath.item)
                       self.collectionView.deleteItems(at: [indexPath])
                   }, completion: { finished in
                       self.collectionView.reloadData()
                   })
               }))

        if item.isFavorite {
            alert.addAction(UIAlertAction(title: "Loại bỏ khỏi yêu thích", style: .default, handler: { _ in
                AlbumManager.shared.removeFromFavorites(item: item)
                self.collectionView.reloadItems(at: [indexPath])
            }))
        } else {
            alert.addAction(UIAlertAction(title: "Yêu thích", style: .default, handler: { _ in
                AlbumManager.shared.addToFavorites(item: item)
                self.collectionView.reloadItems(at: [indexPath])
            }))
        }

        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel))

        present(alert, animated: true)
    }
}
