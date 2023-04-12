//
//  SimpleAppTests.swift
//  SimpleAppTests
//
//  Created by Shazy on 03/03/23.
//

import Foundation
import XCTest
import 

final class SimpleAppTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let storage = Storage()
        storage.prep
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

protocol MyProt {
    func myFunc()
}

extension MyProt {
    func myFunc() {
     print("Function from protocol called")
    }
}

class MyClass: MyProt {
    func myFunc() {
        print("Function from MyClass Called")
    }
}
