//
//  SplashCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class SplashCoordinatorImpl: SplashCoordinator {
    
    weak var parentCoordinator: Coordinator?
    private let factory: SplashFactory
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, factory: SplashFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        showSplashViewController()
    }
    
    func showSplashViewController() {
        let splashAdaptor = SplashAdaptor(coordinator: self)
        let splashViewController = factory.makeSplashViewController(adaptor: splashAdaptor)
        self.navigationController.pushViewController(splashViewController, animated: false)
    }
    
    func showTabbarViewContoller() {
        let tabbarCoordinator = TabbarCoordinator(navigationController: navigationController)
        children.removeAll()
        tabbarCoordinator.parentCoordinator = self
        tabbarCoordinator.start()
    }
    
    func showLoginViewController() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController, factory: AuthFactoryImpl())
        children.removeAll()
        authCoordinator.parentCoordinator = self
        children.append(authCoordinator)
        authCoordinator.start()
    }
}
