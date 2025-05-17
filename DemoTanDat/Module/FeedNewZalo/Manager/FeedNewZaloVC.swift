import UIKit

class FeedNewZaloVC: BaseVC {

    let headerView = HeaderResearchView()
    let tableView = UITableView()
    
    var isExpandedStates: [Bool] = []

    var posts: [PostModel] = [
        PostModel(
            avatar: UIImage(named: "a1") ?? UIImage(systemName: "person.circle")!,
            username: "Nguyễn Thảo Nhi",
            time: "27 minutes ago",
            text: "Kế hoạch sáp nhập Bà Rịa - Vũng Tàu và Bình Dương...Kế hoạch sáp nhập Bà Rịa - Vũng Tàu và Bình Dương...Kế hoạch sáp nhập Bà Rịa - Vũng Tàu và Bình Dương...Kế hoạch sáp nhập Bà Rịa - Vũng Tàu và Bình Dương...Kế hoạch sáp nhập Bà Rịa - Vũng Tàu và Bình Dương...",
            image: UIImage(named: "anh") ?? UIImage(systemName: "photo")!,
            linkTitle: "m.cafebiz.vn",
            linkSubtitle: "Về 'chung nhà' với TP.HCM, thị trường bất động sản hai địa phương này tăng gần 50%"
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        setupHeader()
        setupTableView()
        
        isExpandedStates = Array(repeating: false, count: posts.count)

        tableView.register(UserPostActionCell.self, forCellReuseIdentifier: UserPostActionCell.identifier)
        tableView.register(SnapshotCell.self, forCellReuseIdentifier: SnapshotCell.identifier)
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
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
        tableView.showsHorizontalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.bounces = true
        tableView.alwaysBounceVertical = true
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90)
        ])

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

// MARK: - UITableView Delegate & DataSource

extension FeedNewZaloVC: UITableViewDelegate, UITableViewDataSource, PostCellDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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

            let femaleNames = [
                "Nguyễn Thảo Nhi", "Nguyễn Thảo My", "Nguyễn Thu Thảo",
                "Vũ Bảo Hân", "Lý Thị Hồng Nhung", "Nguyễn Thị Trúc Mai",
                "Lê Hồng Nhung", "Đinh Thị Mỹ Hạnh"
            ]

            let femaleAvatars = [
                UIImage(named: "a1")!,
                UIImage(named: "a2")!,
                UIImage(named: "a3")!,
                UIImage(named: "a4")!
            ]
            
            let femaleIMG = [
                UIImage(named: "img1")!,
                UIImage(named: "img2")!,
                UIImage(named: "img3")!,
                UIImage(named: "img4")!
            ]

            var snapshotData = [SnapshotItem]()
            for i in 0..<femaleAvatars.count {
                snapshotData.append(SnapshotItem(image: femaleIMG[i], avatar: femaleAvatars[i], name: femaleNames[i]))
            }

            cell.configure(with: snapshotData)
            return cell

        } else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
                return UITableViewCell()
            }

            cell.delegate = self
            cell.configure(with: posts[0])
            return cell
        }
    }

    func didUpdateCell(_ cell: PostCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            self.posts[indexPath.row - 2].isExpandedStates.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

