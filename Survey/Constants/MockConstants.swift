//
//  MockConstants.swift
//  Survey
//
//  Created by Cristian Serea on 02.04.2024.
//

import Foundation

struct MockConstants {
    static var questionsData: Data {
        let url = Bundle.main.url(forResource: "Questions", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        
        return data
    }
    
    static var questions: [Question] {
        let questions = try! JSONDecoder().decode([Question].self, from: questionsData)
        
        return questions
    }
}
