//
//  Filter.swift
//  IceAndFire(SwiftUI)
//
//  Created by Anastasiia Zubova on 08.11.2022.
//

import Foundation
import Combine

enum Tag: String, CaseIterable, Identifiable {
    case alive
    case dead
    case male
    case female
    case genderless
    
    var id: String {
        return self.rawValue
    }
}

final class Filter: ObservableObject {
    
    @Published var tags: [Tag] = []
    
    var header: String {
        tags.isEmpty
        ? "All characters"
        : tags
            .map { $0.rawValue.capitalized }
            .joined(separator: " + ")
    }
    
    init() {}
}
