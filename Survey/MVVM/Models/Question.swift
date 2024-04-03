//
//  Question.swift
//  Survey
//
//  Created by Cristian Serea on 02.04.2024.
//

import Foundation

struct Question: Decodable, Identifiable {
    let id: Int
    let question: String
}
