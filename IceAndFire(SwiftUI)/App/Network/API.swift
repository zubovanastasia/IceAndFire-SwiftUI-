//
//  API.swift
//  IceAndFire(SwiftUI)
//
//  Created by Anastasiia Zubova on 16.07.2022.
//

import Foundation
import Combine

struct IceAndFireAPI {
    
    // Method.
    enum Method {
        static let baseURL = URL(string: "https://anapioficeandfire.com/api/")!
        case books(String)
        case characters(String)
        
        var url: URL {
            switch self {
            case .books(let id):
                return Method.baseURL.appendingPathComponent("books/\(id)")
            case .characters(let id):
                return Method.baseURL.appendingPathComponent("characters/\(id)")
            }
        }
    }
    // Error.
    enum CustomError: LocalizedError, Identifiable {
        var id: String { localizedDescription }
        case unreachableAddress(url: URL)
        case invalidResponse
        var errorDescription: String? {
            switch self {
            case .unreachableAddress(let url):
                return "\(url.absoluteString) is unreachable"
            case .invalidResponse:
                return "Response with mistake"
            }
        }
    }
    
    // API.
    private let decoder = JSONDecoder()
    private let queue = DispatchQueue(label: "IceAndFireAPI", qos: .default, attributes: .concurrent)
    var subscriptions: Set<AnyCancellable> = []
    
    func getBooks(id: String) -> AnyPublisher<IceAndFireBooks, CustomError> {
        URLSession.shared.dataTaskPublisher(for: Method.books(id).url)
            .receive(on: queue)
            .map(\.data)
            .decode(type: IceAndFireBooks.self, decoder: decoder)
            .mapError({ error -> CustomError in
                switch error {
                case is URLError:
                    return CustomError.unreachableAddress(url: Method.characters(id).url)
                default:
                    return CustomError.invalidResponse
                }
            })
            .eraseToAnyPublisher()
    }
    func getCharacters(id: String) -> AnyPublisher<IceAndFireCharacters, CustomError> {
        URLSession.shared.dataTaskPublisher(for: Method.characters(id).url)
            .receive(on: queue)
            .map(\.data)
            .decode(type: IceAndFireCharacters.self, decoder: decoder)
            .mapError({ error -> CustomError in
                switch error {
                case is URLError:
                    return CustomError.unreachableAddress(url: Method.characters(id).url)
                default:
                    return CustomError.invalidResponse
                }
            })
            .eraseToAnyPublisher()
    }
    func mergedCharacters(id: [String]) -> AnyPublisher<IceAndFireCharacters, CustomError> {
        precondition(!id.isEmpty)
        let initialPublisher = getCharacters(id: id[0])
        let remainder = Array(id.dropFirst())
        return remainder.reduce(initialPublisher) {
            (combined, id) in
            return combined
                .mapError({ error -> CustomError in
                    switch error {
                    case is URLError:
                        return CustomError.unreachableAddress(url: Method.characters(id).url)
                    default:
                        return CustomError.invalidResponse
                    }
                })
                .eraseToAnyPublisher()
        }
    }
}
