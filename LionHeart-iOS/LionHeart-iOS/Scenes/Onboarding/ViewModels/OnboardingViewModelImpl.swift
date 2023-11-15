//
//  OnboardingViewModelImpl.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/15.
//

import Foundation
import Combine

final class OnboardingViewModelImpl: OnboardingViewModel, OnboardingViewModelPresentable {
    
    private var navigator: OnboardingNavigation
    private let manager: OnboardingManager
    private var kakaoAccessToken: String?
    private let signUpSubject = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    private var currentPage: OnboardingPageType = .getPregnancy
    private var onboardingFlow: OnbardingFlowType = .toGetPregnacny
    
    init(navigator: OnboardingNavigation, manager: OnboardingManager) {
        self.navigator = navigator
        self.manager = manager
    }
    
    func transform(input: OnboardingViewModelInput) -> OnboardingViewModelOutput {
        let fetalButtonState = input.fetalNickname
            .map { $0.isValid }
            .eraseToAnyPublisher()
        
        let pregenacyButtonState = input.pregenacy
            .map { $0.isValid }
            .eraseToAnyPublisher()
        
        let onboardingFlow = input.nextButtonTapped
            .map { _ in
                if self.onboardingFlow == .toFetalNickname {
                    self.signUpSubject.send(())
                }
                self.onboardingFlow = OnbardingFlowType.toFetalNickname
                return self.onboardingFlow
            }
            .eraseToAnyPublisher()
        
        let signUpSubject = signUpSubject
            .flatMap { _ -> AnyPublisher<String, Never> in
                return Future<String, NetworkError> { promise  in
                    Task {
                        do {
                            let passingData = UserOnboardingModel(kakaoAccessToken: self.kakaoAccessToken, pregnacny: input.pregenacy.value.pregnancy, fetalNickname: input.fetalNickname.value.fetalNickname)
                            try await self.manager.signUp(type: .kakao, onboardingModel: passingData)
                            DispatchQueue.main.async {
                                self.navigator.onboardingCompleted(data: passingData)
                            }
                        } catch {
                            promise(.failure(error as! NetworkError))
                        }
                    }
                }
                .catch { error in
                    Just(error.description)
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        input.backButtonTapped
            .sink { [weak self] in
                self?.navigator.backButtonTapped()
            }
            .store(in: &cancelBag)
        
        return OnboardingViewModelOutput(pregenacyButtonState: pregenacyButtonState, fetalButtonState: fetalButtonState, onboardingFlow: onboardingFlow, signUpSubject: signUpSubject)
    }

    
    func setKakaoAccessToken(_ token: String?) {
        self.kakaoAccessToken = token
    }
}
