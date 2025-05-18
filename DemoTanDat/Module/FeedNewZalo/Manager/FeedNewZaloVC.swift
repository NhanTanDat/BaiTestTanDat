import UIKit
import Lightbox
import GSPlayer

class FeedNewZaloVC: UIViewController {

    let headerView = HeaderResearchView()
    let tableView = UITableView()
    private let spinnerFooter = UIActivityIndicatorView(style: .medium)

    let viewModel = FeedNewZaloVM()
    var isLoadingMore = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue

        setupHeader()
        setupTableView()

        tableView.register(UserPostActionCell.self, forCellReuseIdentifier: UserPostActionCell.identifier)
        tableView.register(SnapshotCell.self, forCellReuseIdentifier: SnapshotCell.identifier)
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)

        headerView.delegate = self
    }

    func setupHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.bounces = true
        tableView.alwaysBounceVertical = true

        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

        spinnerFooter.hidesWhenStopped = true
        spinnerFooter.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50)
        tableView.tableFooterView = spinnerFooter

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90)
        ])
    }

    private func loadMorePostsIfNeeded() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        spinnerFooter.startAnimating()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel.loadMorePosts() // append thêm data
            self.tableView.reloadData()
            self.spinnerFooter.stopAnimating()
            self.isLoadingMore = false
        }
    }
}

extension FeedNewZaloVC: HeaderResearchViewDelegate {
    func headerResearchView(_ headerView: HeaderResearchView, didChangeSearchText text: String) {
        print("Từ khóa tìm kiếm: \(text)")
        viewModel.filterPosts(with: text)
        tableView.reloadData()
    }
}

extension FeedNewZaloVC: UITableViewDelegate, UITableViewDataSource, PostCellDelegate,SnapshotCellDelegate {
    
    func snapshotCell(_ cell: SnapshotCell, didTapItemAt index: Int, image: UIImage) {
        let lightboxImages = [LightboxImage(image: image)]
        let controller = LightboxController(images: lightboxImages, startIndex: 0)
        controller.dynamicBackground = true
        present(controller, animated: true)
    }
    
    func didTapImage(at index: Int, in cell: PostCell, images: [UIImage]) {
        let lightboxImages = images.map { LightboxImage(image: $0) }
        let controller = LightboxController(images: lightboxImages, startIndex: index)
        controller.dynamicBackground = true
        present(controller, animated: true, completion: nil)
    }
    
    func didTapVideo(in cell: PostCell,  url: String) {
        guard let path = Bundle.main.path(forResource: url, ofType: "mp4") else {
            print("Không tìm thấy file video.")
            return
        }

        let videoURL = URL(fileURLWithPath: path)
        let vc = VideoPlayerVC()
        vc.videoURL = videoURL
        navigationController?.pushViewController(vc, animated: true)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserPostActionCell.identifier, for: indexPath) as? UserPostActionCell else {
                return UITableViewCell()
            }
            return cell

        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SnapshotCell.identifier, for: indexPath) as? SnapshotCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel.snapshotItems())
            cell.delegate = self
            return cell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
                return UITableViewCell()
            }

            if let post = viewModel.post(at: indexPath.row) {
                cell.delegate = self
                cell.configure(with: post)
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let postCell = cell as? PostCell {
            postCell.player?.seek(to: .zero, completionHandler: { finished in
                if finished {
                    postCell.player?.play()
                }
            })
        }
        if indexPath.row == viewModel.numberOfRows() - 1 {
            loadMorePostsIfNeeded()
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let postCell = cell as? PostCell {
            postCell.pauseVideo()
        }
    }

    func didUpdateCell(_ cell: PostCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.toggleExpandState(at: indexPath.row)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension FeedNewZaloVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }

        view.endEditing(true)
        pauseAllVisibleVideos()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            playVisibleVideos()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        playVisibleVideos()
    }

    private func pauseAllVisibleVideos() {
        for cell in tableView.visibleCells {
            if let postCell = cell as? PostCell {
                postCell.pauseVideo()
            }
        }
    }

    private func playVisibleVideos() {
        for cell in tableView.visibleCells {
            if let postCell = cell as? PostCell {
                postCell.player?.seek(to: .zero, completionHandler: { finished in
                    if finished {
                        postCell.player?.play()
                    }
                })
            }
        }
    }
}
