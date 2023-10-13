//
//  ChallengeCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class ChallengeCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showChallengeViewController()
        print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
    }
    
    func showChallengeViewController() {
        let challengeViewController = ChallengeViewController(manager: ChallengeManagerImpl(challengeService: ChallengeServiceImpl(apiService: APIService())))
        challengeViewController.coordinator = self
        navigationController.pushViewController(challengeViewController, animated: true)
    }
    
    
}

extension ChallengeCoordinator: ChallengeNavigation {
    func navigationRightButtonTapped() {
        let mypageCoordinator = MypageCoordinator(navigationController: navigationController)
        mypageCoordinator.start()
        children.append(mypageCoordinator)
        print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
    }
    
    func navigationLeftButtonTapped() {
        let bookmarkCoordinator = BookmarkCoordinator(navigationController: navigationController)
        bookmarkCoordinator.start()
        children.append(bookmarkCoordinator)
        print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
    }
    
    
}
