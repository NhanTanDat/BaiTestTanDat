import UIKit

class MainTabBarVC: UIViewController {

    private let memoryVC = FeedNewZaloVC()
    private let favoriteVC = FeedVC()
    private let homeVC = HomeVC()

    private var currentVC: UIViewController?

    private let memoryTab = CustomTabView(title: "Memory", image: UIImage(systemName: "clock"))
    private let favoriteTab = CustomTabView(title: "Yêu thích", image: UIImage(systemName: "heart.fill"))
    private let homeTab = CustomTabView(title: "Album", image: UIImage(systemName: "photo.on.rectangle"))

    private let tabBarView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // ...
        setupTabBar()
        switchTo(viewController: memoryVC)
        updateTabColors(active: memoryTab)

        // Ví dụ set badge:
        memoryTab.setBadge(count: 5)
        favoriteTab.setBadge(count: 0)  // ẩn badge
        homeTab.setBadge(count: 10)
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

        memoryTab.tapAction = { [weak self] in
            self?.switchTo(viewController: self!.memoryVC)
            self?.updateTabColors(active: self!.memoryTab)
        }

        favoriteTab.tapAction = { [weak self] in
            self?.switchTo(viewController: self!.favoriteVC)
            self?.updateTabColors(active: self!.favoriteTab)
        }

        homeTab.tapAction = { [weak self] in
            self?.switchTo(viewController: self!.homeVC)
            self?.updateTabColors(active: self!.homeTab)
        }

        let stackView = UIStackView(arrangedSubviews: [memoryTab, favoriteTab, homeTab])
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

    private func updateTabColors(active: CustomTabView) {
        [memoryTab, favoriteTab, homeTab].forEach { $0.setActive($0 == active) }
    }

    private func switchTo(viewController: UIViewController) {
        if let current = currentVC {
            current.willMove(toParent: nil)
            current.view.removeFromSuperview()
            current.removeFromParent()
        }

        addChild(viewController)
        view.insertSubview(viewController.view, belowSubview: tabBarView)
        viewController.view.frame = view.bounds
        viewController.didMove(toParent: self)
        currentVC = viewController

        view.bringSubviewToFront(tabBarView)
    }
}



extension MainTabBarVC: FeedVCDelegate,HomeVCDelegate {
    func presentVC(at vc: UIViewController) {
        self.present(vc, animated: true, completion: nil)
    }

    func pushVC(at vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

