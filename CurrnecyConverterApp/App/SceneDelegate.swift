//
//  SceneDelegate.swift
//  CurrnecyConverterApp
//
//  Created by nika razmadze on 22.01.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        
        let navigation = UINavigationController(rootViewController: tabBarController())
        navigation.navigationBar.barTintColor = .background
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    //MARK: - TabbarController
    func tabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let currenciesListViewController = CurrenciesListViewController()
        let currenciesNavigationController = UINavigationController(rootViewController: currenciesListViewController)
        currenciesNavigationController.tabBarItem.image = UIImage(systemName: "list.bullet.below.rectangle")
        currenciesNavigationController.tabBarItem.title = "Currencies"
        currenciesNavigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)
        ]
        
        let cryptoListViewController = CryptoListViewController()
        let cryptoNavigationController = UINavigationController(rootViewController: cryptoListViewController)
        cryptoNavigationController.tabBarItem.image = UIImage(systemName: "bitcoinsign")
        cryptoNavigationController.tabBarItem.title = "Crypto"
        cryptoNavigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)
        ]
        
        let CurrencyChartViewController = CurrencyChartViewController()
        CurrencyChartViewController.tabBarItem.image = UIImage(systemName: "chart.bar")
        CurrencyChartViewController.tabBarItem.title = "Chart"
        
        let CurrencyConverterViewController = CurrencyConverterViewController()
        CurrencyConverterViewController.tabBarItem.image = UIImage(systemName: "larisign.arrow.circlepath")
        CurrencyConverterViewController.tabBarItem.title = "Converter"
        
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .gray
        UITabBar.appearance().barTintColor = .background
        
        tabBarController.setViewControllers([currenciesNavigationController, cryptoNavigationController, CurrencyChartViewController, CurrencyConverterViewController], animated: true)
        
        return tabBarController
    }
    
}

