
import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let feedVC = FeedVC()
        feedVC.delegate = self
        feedVC.tabBarItem = UITabBarItem(title: "Yêu thích", image: UIImage(systemName: "heart.fill"), tag: 0)

        let homeVC = HomeVC()
        homeVC.delegate = self
        homeVC.tabBarItem = UITabBarItem(title: "Album", image: UIImage(systemName: "photo.on.rectangle"), tag: 1)

        let feedNav = UINavigationController(rootViewController: feedVC)
        let homeNav = UINavigationController(rootViewController: homeVC)

        viewControllers = [feedNav, homeNav]
        
        tabBar.tintColor = .systemBlue
        tabBar.barTintColor = .white 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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

