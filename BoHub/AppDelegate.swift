//
//  AppDelegate.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let serviceProvider: ServiceProviderType = ServiceProvider()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        // we can use a router in here
        let userPage = UserListViewController(
            userListViewType: UserListViewPresenter(),
            userListViewModel: UserListViewModel(serviceProvider: serviceProvider)
        )
        let root = UINavigationController(rootViewController: userPage)
        self.window?.rootViewController = root
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

