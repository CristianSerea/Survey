//
//  ViewModelsTests.swift
//  SurveyTests
//
//  Created by Cristian Serea on 03.04.2024.
//

import XCTest
import Combine
@testable import Survey

final class ViewModelsTests: XCTestCase {
    var viewModel: SurveyViewModel!
    var mockNetworkManager: MockNetworkManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        mockNetworkManager = MockNetworkManager()
        viewModel = SurveyViewModel(networkManager: mockNetworkManager)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        cancellables = nil
        
        super.tearDown()
    }
    
    func testReset() {
        viewModel.questions = [Question(id: 1, question: "Question 1"),
                               Question(id: 1, question: "Question 2")]
        viewModel.submittedAnswers = [Answer(questionId: 1, answer: "Answer 1")]
        viewModel.currentQuestionIndex = 1
        
        viewModel.reset()
        
        XCTAssertEqual(viewModel.questions.count, .zero)
        XCTAssertEqual(viewModel.submittedAnswers.count, .zero)
        XCTAssertEqual(viewModel.currentQuestionIndex, .zero)
    }
    
    func testGoToPreviousQuestion() {
        viewModel.currentQuestionIndex = 1
        viewModel.goToPreviousQuestion()
        XCTAssertEqual(viewModel.currentQuestionIndex, .zero)
    }
    
    func testGoToNextQuestion() {
        viewModel.currentQuestionIndex = .zero
        viewModel.goToNextQuestion()
        XCTAssertEqual(viewModel.currentQuestionIndex, 1)
    }
}

extension ViewModelsTests {
    func testFetchQuestions_Success() {
        let questions = [Question(id: 1, question: "Question 1"),
                         Question(id: 2, question: "Question 2")]
        let mockData = try! JSONEncoder().encode(questions)
        mockNetworkManager.mockData = mockData
        
        viewModel.fetchQuestions { result in
            switch result {
            case .success:
                XCTAssertEqual(self.viewModel.questions.count, questions.count)
                XCTAssertEqual(self.viewModel.questions.first?.id, questions.first?.id)
            case .failure:
                XCTFail("This should not happen")
            }
        }
    }
    
    func testFetchQuestions_Failure() {
        let mockError = NSError(domain: "MockErrorDomain", code: 123, userInfo: nil)
        mockNetworkManager.mockError = mockError
        
        viewModel.fetchQuestions { result in
            switch result {
            case .success:
                XCTFail("This should not happen")
            case .failure(let error):
                XCTAssertEqual(error as NSError, mockError)
            }
        }
    }
}

extension ViewModelsTests {
    func testSubmitQuestion_Success() {
        let answer = Answer(questionId: 1, answer: "Answer")
        mockNetworkManager.mockData = nil
        
        viewModel.submitQuestion(answer: answer) { result in
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure:
                XCTFail("This should not happen")
            }
        }
    }
    
    func testSubmitQuestion_Failure() {
        let answer = Answer(questionId: 1, answer: "Answer")
        let mockError = NSError(domain: "MockErrorDomain", code: 123, userInfo: nil)
        mockNetworkManager.mockError = mockError
        
        viewModel.submitQuestion(answer: answer) { result in
            switch result {
            case .success:
                XCTFail("This should not happen")
            case .failure(let error):
                XCTAssertEqual(error as NSError, mockError)
            }
        }
    }
}
