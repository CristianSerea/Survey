//
//  QuestionsView.swift
//  Survey
//
//  Created by Cristian Serea on 02.04.2024.
//

import SwiftUI
import PreviewSnapshots

struct QuestionsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var surveyViewModel: SurveyViewModel
    @State private var canAnimate: Bool = false
    @State private var isAlertPresented: Bool = false
    @State private var isSubmittingQuestion: Bool = false
    @State private var toast: Toast?
    @State private var currentQuestionId: Int = .zero
    @State private var answer: Answer?
    @FocusState private var focused: Int?
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack(spacing: .zero) {
                Text(LocalizableConstants.questionsViewQuestionsSubmitted + " " + "\(surveyViewModel.submittedAnswers.count)")
                    .fontWeight(.medium)
                    .padding(.horizontal, GlobalConstants.Layout.marginOffset)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .accessibilityIdentifier(IdentifierConstants.questionsViewQuestionsSubmitted)
                
                TabView(selection: $currentQuestionId) {
                    ForEach(surveyViewModel.questions, id: \.self) { question in
                        QuestionView(question: question,
                                     answer: surveyViewModel.getAnswer(question: question),
                                     focused: $focused,
                                     submitQuestion: submitQuestion,
                                     surveyViewModel: surveyViewModel,
                                     isSubmittingQuestion: $isSubmittingQuestion)
                        .tag(question.id)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, GlobalConstants.Layout.marginOffset)
                .tabViewStyle(PageTabViewStyle())
                .animation(canAnimate ? .default : .none, value: currentQuestionId)
                .transition(.slide)
                .onChange(of: currentQuestionId) {
                    guard let currentQuestionIndex = surveyViewModel.getQuestionIndex(id: currentQuestionId) else {
                        return
                    }
                    
                    guard currentQuestionIndex != surveyViewModel.currentQuestionIndex else {
                        return
                    }
                     
                    surveyViewModel.currentQuestionIndex = currentQuestionIndex
                    reset()
                }
            }
        }
        .toastView(toast: $toast, onDismiss: {
            if surveyViewModel.isSurveyCompleted {
                isAlertPresented.toggle()
            }
        }, onRetryTapped: {
            if let text = answer?.answer {
                submitQuestion(text: text)
            }
        })
        .alert(isPresented: $isAlertPresented) {
            alert
        }
        .navigationTitle("\(LocalizableConstants.questionsViewQuestions) \(surveyViewModel.currentQuestionIndex + 1)/\(surveyViewModel.questions.count)")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if !surveyViewModel.isSurveyCompleted {
                ToolbarItem(placement: .navigationBarTrailing) {
                    previousButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    nextButton
                }
            }
        }
        .onAppear {
            currentQuestionId = surveyViewModel.currentQuestion.id
            
            DispatchQueue.main.async {
                canAnimate = true
            }
        }
        .onDisappear {
            surveyViewModel.reset()
        }
    }
}

extension QuestionsView {
    var alert: Alert {
        Alert(
            title: Text(LocalizableConstants.alertViewCongratulations),
            message: Text(LocalizableConstants.alertViewCompleted),
            dismissButton: .default(Text(LocalizableConstants.alertViewDone), action: {
                dismiss()
            })
        )
    }
    
    var previousButton: some View {
        Button(action: {
            surveyViewModel.goToPreviousQuestion()
            reset()
        }, label: {
            Text(LocalizableConstants.questionsViewPrevious)
                .foregroundColor(surveyViewModel.canGoToPreviousQuestion ? .accent : .disabled)
        })
        .disabled(!surveyViewModel.canGoToPreviousQuestion)
        .accessibilityIdentifier(IdentifierConstants.questionsViewPrevious)
    }
    
    var nextButton: some View {
        Button(action: {
            surveyViewModel.goToNextQuestion()
            reset()
        }, label: {
            Text(LocalizableConstants.questionsViewNext)
                .foregroundColor(surveyViewModel.canGoToNextQuestion ? .accent : .disabled)
        })
        .disabled(!surveyViewModel.canGoToNextQuestion)
        .accessibilityIdentifier(IdentifierConstants.questionsViewNext)
    }
    
    private func submitQuestion(text: String) {
        isSubmittingQuestion.toggle()
        
        let questionAnswer = Answer(questionId: surveyViewModel.currentQuestion.id, answer: text)
        surveyViewModel.submitQuestion(answer: questionAnswer) { result in
            isSubmittingQuestion.toggle()
            
            switch result {
            case .success:
                surveyViewModel.submittedAnswers.append(questionAnswer)
                toast = Toast(toastStyle: .success,
                              title: LocalizableConstants.questionsViewSuccess)
                if surveyViewModel.canGoToNextQuestion && !surveyViewModel.isSurveyCompleted {
                    surveyViewModel.goToNextQuestion()
                }
                reset()
                
            case .failure(let failure):
                answer = questionAnswer
                toast = Toast(toastStyle: .failure,
                              title: LocalizableConstants.questionsViewFailure,
                              message: failure.localizedDescription)
            }
        }
    }
}

extension QuestionsView {
    func reset() {
        currentQuestionId = surveyViewModel.currentQuestion.id
        answer = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            focused = getFocused()
        }
    }
    
    func getFocused() -> Int? {
        let question = surveyViewModel.currentQuestion
        let answer = surveyViewModel.getAnswer(question: question)
        return answer == nil ? question.id : nil
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        previewSnapshots.previews.previewLayout(.sizeThatFits)
    }
    
    static var previewSnapshots: PreviewSnapshots<SurveyViewModel> {
        PreviewSnapshots(configurations: [
            .init(name: "QuestionsView", state: state),
        ], configure: { state in
            NavigationStack {
                QuestionsView(surveyViewModel: state)
            }
        })
    }
    
    static var state: SurveyViewModel {
        let surveyViewModel = SurveyViewModel()
        surveyViewModel.questions = MockConstants.questions
        return surveyViewModel
    }
}
