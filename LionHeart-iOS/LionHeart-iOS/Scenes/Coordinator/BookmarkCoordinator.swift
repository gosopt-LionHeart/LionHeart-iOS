//
//  BookmarkCoordinator.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/13.
//

import UIKit

final class BookmarkCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    private let factory: BookmarkFactory
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, factory: BookmarkFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        showBookmarkViewController()
    }
    
    func showBookmarkViewController() {
        let bookmarkViewController = factory.makeBookmarkViewController()
        bookmarkViewController.coordinator = self
        self.navigationController.pushViewController(bookmarkViewController, animated: true)
    }
}

extension BookmarkCoordinator: BookmarkNavigation {
    func bookmarkCellTapped(articleID: Int) {
        let articleCoordinator = ArticleCoordinator(navigationController: navigationController, articleId: articleID)
        articleCoordinator.start()
        children.append(articleCoordinator)
    }
    
    func backButtonTapped() {
        self.navigationController.popViewController(animated: true)
        self.parentCoordinator?.childDidFinish(self)
    }
}
