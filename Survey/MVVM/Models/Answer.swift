//
//  Answer.swift
//  Survey
//
//  Created by Cristian Serea on 02.04.2024.
//

import Foundation

struct Answer: Encodable {
    let questionId: Int
    let answer: String
    
    enum CodingKeys: String, CodingKey {
        case questionId = "id"
        case answer
    }
}
