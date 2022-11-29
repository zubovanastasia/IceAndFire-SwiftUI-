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
        case books(Int)
        case characters(Int)
        case page(Int, Int)
        
        var url: NSURL {
            switch self {
            case .books(let id):
                return Method.baseURL.appendingPathComponent("books/" + String(id)) as NSURL
            case .characters(let id):
                return Method.baseURL.appendingPathComponent("characters/" + String(id)) as NSURL
            case .page(let page, let pageSize):
                return Method.baseURL.appendingPathComponent("characters/" + "?page=\(page)&pageSize=\(pageSize)") as NSURL
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
    
    func getBooks(id: Int) -> AnyPublisher<IceAndFireBooks, CustomError> {
        URLSession.shared
            .dataTaskPublisher(for: Method.books(id).url as URL)
            .receive(on: queue)
            .map(\.data)
            .decode(type: IceAndFireBooks.self, decoder: decoder)
            .mapError({ error -> CustomError in
                switch error {
                case is URLError:
                    return CustomError.unreachableAddress(url: Method.characters(id).url as URL)
                default:
                    return CustomError.invalidResponse
                }
            })
            .eraseToAnyPublisher()
    }
    func getCharacters(id: Int) -> AnyPublisher<IceAndFireCharacters, CustomError> {
        URLSession.shared
            .dataTaskPublisher(for: Method.characters(id).url as URL)
            .receive(on: queue)
            .map(\.data)
            .decode(type: IceAndFireCharacters.self, decoder: decoder)
            .mapError({ error -> CustomError in
                switch error {
                case is URLError:
                    return CustomError.unreachableAddress(url: Method.characters(id).url as URL)
                default:
                    return CustomError.invalidResponse
                }
            })
            .eraseToAnyPublisher()
    }
    func mergedCharacters(id: [Int]) -> AnyPublisher<IceAndFireCharacters, CustomError> {
        precondition(!id.isEmpty)
        let initialPublisher = getCharacters(id: id[0])
        let remainder = id.dropFirst()
        return remainder.reduce(initialPublisher) { (combined, id) in
            combined
                .merge(with: getCharacters(id: id))
                .eraseToAnyPublisher()
        }
    }
   
    func page(num: Int, pageSize: Int) -> AnyPublisher<Page, CustomError> {
        var pageSize = pageSize
                if pageSize > 50 {
                    print ("Page size can be maximum 50, 50 is used.")
                    pageSize = 50
                }
        return URLSession.shared
            .dataTaskPublisher(for: Method.page(num, pageSize).url as URL)
            .receive(on: queue)
            .map(\.data)
            .decode(type: Page.self, decoder: decoder)
            .mapError({ error -> CustomError in
                switch error {
                case is URLError:
                    return CustomError.unreachableAddress(url: Method.page(num, pageSize).url as URL)
                default:
                    return CustomError.invalidResponse
                }
            })
            .eraseToAnyPublisher()
    }
}
