//
//  Enumerations.swift
//  Survey
//
//  Created by Cristian Serea on 03.04.2024.
//

import Foundation
import SwiftUI

enum HTTPMethod: String {
    case GET
    case POST
}

enum Request {
    case fetchQuestions
    case submitQuestion
    
    var url: URL {
        switch self {
        case .fetchQuestions:
            return URL(string: GlobalConstants.Server.domain + GlobalConstants.Server.fetchQuestions)!
        case .submitQuestion:
            return URL(string: GlobalConstants.Server.domain + GlobalConstants.Server.submitQuestion)!
        }
    }
}

enum ToastStyle {
    case failure
    case success
    
    var color: Color {
        switch self {
        case .failure: 
            return .failure
        case .success:
            return .success
        }
    }
}
