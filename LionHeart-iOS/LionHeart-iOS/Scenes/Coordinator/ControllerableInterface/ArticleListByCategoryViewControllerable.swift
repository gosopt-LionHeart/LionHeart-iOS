//
//  ArticleListByCategoryViewControllerable.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/17.
//

import UIKit

protocol ArticleListByCategoryViewControllerable where Self: UIViewController {
    var navigator: ArticleListByCategoryNavigation { get set }
    var categoryString: String? { get set }
}
