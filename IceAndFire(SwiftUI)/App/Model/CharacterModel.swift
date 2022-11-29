//
//  CharacterModel.swift
//  IceAndFire(SwiftUI)
//
//  Created by Anastasiia Zubova on 16.07.2022.
//

import Foundation

public struct Page: Codable {
    public var result: [IceAndFireCharacters]
    
    public init(result: [IceAndFireCharacters]) {
        self.result = result
    }
}
public struct IceAndFireCharacters: Codable, Identifiable {
    public var id: Int64
    public var name: String
    public var gender: String
    public var culture: String
    public var born: String
    public var died: String
    public var titles: [String]
    public var aliases: [String]
    public var father: String
    public var mother: String
    public var books: [String]
    
    public init(id: Int64, name: String, gender: String, culture: String, born: String, died: String, titles: [String], aliases: [String], father: String, mother: String, books: [String]) {
        self.id = id
        self.name = name
        self.gender = gender
        self.culture = culture
        self.born = born
        self.died = died
        self.titles = titles
        self.aliases = aliases
        self.father = father
        self.mother = mother
        self.books = books
    }
}
