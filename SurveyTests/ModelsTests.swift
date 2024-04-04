//
//  ModelsTests.swift
//  SurveyTests
//
//  Created by Cristian Serea on 03.04.2024.
//

import XCTest
@testable import Survey

final class ModelsTests: XCTestCase {
    func testQuestionDecoding() throws {
        let json = """
            {
                "id": 1,
                "question": "Question"
            }
        """
        
        let data = json.data(using: .utf8)!
        let question = try JSONDecoder().decode(Question.self, from: data)
        
        XCTAssertEqual(question.id, 1)
        XCTAssertEqual(question.question, "Question")
    }
    
    func testAnswerEncoding() throws {
        let answer = Answer(questionId: 1, answer: "Answer")
        let data = try JSONEncoder().encode(answer)
        
        XCTAssertNotNil(data)
    }
    
    func testToastEquatable() {
        let toast1 = Toast(toastStyle: .success, title: "Title", message: "Message", duration: 2.0)
        let toast2 = Toast(toastStyle: .success, title: "Title", message: "Message", duration: 2.0)
        
        XCTAssertEqual(toast1, toast2)
    }
    
    func testToastStyleColor() {
        let successToast = Toast(toastStyle: .success, title: "Success", message: "Success Message")
        let failureToast = Toast(toastStyle: .failure, title: "Failure", message: "Failure Message")
        
        XCTAssertEqual(successToast.toastStyle.color, .success)        
        XCTAssertEqual(failureToast.toastStyle.color, .failure)
    }
}
