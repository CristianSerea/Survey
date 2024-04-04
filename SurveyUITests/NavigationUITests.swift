//
//  NavigationUITests.swift
//  SurveyUITests
//
//  Created by Cristian Serea on 04.04.2024.
//

import XCTest

final class NavigationUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func setUp() {
        super.setUp()
        
        app = XCUIApplication()
        app.launch()
    }
    
    private func navigateToQuestionsView() {
        let surveyViewStartSurvery = app.buttons[IdentifierConstants.surveyViewStartSurvery]
        XCTAssertTrue(surveyViewStartSurvery.exists)
        surveyViewStartSurvery.tap()
    }
}

extension NavigationUITests {
    func testSurveryView() {
        let surveyViewWelcome = app.staticTexts[IdentifierConstants.surveyViewWelcome]
        let surveyViewDescription = app.staticTexts[IdentifierConstants.surveyViewDescription]
        let surveyViewStartSurvery = app.buttons[IdentifierConstants.surveyViewStartSurvery]
        
        XCTAssertTrue(surveyViewWelcome.exists)
        XCTAssertTrue(surveyViewDescription.exists)
        XCTAssertTrue(surveyViewStartSurvery.exists)
    }
    
    func testSurveryViewStartSurvery() {
        let navigationTitle = app.navigationBars.element.staticTexts.firstMatch.label
        let surveyViewStartSurvery = app.buttons[IdentifierConstants.surveyViewStartSurvery]
        XCTAssertTrue(surveyViewStartSurvery.exists)
        XCTAssertTrue(surveyViewStartSurvery.isEnabled)
        surveyViewStartSurvery.tap()
        
        // The navigation to the next screen is performed very quick, so somtimes the button state is already reseted
        if navigationTitle == app.navigationBars.element.staticTexts.firstMatch.label {
            let loadingButtonProgressView = surveyViewStartSurvery.activityIndicators[IdentifierConstants.loadingButtonProgressView]
            XCTAssertTrue(loadingButtonProgressView.exists)
            XCTAssertFalse(surveyViewStartSurvery.isEnabled)
        } else {
            XCTAssertTrue(surveyViewStartSurvery.isEnabled)
        }
    }
    
    func testSurveyViewNavigation() {
        navigateToQuestionsView()
        
        let questionsViewQuestion = app.staticTexts[IdentifierConstants.questionsViewQuestion]
        XCTAssertTrue(questionsViewQuestion.waitForExistence(timeout: 3))
    }
}

extension NavigationUITests {
    func testQuestionsView() {
        navigateToQuestionsView()
        
        let questionsViewPrevious = app.buttons[IdentifierConstants.questionsViewPrevious]
        let questionsViewNext = app.buttons[IdentifierConstants.questionsViewNext]
        let questionsViewQuestionsSubmitted = app.staticTexts[IdentifierConstants.questionsViewQuestionsSubmitted]
        let questionsViewQuestion = app.staticTexts[IdentifierConstants.questionsViewQuestion]
        let questionsViewTextField = app.textFields[IdentifierConstants.questionsViewTextField]
        let questionsViewSubmitQuestion = app.buttons[IdentifierConstants.questionsViewSubmitQuestion]
        
        let expectation = XCTestExpectation(description: "Wait for elements to appear")
        let result = XCTWaiter.wait(for: [expectation], timeout: 3)
        
        if result == .timedOut {
            XCTAssertTrue(questionsViewPrevious.exists)
            XCTAssertTrue(questionsViewNext.exists)
            XCTAssertTrue(questionsViewQuestionsSubmitted.exists)
            XCTAssertTrue(questionsViewQuestion.exists)
            XCTAssertTrue(questionsViewTextField.exists)
            XCTAssertTrue(questionsViewSubmitQuestion.exists)
            XCTAssertFalse(questionsViewSubmitQuestion.isEnabled)
        } else {
            XCTFail("Timeout occurred while waiting for elements to appear")
        }
    }
    
    func testQuestionsViewTextField() {
        navigateToQuestionsView()
        
        let questionsViewTextField = app.textFields[IdentifierConstants.questionsViewTextField]
        let questionsViewSubmitQuestion = app.buttons[IdentifierConstants.questionsViewSubmitQuestion]
        
        let expectation = XCTestExpectation(description: "Wait for elements to appear")
        let result = XCTWaiter.wait(for: [expectation], timeout: 3)
        
        if result == .timedOut {
            XCTAssertTrue(questionsViewTextField.exists)
            XCTAssertTrue(questionsViewSubmitQuestion.exists)
            XCTAssertFalse(questionsViewSubmitQuestion.isEnabled)
            
            questionsViewTextField.tap()
            questionsViewTextField.typeText("Answer")
            
            XCTAssertEqual(questionsViewTextField.value as? String, "Answer")
            XCTAssertTrue(questionsViewSubmitQuestion.isEnabled)
        } else {
            XCTFail("Timeout occurred while waiting for elements to appear")
        }
    }
    
    func testQuestionsViewSubmitQuestion() {
        testQuestionsViewTextField()
        
        let questionsViewQuestion = app.staticTexts[IdentifierConstants.questionsViewQuestion]
        let questionsViewTextField = app.textFields[IdentifierConstants.questionsViewTextField]
        let questionsViewSubmitQuestion = app.buttons[IdentifierConstants.questionsViewSubmitQuestion]
        let navigationTitle = app.navigationBars.element.staticTexts.firstMatch.label
        let questionsViewQuestionLabel = questionsViewQuestion.label
        let questionsViewTextFieldValue = questionsViewTextField.value as? String
        
        questionsViewSubmitQuestion.tap()
        
        let expectation = XCTestExpectation(description: "Wait for submit question")
        let result = XCTWaiter.wait(for: [expectation], timeout: 3)
        
        if result == .timedOut {
            // Check if submit answer request failed by comparing navigation titles
            if navigationTitle == app.navigationBars.element.staticTexts.firstMatch.label {
                XCTAssertEqual(questionsViewQuestion.label, questionsViewQuestionLabel)
                XCTAssertEqual(questionsViewTextField.value as? String, questionsViewTextFieldValue)
                XCTAssertTrue(questionsViewSubmitQuestion.isEnabled)
            } else {
                XCTAssertNotEqual(questionsViewQuestion.label, questionsViewQuestionLabel)
                XCTAssertEqual(questionsViewTextField.value as? String, "Type your answer...")
                XCTAssertFalse(questionsViewSubmitQuestion.isEnabled)
            }
        } else {
            XCTFail("Timeout occurred while waiting for submit question")
        }
    }
    
    func testQuestionsViewNavigation() {
        navigateToQuestionsView()
        
        let backButton = app.navigationBars.buttons.element(boundBy: .zero)
        XCTAssertTrue(backButton.waitForExistence(timeout: 3))
        backButton.tap()
        
        let surveyViewWelcome = app.staticTexts[IdentifierConstants.surveyViewWelcome]
        XCTAssertTrue(surveyViewWelcome.waitForExistence(timeout: 1))
    }
}
