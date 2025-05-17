import UIKit


class ContactListVC: UIViewController {
    
    weak var delegate: MainTabBarCoordinatorDelegate?

    let headerView = HeaderResearchView()
    private let tableView = UITableView()
    private var contacts: [(name: String, avatar: UIImage)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Danh bạ"
        view.backgroundColor = .systemBlue

        setupHeaderView()
        setupTableView()
        loadContacts()
    }

    private func setupHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.setRightIconsHidden(true)
        view.addSubview(headerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorStyle = .none
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
    }

    private func loadContacts() {
        contacts = [
            ("Nguyễn Thảo Nhi", UIImage(named: "a1") ?? UIImage(systemName: "person.circle")!),
            ("Lê Hồng Nhung", UIImage(named: "a2") ?? UIImage(systemName: "person.circle")!),
            ("Phạm Bảo Hân", UIImage(named: "a3") ?? UIImage(systemName: "person.circle")!),
            ("Đoàn Mỹ Linh", UIImage(named: "a4") ?? UIImage(systemName: "person.circle")!)
        ]
        tableView.reloadData()
    }
}

extension ContactListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath) as? ContactCell else {
            return UITableViewCell()
        }
        
        cell.didTapButton = { [weak self] name in
            self?.handleCellButtonTap(username: name)
        }

        let contact = contacts[indexPath.row]
        cell.configure(with: contact.name, avatar: contact.avatar)

        cell.phoneButton.tag = indexPath.row
        cell.phoneButton.addTarget(self, action: #selector(phoneButtonTapped(_:)), for: .touchUpInside)

        cell.videoButton.tag = indexPath.row
        cell.videoButton.addTarget(self, action: #selector(videoButtonTapped(_:)), for: .touchUpInside)

        return cell
    }
    
    private func handleCellButtonTap(username: String) {
        let userPostsVC = UserPostsVC(username: username)
        self.delegate?.pushViewController(userPostsVC, animated: false)
    }
    
    @objc private func phoneButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let contact = contacts[index]
        print("Gọi điện cho: \(contact.name)")
    }

    @objc private func videoButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let contact = contacts[index]
        print("Gọi video cho: \(contact.name)")
    }

}

