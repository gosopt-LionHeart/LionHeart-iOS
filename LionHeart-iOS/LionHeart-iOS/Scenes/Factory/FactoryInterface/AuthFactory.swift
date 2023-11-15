//
//  AuthFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/10/15.
//

import Foundation

protocol AuthFactory {
    
    func makeLoginViewModel(coordinator: AuthCoordinator) -> any LoginViewModel & LoginViewModelPresentable
    func makeOnboardingViewModel(coordinator: AuthCoordinator) -> any OnboardingViewModel & OnboardingViewModelPresentable
    func makeAuthAdaptor(coordinator: AuthCoordinator) -> EntireAuthNaviation
    
    func makeLoginViewController(coordinator: AuthCoordinator) -> LoginViewControllerable
    
    func makeCompleteOnbardingViewController(coordinator: AuthCoordinator) -> CompleteOnbardingViewControllerable
    func makeOnboardingViewController(token: String?, coordinator: AuthCoordinator) -> OnboardingViewControllerable
}


