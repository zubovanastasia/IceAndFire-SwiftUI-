//
//  CharacterStore.swift
//  IceAndFire(SwiftUI)Tests
//
//  Created by Anastasiia Zubova on 28.11.2022.
//

import Foundation
@testable import IceAndFire_SwiftUI_

class CharacterStore {
    static func getStoreCharacters() -> [IceAndFireCharacters] {
        guard
            let path = Bundle.main.path(forResource: "CharactersJSON", ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let page = try? JSONDecoder().decode(Page.self, from: jsonData)
        else {
            assertionFailure("Never must be here")
            return []
        }
        return page.result
    }
}
