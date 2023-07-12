//
//  OnboardingViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Onboarding. All rights reserved.
//

import UIKit

import SnapKit

final class OnboardingViewController: UIViewController {
    
    typealias OnboardingView = UIViewController
    
    private let nextButton = LHOnboardingButton()
    private var onboardingProgressView = LHProgressView()
    private let onboardingViewController = LHOnboardingController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var pageDataSource: [OnboardingView] = []
    private lazy var onboardingNavigationbar = LHNavigationBarView(type: .onboarding, viewController: self)
    private var fatalNickName: String?
    private var pregnancy: Int?
    private var currentPage: OnboardingPageType = .getPregnancy
    private var onboardingFlow: OnbardingFlowType = .toGetPregnacny {
        didSet {
            switch onboardingFlow {
            case .toLogin:
                presentLoginView()
            case .toGetPregnacny, .toFatalNickname:
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
}

private extension OnboardingViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setNavigationBar() {
        NavigationBarLayoutManager.add(onboardingNavigationbar)
    }
    
    func setHierarchy() {
        addChild(onboardingViewController)
        view.addSubviews(onboardingViewController.view, onboardingProgressView, nextButton)
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
            guard let fatalNickName = self.fatalNickName else {
                self.nextButton.isHidden = true
                self.onboardingFlow = self.currentPage.forward
                self.onboardingCompletePercentage = self.currentPage.progressValue
                return
            }
            if fatalNickName.count >= 1 && fatalNickName.count <= 10 {
                self.nextButton.isHidden = false
            } else {
                self.nextButton.isHidden = true
            }
            
            self.onboardingFlow = self.currentPage.forward
            self.onboardingCompletePercentage = self.currentPage.progressValue
        }
        
        onboardingNavigationbar.backButtonAction {
            self.view.endEditing(true)
            self.nextButton.isHidden = false
            self.onboardingFlow = self.currentPage.back
            self.onboardingCompletePercentage = self.currentPage.progressValue
        }
    }
    
    func setChildViewController() {
        let pregnancyViewController = GetPregnancyViewController()
        pregnancyViewController.delegate = self
        pageDataSource.append(pregnancyViewController)
        let fatalNicknameViewController = GetFatalNicknameViewController()
        fatalNicknameViewController.delegate = self
        pageDataSource.append(fatalNicknameViewController)
    }
    
    func setProgressView() {
        self.onboardingProgressView.setProgress(0.5, animated: false)
    }
}

extension OnboardingViewController: FatalNicknameCheckDelegate {
    func sendFatalNickname(nickName: String) {
        self.fatalNickName = nickName
    }
    
    func checkFatalNickname(resultType: OnboardingFatalNicknameTextFieldResultType) {
        switch resultType {
        case .fatalNicknameTextFieldEmpty, .fatalNicknameTextFieldOver:
            nextButton.isHidden = true
        case .fatalNicknameTextFieldValid:
            nextButton.isHidden = false
        }
    }
}

extension OnboardingViewController: PregnancyCheckDelegate {
    func sendPregnancyContent(pregnancy: Int) {
        self.pregnancy = pregnancy
    }
    
    func checkPregnancy(resultType: OnboardingPregnancyTextFieldResultType) {
        switch resultType {
        case .pregnancyTextFieldEmpty, .pregnancyTextFieldOver:
            nextButton.isHidden = true
        case .pregnancyTextFieldValid:
            nextButton.isHidden = false
        }
    }
}

extension OnboardingViewController {
    func fillProgressView(from input: Float) {
        UIView.animate(withDuration: 0.2) {
            self.onboardingProgressView.setProgress(input, animated: true)
        }
    }

    func presentLoginView() {
        self.navigationController?.popViewController(animated: true)
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
        let completeViewController = CompleteOnbardingViewController()
        let passingData = UserOnboardingModel(pregnacny: self.pregnancy, fatalNickname: self.fatalNickName)
        completeViewController.userData = passingData
        self.navigationController?.pushViewController(completeViewController, animated: true)
    }
}
