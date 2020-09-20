//
//  phoneticGuidesAppTests.swift
//  phoneticGuidesAppTests
//
//  Created by Yoshio on 2020/05/08.
//  Copyright © 2020 tukuyo. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import phoneticGuidesApp

class phoneticGuidesAppTests: XCTestCase {
    
    var vc: InputViewController!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        vc = InputViewController()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_InputViewControllerTitle() {
        let window = UIWindow()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        XCTAssertEqual(vc.title, "ふりがなガイド")
    }
    
    func test_convertButtonToNextView() {
        vc.viewDidLoad()
        let window = UIWindow()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        vc.inputTextView.text = "お仕事ください．Please give me a job."
        let exp = XCTestExpectation(description: "A")
        wait(for: [exp], timeout: 10)
        vc.convertButton.sendActions(for: .touchUpInside)
        
        
//        let viewmodel = vc.inputViewModel
//        let tapButtonEvent = scheduler.createHotObservable([
//            next(10, ()),
//            next(20, ()),
//            next(30, ()),
//            next(40, ())
//        ]).asDriver(onErrorJustReturn: {}())
//
//        tapButtonEvent.bind(to: viewmodel.Input.convertTrigger)
//            .disposed(by: disposeBag)
        
        XCTAssertTrue(vc.presentedViewController is OutputViewController)
        
    }
    
    
    
    
}

