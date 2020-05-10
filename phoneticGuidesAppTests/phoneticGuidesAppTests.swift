//
//  phoneticGuidesAppTests.swift
//  phoneticGuidesAppTests
//
//  Created by Yoshio on 2020/05/08.
//  Copyright © 2020 tukuyo. All rights reserved.
//

import XCTest
import RxSwift
@testable import phoneticGuidesApp

class phoneticGuidesAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testAPIClient() throws {
        let client = gooConvertAPIModel()
        let text = ["鮑","栗","雷","粉骨砕身","昇竜拳","ABCD"]
        let Answer = ["あわび","くり","かみなり","ふんこつさいしん","しょうりゅうけん","えーびーしーでぃー"]
        
        for (i,v) in text.enumerated() {
            let result = client.convertText(v)
            print("#1->",  result)
            // テストを書く勉強をする
        }
    }
}

