//
//  IceAndFire_SwiftUI_Tests.swift
//  IceAndFire(SwiftUI)Tests
//
//  Created by Anastasiia Zubova on 24.07.2022.
//

import XCTest
import Combine
@testable import IceAndFire_SwiftUI_

class IceAndFire_SwiftUI_Tests: XCTestCase {
    
    var viewModel: IceAndFireViewModel!
    var subscriptions = Set<AnyCancellable>()
    
    override func setUp() {
        viewModel = IceAndFireViewModel()
    }
    override func tearDown() {
        subscriptions = []
    }
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCollect() {
        let values = [0, 1, 2]
        let publisher = values.publisher
        publisher
            .collect()
            .sink(receiveValue: {
                XCTAssert(
                $0 == values,
                "Result was expected to be \(values) but was \($0)"
                )
            })
            .store(in: &subscriptions)
    }
    func testFlatMap() {
        let subj1 = PassthroughSubject<Int, Never>()
        let subj2 = PassthroughSubject<Int, Never>()
        let subj3 = PassthroughSubject<Int, Never>()
        let publisher = CurrentValueSubject<PassthroughSubject<Int, Never>, Never>(subj1)
        let expected = [1, 2, 4]
        var result = [Int]()
        
        publisher
            .flatMap(maxPublishers:
                    .max(2)) { $0 }
            .sink(receiveValue: { result.append($0)})
            .store(in: &subscriptions)
        subj1.send(1)
        publisher.send(subj2)
        publisher.send(subj3)
        subj3.send(3)
        subj2.send(4)
        publisher.send(completion: .finished)
        XCTAssert(
        result == expected,
        "Results rxpected to be \(expected) but were \(result)"
        )
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
