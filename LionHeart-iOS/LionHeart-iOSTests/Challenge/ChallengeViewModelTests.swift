//
//  ChallengeViewModelTests.swift
//  LionHeart-iOSTests
//
//  Created by uiskim on 2023/12/01.
//

import XCTest
import Combine

@testable import LionHeart_iOS

final class ChallengeViewModelTests: ChallengeViewModelTestSetUp {

    func test_ChallengeVM의_viewWillAppear이후의_AppData변환이_잘이루어졌을때() {
        //given
        self.manager.returnValue = .init(babyNickname: "test", day: 12, level: "LEVEL_ONE", attendances: [])
        
        //when
        let expectation = XCTestExpectation(description: "manager에서 제대로된 값이 들어왔을때")
        var data: ChallengeData?
        output.viewWillAppearSubject
            .sink { value in
                data = value
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        viewWillAppearSubject.send(())
        
        //then
        let expectedValue = ChallengeData.init(babyDaddyName: "test", howLongDay: 12, daddyLevel: "LEVEL_ONE", daddyAttendances: [])
        wait(for: [expectation], timeout: 0.2)
        XCTAssertEqual(data, expectedValue)
    }
    
    func test_ChallengeVM의_viewWillAppear이후의_제대로된데이터가_전달되지않았을때() {
        //given
        self.manager.returnValue = nil
        
        //when
        let expectation = XCTestExpectation(description: "manager에서 nil이 들어왔을때")
        var data: ChallengeData?
        output.viewWillAppearSubject
            .sink { value in
                data = value
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        viewWillAppearSubject.send(())
        
        //then
        wait(for: [expectation], timeout: 0.2)
        XCTAssertEqual(data, ChallengeData.empty)
    }
    
    func test_ChallengeVM의_leftButtonTapped가_올바른값을전달하고있는지() {
        //give

        
        //when
        let expectation = XCTestExpectation(description: "네비게이션왼쪽버튼이 눌렸을때")
        
        var flowType: ChallengeViewModelImpl.FlowType!
        self.viewModel.navigationSubject
            .sink { flow in
                if flow == .bookmarkButtonTapped {
                    flowType = flow
                    expectation.fulfill()
                }
            }
            .store(in: &cancelBag)
        
        
        self.navigationLeftButtonTapped.send(()) // 1.

        //then
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(flowType, .bookmarkButtonTapped)
    }
}
