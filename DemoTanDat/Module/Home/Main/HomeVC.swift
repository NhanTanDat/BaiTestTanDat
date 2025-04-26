import UIKit
import PhotosUI

class HomeVC: UIViewController, UICollectionViewDataSource {

    private var selectedImages: [UIImage] = []
    private var savedFileNames: [String] = []
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupChooseButton()
        loadImagesFromCache()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.imageView.image = selectedImages[indexPath.item]

        // Add long press gesture recognizer
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        cell.addGestureRecognizer(longPressGesture)
        cell.isUserInteractionEnabled = true

        return cell
    }

    private func setupChooseButton() {
        let button = UIButton(type: .system)
        button.setTitle("Chọn ảnh", for: .normal)
        button.addTarget(self, action: #selector(openPhotoPicker), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func openPhotoPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 0 // No selection limit
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func saveImageToCache(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let fileName = UUID().uuidString + ".jpg"
        let url = getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            try data.write(to: url)
            savedFileNames.append(fileName)
        } catch {
            print("❌ Error saving image: \(error)")
        }
    }

    private func loadImagesFromCache() {
        let fileManager = FileManager.default
        let documentsDirectory = getDocumentsDirectory()
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            
            for fileURL in fileURLs where fileURL.pathExtension == "jpg" {
                if let image = UIImage(contentsOfFile: fileURL.path) {
                    selectedImages.append(image)
                    savedFileNames.append(fileURL.lastPathComponent)
                }
            }
        } catch {
            print("❌ Error loading images: \(error)")
        }
    }

    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    @objc private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard gestureRecognizer.state == .began else { return }
        
        guard let cell = gestureRecognizer.view as? ImageCell,
              let indexPath = collectionView.indexPath(for: cell) else { return }

        let fileName = savedFileNames[indexPath.item]

        // Create an action sheet to show options
        let alertController = UIAlertController(title: "Image Options", message: nil, preferredStyle: .actionSheet)

        // Delete option
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.selectedImages.remove(at: indexPath.item)
            self.savedFileNames.remove(at: indexPath.item)

            self.collectionView.deleteItems(at: [indexPath])
            self.deleteImageFromCache(fileName: fileName)
           
        }))

        // Save to Favorites option
        alertController.addAction(UIAlertAction(title: "Save to Favorites", style: .default, handler: { _ in
            print("Image saved to favorites")
        }))

        // Cancel option
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alertController, animated: true, completion: nil)
    }

    private func deleteImageFromCache(fileName: String) {
        let fileManager = FileManager.default
        let documentsDirectory = getDocumentsDirectory()
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        do {
            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            print("❌ Error deleting image: \(error)")
        }
    }


  
}

extension HomeVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        for result in results {
            guard let assetId = result.assetIdentifier else { continue }

           

            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            self.selectedImages.append(image)
                            self.collectionView.reloadData()
                            self.saveImageToCache(image: image) // Save the image to cache
                        }
                    }
                }
            }
        }
    }
}

