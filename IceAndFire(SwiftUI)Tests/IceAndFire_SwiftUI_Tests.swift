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
 
    private var viewModel: IceAndFireViewModel!
    private var cancellables:  Set<AnyCancellable> = []
    
    override func setUp() {
        viewModel = .init()
    }
    override func tearDown() {
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }
    func testTags() {
        let tags: [Tag] = [.alive, .male]
        var result: [Tag] = []
        let sub = viewModel.$filterTags
            .sink(receiveValue: {result = $0})
        viewModel.filterTags = tags
        XCTAssertEqual(result, tags)
    }
    func testTitle() {
        let tags: [Tag] = [.alive, .male]
        let expectedTitle = tags.map { $0.rawValue }.joined(separator: "+")
        viewModel.filterTags = tags
        XCTAssertEqual(expectedTitle, viewModel.title)
    }
    func testFiltering() {
        let mockView = MockIceAndFireViewModel()
        mockView.getObject()
        
        let tags: [Tag] = [.male]
        var result: [IceAndFireCharacters] = []
        let filteredCharacters  = CharacterStore.getStoreCharacters()
            .filter {
                tags.map(\.rawValue.localizedLowercase)
                .contains($0.gender.lowercased())
            }
        let exp = expectation(description: "exp")
        
        let sub = mockView.$filterTags
            .receive(on: DispatchQueue.main)
            .sink { newTags in
                result = mockView.character
            }
        mockView.filterTags = tags
        XCTWaiter.wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(result.count, filteredCharacters.count)
    }
}

final class MockIceAndFireViewModel: IceAndFireViewModel {
    override func getObject() {
        characters = CharacterStore.getStoreCharacters()
    }
}

