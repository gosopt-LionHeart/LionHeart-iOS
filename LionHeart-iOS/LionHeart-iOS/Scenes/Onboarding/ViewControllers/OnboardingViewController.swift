//
//  OnboardingViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Onboarding. All rights reserved.
//

import UIKit

import SnapKit

final class OnboardingViewController: UIViewController, OnboardingViewControllerable  {
    typealias OnboardingViews = [UIViewController]
    
    var navigator: OnboardingNavigation
    private let manager: OnboardingManager
    
    private var fetalNickName: String?
    private var pregnancy: Int?
    private var kakaoAccessToken: String?
    
    private let nextButton = LHOnboardingButton()
    private let onboardingProgressView = LHProgressView()
    private let onboardingViewController = LHOnboardingPageViewController()
    private var pageDataSource: OnboardingViews = []
    private lazy var onboardingNavigationbar = LHNavigationBarView(type: .onboarding, viewController: self)
    
    private var currentPage: OnboardingPageType = .getPregnancy
    private var onboardingFlow: OnbardingFlowType = .toGetPregnacny {
        didSet {
            switch onboardingFlow {
            case .toGetPregnacny, .toFetalNickname:
                presentOnboardingView(oldValue: onboardingFlow)
            case .toCompleteOnboarding:
                presentCompleteOnboardingView()
            }
        }
    }
    
    private var onboardingCompletePercentage: Float = 0 {
        didSet {
            fillProgressView(from: onboardingCompletePercentage)
        }
    }

    init(manager: OnboardingManager, navigator: OnboardingNavigation) {
        self.manager = manager
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setChildViewController()
        setNavigationBar()
        setPageViewController()
        setProgressView()
        setHierarchy()
        setLayout()
        setAddTarget()
    }
    
    func setKakaoAccessToken(_ token: String?) {
        self.kakaoAccessToken = token
    }
}

private extension OnboardingViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func setHierarchy() {
        addChild(onboardingViewController)
        view.addSubviews(onboardingViewController.view, onboardingNavigationbar, onboardingProgressView, nextButton)
    }
    
    func setPageViewController() {
        if let initalViewController = pageDataSource.first {
            onboardingViewController.setViewControllers([initalViewController], direction: .forward, animated: true)
        }
        onboardingViewController.didMove(toParent: self)
    }
    
    func setLayout() {
        onboardingViewController.view.snp.makeConstraints { make in
            make.top.equalTo(self.onboardingNavigationbar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        onboardingNavigationbar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        onboardingProgressView.snp.makeConstraints { make in
            make.top.equalTo(self.onboardingNavigationbar.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func setAddTarget() {
        nextButton.addButtonAction { _ in
            guard let fetalNickName = self.fetalNickName else {
                self.nextOnboardingProcessWithNonActiveButtonState()
                return
            }
            self.nextOnboaringProcess(nickName: fetalNickName, minCount: 1, maxCount: 10)
        }
    
        onboardingNavigationbar.backButtonAction {
            if self.currentPage == .getPregnancy {
                self.navigator.backButtonTapped()
            } else  {
                self.backOnboardingProcess()
            }
        }
    }
    
    func setChildViewController() {
        let pregnancyViewController = GetPregnancyViewController()
        pregnancyViewController.delegate = self
        pageDataSource.append(pregnancyViewController)
        let fetalNicknameViewController = GetFetalNicknameViewController()
        fetalNicknameViewController.delegate = self
        pageDataSource.append(fetalNicknameViewController)
    }
    
    func setProgressView() {
        self.onboardingProgressView.setProgress(0.5, animated: false)
    }
}

private extension OnboardingViewController {
    func fillProgressView(from input: Float) {
        UIView.animate(withDuration: 0.2) {
            self.onboardingProgressView.setProgress(input, animated: true)
        }
    }
    
    func presentLoginView() {
        self.navigationController?.popViewController(animated: true)
        self.navigator.backButtonTapped()
    }
    
    func presentOnboardingView(oldValue: OnbardingFlowType) {
        onboardingViewController.setViewControllers([pageDataSource[onboardingFlow.rawValue]],
                                                    direction: oldValue.rawValue > onboardingFlow.rawValue ? .reverse : .forward,
                                                    animated: false) { _ in
            guard let currentPage = OnboardingPageType(rawValue: self.onboardingFlow.rawValue) else { return }
            self.currentPage = currentPage
        }
    }
    
    func presentCompleteOnboardingView() {
        self.view.endEditing(true)
        self.nextButton.isUserInteractionEnabled = false
        let passingData = UserOnboardingModel(kakaoAccessToken: self.kakaoAccessToken, pregnacny: self.pregnancy, fetalNickname: self.fetalNickName)
        Task {
            showLoading()
            do {
                try await manager.signUp(type: .kakao, onboardingModel: passingData)
                hideLoading()
                self.navigator.onboardingCompleted(data: passingData)
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }

        }
    }
}

private extension OnboardingViewController {
    func nextOnboaringProcess(nickName: String, minCount: Int, maxCount: Int) {
        self.nextButton.isHidden = nickName.count >= minCount && nickName.count <= maxCount ? false : true
        self.onboardingFlow = self.currentPage.forward
        self.onboardingCompletePercentage = self.currentPage.progressValue
    }
    
    func nextOnboardingProcessWithNonActiveButtonState() {
        self.nextButton.isHidden = true
        self.onboardingFlow = self.currentPage.forward
        self.onboardingCompletePercentage = self.currentPage.progressValue
    }
    
    func backOnboardingProcess() {
        self.view.endEditing(true)
        self.nextButton.isHidden = false
        self.onboardingFlow = .toGetPregnacny
        self.onboardingCompletePercentage = self.currentPage.progressValue
    }
}

extension OnboardingViewController: FetalNicknameCheckDelegate {
    func sendFetalNickname(nickName: String) {
        self.fetalNickName = nickName
    }
    
    func checkFetalNickname(resultType: OnboardingFetalNicknameTextFieldResultType) {
        nextButton.isHidden = resultType.isHidden
    }
}

extension OnboardingViewController: PregnancyCheckDelegate {
    func sendPregnancyContent(pregnancy: Int) {
        self.pregnancy = pregnancy
    }
    
    func checkPregnancy(resultType: OnboardingPregnancyTextFieldResultType) {
        nextButton.isHidden = resultType.isHidden
    }
}

//extension OnboardingViewController: ViewControllerServiceable {
//    func handleError(_ error: NetworkError) {
//        switch error {
//        case .urlEncodingError:
//            print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
////            LHToast.show(message: "인코딩에러")
//        case .jsonDecodingError:
//            print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
////            LHToast.show(message: "디코딩에러")
//        case .badCasting:
//            print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
////            LHToast.show(message: "배드캐스트")
//        case .fetchImageError:
//            print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
////            LHToast.show(message: "이미지패치에러")
//        case .unAuthorizedError:
//            navigator.checkTokenIsExpired()
//        case .clientError(_, let message):
//            print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
////            LHToast.show(message: message)
//        case .serverError:
//            print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
////            LHToast.show(message: error.description)
//        }
//    }
//}
