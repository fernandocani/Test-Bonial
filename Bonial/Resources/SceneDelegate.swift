//
//  SceneDelegate.swift
//  Bonial
//
//  Created by Fernando Cani on 08/07/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let service = ServiceMock.shared
        let newsViewModel = NewsViewModel(service)
        let newsViewController = NewsViewController(viewModel: newsViewModel)
        let navigationController = UINavigationController(rootViewController: newsViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
    
}
