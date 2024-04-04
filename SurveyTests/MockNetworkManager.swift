//
//  MockNetworkManager.swift
//  SurveyTests
//
//  Created by Cristian Serea on 03.04.2024.
//

import Foundation
import Combine
@testable import Survey

class MockNetworkManager: NetworkManagerProtocol {
    var mockData: Data?
    var mockError: Error?
    
    func fetchData<T: Decodable>(from url: URL, method: HTTPMethod, body: Data?) -> ReturnedPublisher<T> {
        if let mockError = mockError {
            return Fail(error: mockError).eraseToAnyPublisher()
        } else if let mockData = mockData {
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: mockData)
                return Just(decodedData).setFailureType(to: Error.self).eraseToAnyPublisher()
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        } else {
            return Empty<T, Error>().eraseToAnyPublisher()
        }
    }
}
