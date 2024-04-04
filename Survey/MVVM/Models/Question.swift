//
//  Question.swift
//  Survey
//
//  Created by Cristian Serea on 02.04.2024.
//

import Foundation

struct Question: Codable, Identifiable, Hashable {
    let id: Int
    let question: String
}
