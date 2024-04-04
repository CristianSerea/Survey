//
//  NetworkManager.swift
//  Survey
//
//  Created by Cristian Serea on 02.04.2024.
//

import Foundation
import Combine

typealias ReturnedPublisher<T> = AnyPublisher<T, Error>

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(from url: URL,
                                 method: HTTPMethod,
                                 body: Data?) -> ReturnedPublisher<T>
}

extension NetworkManagerProtocol {
    func fetchData<T: Decodable>(from url: URL,
                                 method: HTTPMethod = .GET,
                                 body: Data? = nil) -> ReturnedPublisher<T> {
        return Empty<T, Error>().eraseToAnyPublisher()
    }
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    func fetchData<T: Decodable>(from url: URL, 
                                 method: HTTPMethod = .GET,
                                 body: Data? = nil) -> ReturnedPublisher<T> {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .flatMap { data -> ReturnedPublisher<T> in
                if data.isEmpty {
                    return Empty().eraseToAnyPublisher()
                } else {
                    return Just(data)
                        .decode(type: T.self, decoder: JSONDecoder())
                        .eraseToAnyPublisher()
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
