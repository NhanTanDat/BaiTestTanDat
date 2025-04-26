//
//  AppDelegate.swift
//  DemoTanDat
//
//  Created by Đại Lợi Đẹp Trai on 24/4/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
               
        let homeVC = MainTabBarVC()
        let navController = UINavigationController(rootViewController: homeVC)
               
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
               
        return true
    }

}

