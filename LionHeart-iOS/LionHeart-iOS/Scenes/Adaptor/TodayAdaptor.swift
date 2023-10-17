//
//  TodayAdaptor.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/16.
//

import Foundation

final class TodayAdaptor: TodayNavigation {

    let coordinator: TodayCoordinator
    init(coordinator: TodayCoordinator) {
        self.coordinator = coordinator
    }
    
    func todayArticleTapped(articleID: Int) {
        self.coordinator.showArticleDetaileViewController(articleID: articleID)
    }
    
    func checkTokenIsExpired() {
        self.coordinator.exitApplication()
    }
    
    func navigationRightButtonTapped() {
        self.coordinator.showMypageViewController()
    }
    
    func navigationLeftButtonTapped() {
        self.coordinator.showBookmarkViewController()
    }
}
