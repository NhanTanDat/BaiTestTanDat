//
//  FeedNewZaloVC.swift
//  DemoTanDat
//
//  Created by Đại Lợi Đẹp Trai on 15/5/25.
//
import UIKit

class FeedNewZaloVC: BaseVC {

    let headerView = HeaderResearchView()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        setupHeader()
        setupTableView()
        tableView.register(UserPostActionCell.self, forCellReuseIdentifier: UserPostActionCell.identifier)
        tableView.register(SnapshotCell.self, forCellReuseIdentifier: SnapshotCell.identifier)
        
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
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

// MARK: - UITableView Delegate & DataSource

extension FeedNewZaloVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // cell đầu tiên: UserPostActionCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserPostActionCell.identifier, for: indexPath) as? UserPostActionCell else {
                return UITableViewCell()
            }
            return cell
        } else {
            // cell Snapshot
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SnapshotCell.identifier, for: indexPath) as? SnapshotCell else {
                return UITableViewCell()
            }

            // Demo data
            let items = (1...4).map { i in
                SnapshotItem(
                    image: UIImage(named: "img\(i)") ?? UIImage(systemName: "photo")!,
                    avatar: UIImage(systemName: "person.circle.fill")!,
                    name: "User \(i)"
                )
            }
            cell.configure(with: items)
            return cell
        }
    }


}
