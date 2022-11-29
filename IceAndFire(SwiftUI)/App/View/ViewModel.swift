//
//  ViewModel.swift
//  IceAndFire(SwiftUI)
//
//  Created by Anastasiia Zubova on 16.07.2022.
//

import Foundation
import Combine
import SwiftUI

class DIContainer {
    let model: IceAndFireViewModel = .init()
    let filter: Filter = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        model.getObject()
        makePipes()
    }
    
    private func makePipes() {
        filter
            .$tags
            .assign(to: \.filterTags, on: model)
            .store(in: &cancellables)
    }
}

class IceAndFireViewModel: ObservableObject {
    @Published var characters: [IceAndFireCharacters] = []
    @Published var error: IceAndFireAPI.CustomError? = nil
    @Published var lastUpdateTime: TimeInterval = Date().timeIntervalSince1970
    @Published var filterTags: [Tag] = []
    private var service = IceAndFireAPI()
    private var id: [Int] = []
    private var currentPage: Int = 1
    private var subscriptions: Set<AnyCancellable> = []
    
    var title: String {
        filterTags.map(\.rawValue).joined(separator: "+")
    }
    var character: [IceAndFireCharacters] {
        guard !filterTags.isEmpty else {
            return characters
        }
        return characters
            .filter { (character) -> Bool in
                return filterTags.reduce(false) { (isMatch, tag) -> Bool in
                    self.checkMatching(character: character, for: tag)
                }
            }
    }
    
    public func getObject() {
        service
            .getCharacters(id: currentPage + 1)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
            }, receiveValue: { character in
                self.lastUpdateTime = Date().timeIntervalSince1970
                self.characters = [character]
                self.currentPage += 1
                self.error = nil
            })
            .store(in: &subscriptions)
    }
    private func checkMatching(character: IceAndFireCharacters, for tag: Tag) -> Bool {
        switch tag {
        case .alive, .dead:
            return character.died.lowercased() == tag.rawValue.lowercased()
        case .female, .male, .genderless:
            return character.gender.lowercased() == tag.rawValue.lowercased()
        }
    }
}
