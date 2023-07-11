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
    
    private var onboardingCompletePercentage: Float = 0
    
    private var onboardingProgressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progressViewStyle = .bar
        progress.progressTintColor = .designSystem(.lionRed)
        progress.backgroundColor = .designSystem(.gray800)
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        progress.progress = 0.1
        return progress
    }()
    
    private var currentPage: OnboardingPageType = .getPregnancy
    
    private var onboardingFlow: OnbardingFlowType = .toGetPregnacny {
        didSet {
            switch onboardingFlow {
            case .toLogin:
                self.navigationController?.popViewController(animated: true)
            case .toGetPregnacny, .toFatalNickname:
                onboardingPageViewController.setViewControllers([pageViewControllerDataSource[onboardingFlow.rawValue]], direction: oldValue.rawValue > onboardingFlow.rawValue ? .reverse : .forward, animated: true) { _ in
                    self.setCurrentPage(index: self.onboardingFlow.rawValue)
                }
            case .toCompleteOnboarding:
                let completeViewController = CompleteOnbardingViewController()
                self.navigationController?.pushViewController(completeViewController, animated: true)
            }
        }
    }
    
    private lazy var onboardingNavigationbar = LHNavigationBarView(type: .onboarding, viewController: self)
        .rightFirstBarItemAction {
            self.navigationController?.popViewController(animated: true)
        }
    
    private let testButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.backgroundColor = .designSystem(.lionRed)
        return button
    }()
    
    private let onboardingPageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return pageViewController
    }()
    
    private var pageViewControllerDataSource: [UIViewController] = OnboardingPageType.allCases.map{$0.viewController}
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 컴포넌트 설정
        setUI()
        
        // MARK: - addsubView
        setHierarchy()
        
        // MARK: - 네비게이션바 설정
        setNavigationBar()
        
        // MARK: - autolayout설정
        setLayout()
        
        // MARK: - button의 addtarget설정
        setAddTarget()
        
        // MARK: - delegate설정
        setDelegate()
        
        // MARK: - PageViewController 설정
        setPageViewController()
    }
    
    func setCurrentPage(index: Int) {
        self.currentPage = OnboardingPageType(rawValue: index) ?? .getPregnancy
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
        addChild(onboardingPageViewController)
        view.addSubview(onboardingPageViewController.view)
        view.addSubview(testButton)
        view.addSubview(onboardingProgressView)
    }
    
    func setPageViewController() {
        if let firstViewController = pageViewControllerDataSource.first {
            onboardingPageViewController.setViewControllers([firstViewController], direction: .forward, animated: true)
        }
        onboardingPageViewController.didMove(toParent: self)
    }
    
    func setLayout() {
        onboardingPageViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        testButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        onboardingProgressView.snp.makeConstraints { make in
            make.top.equalTo(self.onboardingNavigationbar.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func setAddTarget() {
        testButton.addButtonAction { _ in
            self.onboardingFlow = self.currentPage.forward
        }
    }
    
    func setDelegate() {}
    
    
}
