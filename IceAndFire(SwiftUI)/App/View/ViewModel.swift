//
//  ViewModel.swift
//  IceAndFire(SwiftUI)
//
//  Created by Anastasiia Zubova on 16.07.2022.
//

import Foundation
import Combine
import SwiftUI

class IceAndFireViewModel: ObservableObject {
    @Published var characters: [IceAndFireCharacters] = []
    @Published var error: IceAndFireAPI.CustomError? = nil
    @Published var lastUpdateTime: TimeInterval = Date().timeIntervalSince1970
    var service: IceAndFireAPI
    var id: String = ""
    private var subscriptions: Set<AnyCancellable> = []
    
    init(service: IceAndFireAPI) {
        self.service = service
    }
    
    public func getObject(id: String) {
        service.getCharacters(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
            }, receiveValue: { characters in
                self.lastUpdateTime = Date().timeIntervalSince1970
                self.characters = []
                self.error = nil
            })
            .store(in: &subscriptions)
    }
}
