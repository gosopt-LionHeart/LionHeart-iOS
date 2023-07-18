//
//  CurriculumUserInfoView.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/12.
//  Copyright (c) 2023 CurriculumUserInfo. All rights reserved.
//

import UIKit

import SnapKit

final class CurriculumUserInfoView: UIView {
        
    var userInfo: UserInfoData? {
        didSet {
            configureUserInfo(data: userInfo)
        }
    }
    
    private let nowLable: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body2R)
        label.textColor = .designSystem(.lionRed)
        label.text = "Now"
        return label
    }()
    
    private let fetusNameLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head3)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    private let weekImageView: UIImageView = {
        let imageView = UIImageView(image: ImageLiterals.Curriculum.weekBackground)
        return imageView
    }()
    
    private let userWeekLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head1)
        label.textColor = .designSystem(.gray100)
        return label
    }()
    
    private let weekLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head1)
        label.textColor = .designSystem(.white)
        label.text = "주"
        return label
    }()
    
    private let dayImageView: UIImageView = {
        let imageView = UIImageView(image: ImageLiterals.Curriculum.dayBackground)
        return imageView
    }()
    
    private let userDayLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head1)
        label.textColor = .designSystem(.gray100)
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head1)
        label.textColor = .designSystem(.white)
        label.text = "일차"
        return label
    }()
    
    private let userWeekDayInfoView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)


    }
    
    override func layoutSubviews() {
        // MARK: - 컴포넌트 설정
        setUI()
        
        // MARK: - addsubView
        setHierarchy()
        
        // MARK: - autolayout설정
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CurriculumUserInfoView {
    func setUI() {
        
    }
    
    func setHierarchy() {
        self.addSubviews(nowLable, fetusNameLabel, userWeekDayInfoView, weekImageView, userWeekLabel, weekLabel, dayImageView, userDayLabel, dayLabel)
    }
    
    func setLayout() {
        nowLable.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(24)
        }
        
        fetusNameLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(nowLable.snp.bottom).offset(4)
        }
        
        weekImageView.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(fetusNameLabel.snp.bottom).offset(8)
        }
        
        userWeekLabel.snp.makeConstraints{
//            $0.leading.equalTo(weekImageView.snp.leading).offset(5)
            $0.centerX.equalTo(weekImageView)
            $0.top.equalTo(fetusNameLabel.snp.bottom).offset(12)
        }
        
        weekLabel.snp.makeConstraints{
            $0.leading.equalTo(weekImageView.snp.trailing).offset(6)
            $0.centerY.equalTo(userWeekLabel)
        }
        
        dayImageView.snp.makeConstraints{
            $0.leading.equalTo(weekLabel.snp.trailing).offset(8)
            $0.top.equalTo(fetusNameLabel.snp.bottom).offset(8)
        }
        
        userDayLabel.snp.makeConstraints{
            $0.leading.equalTo(dayImageView.snp.leading).offset(4)
            $0.top.equalTo(fetusNameLabel.snp.bottom).offset(12)
        }
        
        dayLabel.snp.makeConstraints{
            $0.leading.equalTo(dayImageView.snp.trailing).offset(6)
            $0.centerY.equalTo(userWeekLabel)
        }
        
    }
    
    func configureUserInfo(data: UserInfoData?) {
        guard let data = data else {return}
        self.fetusNameLabel.text = "\(data.fetusName) 아빠님은"
        self.userWeekLabel.text = "\(data.userWeekInfo)"
        self.userDayLabel.text = "\(data.userDayInfo)"
        
    }
}
