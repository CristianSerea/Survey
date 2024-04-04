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
    @State private var isAlertPresented = false
    @State private var isSubmitingQuestion: Bool = false
    @State private var toast: Toast? = nil
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    
    var isTextValid: Bool {
        !text.isEmpty
    }
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack(spacing: GlobalConstants.Layout.marginOffset * 2) {
                Text(surveyViewModel.currentQuestion.question)
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.accent)
                    .accessibilityIdentifier(IdentifierConstants.questionsViewQuestion)
                
                TextField(LocalizableConstants.questionsViewType, text: $text)
                    .fontWeight(.medium)
                    .frame(height: GlobalConstants.Layout.defaultHeight)
                    .padding(.horizontal)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: GlobalConstants.Layout.marginOffset))
                    .focused($isFocused)
                    .disabled(surveyViewModel.isCurrentQuestionAlreadySubmitted)
                    .accessibilityIdentifier(IdentifierConstants.questionsViewTextField)
                
                let text = surveyViewModel.isCurrentQuestionAlreadySubmitted ? LocalizableConstants.questionsViewAlreadySubmitted : LocalizableConstants.questionsViewSubmitAnswer
                let isDisabled = surveyViewModel.isCurrentQuestionAlreadySubmitted || !isTextValid
                LoadingButton(isLoading: $isSubmitingQuestion,
                              isDisabled: isDisabled,
                              text: text,
                              action: {
                    submitQuestion()
                })
                .accessibilityIdentifier(IdentifierConstants.questionsViewSubmitQuestion)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.top, GlobalConstants.Layout.marginOffset)
            .padding(GlobalConstants.Layout.marginOffset)
        }
        .toastView(toast: $toast, onDismiss: {
            if surveyViewModel.isSurveyCompleted {
                isAlertPresented.toggle()
            }
        }, onRetryTapped: {
            submitQuestion()
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
        .onDisappear {
            surveyViewModel.reset()
        }
    }
    
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
            text = surveyViewModel.currentAnswer?.answer ?? ""
            toast = nil
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
            text = surveyViewModel.currentAnswer?.answer ?? ""
            toast = nil
        }, label: {
            Text(LocalizableConstants.questionsViewNext)
                .foregroundColor(surveyViewModel.canGoToNextQuestion ? .accent : .disabled)
        })
        .disabled(!surveyViewModel.canGoToNextQuestion)
        .accessibilityIdentifier(IdentifierConstants.questionsViewNext)
    }
    
    private func submitQuestion() {
        isSubmitingQuestion.toggle()
        
        let answer = Answer(questionId: surveyViewModel.currentQuestion.id, answer: text)
        surveyViewModel.submitQuestion(answer: answer) { result in
            isSubmitingQuestion.toggle()
            
            switch result {
            case .success:
                surveyViewModel.submittedAnswers.append(answer)
                toast = Toast(toastStyle: .success,
                              title: LocalizableConstants.questionsViewSuccess)
                if surveyViewModel.canGoToNextQuestion && !surveyViewModel.isSurveyCompleted {
                    surveyViewModel.goToNextQuestion()
                    text = surveyViewModel.currentAnswer?.answer ?? ""
                }
                
            case .failure(let failure):
                toast = Toast(toastStyle: .failure,
                              title: LocalizableConstants.questionsViewFailure,
                              message: failure.localizedDescription)
            }
        }
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
