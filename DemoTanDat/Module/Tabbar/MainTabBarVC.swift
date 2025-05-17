import UIKit

protocol MainTabBarCoordinatorDelegate: AnyObject {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}


class MainTabBarVC: BaseVC, MainTabBarCoordinatorDelegate {

    private let contactsVC = ContactListVC()
    private let timelineVC = FeedNewZaloVC()
    private let meVC = HomeVC()

    private var currentVC: UIViewController?

    private let contactsTab = CustomTabView(title: "Contacts", image: UIImage(systemName: "person"))
    private let timelineTab = CustomTabView(title: "Newfeed", image: UIImage(systemName: "clock"))
    private let meTab = CustomTabView(title: "Me", image: UIImage(systemName: "person.crop.circle"))

    private let tabBarView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gán delegate
        contactsVC.delegate = self
       
        setupTabBar()
        switchTo(viewController: timelineVC)
        updateTabColors(active: timelineTab)

        contactsTab.setBadge(text: "")
        timelineTab.setBadge(text: "5+")
        meTab.setBadge(text: "!")
    }

    private func setupTabBar() {
        tabBarView.backgroundColor = .white
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.layer.shadowColor = UIColor.black.cgColor
        tabBarView.layer.shadowOpacity = 0.1
        tabBarView.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBarView.layer.shadowRadius = 8
        view.addSubview(tabBarView)

        NSLayoutConstraint.activate([
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: 90)
        ])

        contactsTab.tapAction = { [weak self] in self?.selectTab(vc: self!.contactsVC, tab: self!.contactsTab) }
        timelineTab.tapAction = { [weak self] in self?.selectTab(vc: self!.timelineVC, tab: self!.timelineTab) }
        meTab.tapAction = { [weak self] in self?.selectTab(vc: self!.meVC, tab: self!.meTab) }

        let stackView = UIStackView(arrangedSubviews: [timelineTab, contactsTab, meTab])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: tabBarView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: tabBarView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: tabBarView.bottomAnchor)
        ])
    }

    private func selectTab(vc: UIViewController, tab: CustomTabView) {
        switchTo(viewController: vc)
        updateTabColors(active: tab)
    }

    private func updateTabColors(active: CustomTabView) {
        [contactsTab, timelineTab, meTab].forEach {
            $0.setActive($0 == active)
        }
    }

    private func switchTo(viewController: UIViewController) {
        currentVC?.willMove(toParent: nil)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()

        addChild(viewController)
        view.insertSubview(viewController.view, belowSubview: tabBarView)
        viewController.view.frame = view.bounds
        viewController.didMove(toParent: self)
        currentVC = viewController
    }

    // MARK: - Delegate Push
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
}

