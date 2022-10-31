//
//  BooksModel.swift
//  IceAndFire(SwiftUI)
//
//  Created by Anastasiia Zubova on 16.07.2022.
//

import Foundation

public struct IceAndFireBooks: Codable, Identifiable {
    public var id: Int64
    public var name: String
    public var numberOfPages: Int
    public var publisher: String
    public var country: String
    public var mediaType: String
    public var characters: [String]
    
    public init(id: Int64, name: String, numberOfPages: Int, publisher: String, country: String, mediaType: String, characters: [String]) {
        self.id = id
        self.name = name
        self.numberOfPages = numberOfPages
        self.publisher = publisher
        self.country = country
        self.mediaType = mediaType
        self.characters = characters
    }
}
