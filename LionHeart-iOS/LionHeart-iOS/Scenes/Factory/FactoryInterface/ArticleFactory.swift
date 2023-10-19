//
//  ArticleFactory.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 10/15/23.
//

import Foundation

protocol ArticleFactory {
    func makeArticleDetailViewController(adaptor: ArticleDetailModalNavigation) -> ArticleControllerable
}
