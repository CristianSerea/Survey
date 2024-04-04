//
//  SurveyViewModel.swift
//  Survey
//
//  Created by Cristian Serea on 02.04.2024.
//

import Foundation
import Combine

class SurveyViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var submittedAnswers: [Answer] = []
    @Published var currentQuestionIndex: Int = .zero
    
    var currentQuestion: Question {        
        questions[currentQuestionIndex]
    }
    
    var currentAnswer: Answer? {
        submittedAnswers.first(where: { questions[currentQuestionIndex].id == $0.questionId })
    }
    
    var isSurveyCompleted: Bool {
        questions.count == submittedAnswers.count
    }
    
    var canGoToNextQuestion: Bool {
        currentQuestionIndex < questions.count - 1
    }
    
    var canGoToPreviousQuestion: Bool {
        currentQuestionIndex > .zero
    }
    
    private let networkManager: NetworkManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
}

extension SurveyViewModel {
    func reset() {
        questions.removeAll()
        submittedAnswers.removeAll()
        currentQuestionIndex = .zero
    }
}

extension SurveyViewModel {
    func getQuestionIndex(id: Int) -> Int? {
        questions.firstIndex(where: { $0.id == id })
    }
    
    func getAnswer(question: Question) -> Answer? {
        submittedAnswers.first(where: { $0.questionId == question.id })
    }
    
    func goToPreviousQuestion() {
        currentQuestionIndex -= 1
    }
    
    func goToNextQuestion() {
        currentQuestionIndex += 1
    }
}

extension SurveyViewModel {
    func fetchQuestions(completion: @escaping (Result<Void, Error>) -> Void) {
        networkManager.fetchData(from: Request.fetchQuestions.url, method: .GET, body: nil)
            .sink { sinkCompletion in
                switch sinkCompletion {
                case .finished:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            } receiveValue: { [weak self] questions in
                self?.questions = questions
            }
            .store(in: &cancellables)
    }
    
    func submitQuestion(answer: Answer,
                        completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let body = try JSONEncoder().encode(answer)
            networkManager.fetchData(from: Request.submitQuestion.url, method: .POST, body: body)
                .sink { sinkCompletion in
                    switch sinkCompletion {
                    case .finished:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                } receiveValue: { (data: Data) in
                    debugPrint("Response data: \(data)")
                }
                .store(in: &cancellables)
        } catch {
            completion(.failure(error))
        }
    }
}
