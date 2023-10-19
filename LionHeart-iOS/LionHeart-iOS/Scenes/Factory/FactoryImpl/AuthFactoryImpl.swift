//
//  AuthFactoryImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/10/15.
//

import UIKit

struct AuthFactoryImpl: AuthFactory {
    func makeAuthAdaptor(coordinator: AuthCoordinator) -> EntireAuthNaviation {
        return AuthAdaptor(coordinator: coordinator)
    }
    
    func makeLoginViewController(coordinator: AuthCoordinator) -> LoginViewControllerable {
        let loginViewController = LoginViewController(manager: LoginMangerImpl(authService: AuthServiceImpl(apiService: APIService())), navigator: self.makeAuthAdaptor(coordinator: coordinator))
        return loginViewController
    }
    
    func makeCompleteOnbardingViewController(coordinator: AuthCoordinator) -> CompleteOnbardingViewControllerable {
        let completeViewController = CompleteOnbardingViewController(navigator: self.makeAuthAdaptor(coordinator: coordinator))
        return completeViewController
    }
    
    func makeOnboardingViewController(coordinator: AuthCoordinator) -> OnboardingViewControllerable {
        let onboardingViewController = OnboardingViewController(manager: OnboardingManagerImpl(authService: AuthServiceImpl(apiService: APIService())), navigator: self.makeAuthAdaptor(coordinator: coordinator))
        return onboardingViewController
    }
    

}
