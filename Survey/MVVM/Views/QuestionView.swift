//
//  QuestionView.swift
//  Survey
//
//  Created by Cristian Serea on 04.04.2024.
//

import SwiftUI
import PreviewSnapshots

struct QuestionView: View {
    var question: Question
    var answer: Answer?
    var focused: FocusState<Int?>.Binding
    let submitQuestion: ((String) -> Void)?
    @ObservedObject var surveyViewModel: SurveyViewModel
    @Binding var isSubmittingQuestion: Bool
    @State private var answerText: String = ""
    
    var isAnswerTextValid: Bool {
        !answerText.isEmpty
    }
    
    var isQuestionAlreadySubmitted: Bool {
        answer != nil
    }
    
    var body: some View {
        VStack(spacing: GlobalConstants.Layout.marginOffset * 2) {
            Text(question.question)
                .font(.title2)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.accent)
                .accessibilityIdentifier(IdentifierConstants.questionsViewQuestion)
            
            TextField(LocalizableConstants.questionsViewType, text: $answerText)
                .fontWeight(.medium)
                .frame(height: GlobalConstants.Layout.defaultHeight)
                .padding(.horizontal)
                .background(isQuestionAlreadySubmitted ? Color(.systemGray5) : Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: GlobalConstants.Layout.marginOffset))
                .focused(focused, equals: question.id)
                .disabled(isQuestionAlreadySubmitted)
                .accessibilityIdentifier(IdentifierConstants.questionsViewTextField)
            
            let text = isQuestionAlreadySubmitted ? LocalizableConstants.questionsViewAlreadySubmitted : LocalizableConstants.questionsViewSubmitAnswer
            let isDisabled = isQuestionAlreadySubmitted || !isAnswerTextValid
            LoadingButton(isLoading: $isSubmittingQuestion,
                          isDisabled: isDisabled,
                          text: text,
                          action: {
                submitQuestion?(answerText)
            })
            .accessibilityIdentifier(IdentifierConstants.questionsViewSubmitQuestion)
            
            Spacer()
        }
        .padding(GlobalConstants.Layout.marginOffset)
        .onAppear {
            answerText = answer?.answer ?? ""
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    typealias QuestionViewPreviewsState = (question: Question,
                                           answer: Answer?,
                                           surveyViewModel: SurveyViewModel,
                                           isSubmittingQuestion: Bool)
    
    static var previews: some View {
        previewSnapshots.previews.previewLayout(.sizeThatFits)
    }
    
    static var previewSnapshots: PreviewSnapshots<QuestionViewPreviewsState> {
        PreviewSnapshots(configurations: [
            .init(name: "QuestionView no answer", state: firstState),
            .init(name: "QuestionView submiting answer", state: secondState),
            .init(name: "QuestionView answer already submitted", state: thirdState)
        ], configure: { state in
            NavigationStack {
                QuestionViewContainer(state: state)
            }
        })
    }
    
    struct QuestionViewContainer: View {
        let state: QuestionViewPreviewsState
        @FocusState private var focused: Int?
        
        var body: some View {
            QuestionView(question: state.question,
                         answer: state.answer,
                         focused: $focused,
                         submitQuestion: nil,
                         surveyViewModel: state.surveyViewModel,
                         isSubmittingQuestion: .constant(state.isSubmittingQuestion))
        }
    }

    
    static var firstState: QuestionViewPreviewsState {
        let questions = MockConstants.questions
        let surveyViewModel = SurveyViewModel()
        surveyViewModel.questions = questions
        
        return (questions[.zero], nil, surveyViewModel, false)
    }
    
    static var secondState: QuestionViewPreviewsState {
        let questions = MockConstants.questions
        let surveyViewModel = SurveyViewModel()
        surveyViewModel.questions = questions
        
        return (questions[.zero], nil, surveyViewModel, true)
    }
    
    static var thirdState: QuestionViewPreviewsState {
        let questions = MockConstants.questions
        let question = questions[.zero]
        let surveyViewModel = SurveyViewModel()
        surveyViewModel.questions = questions
        let answer = Answer(questionId: question.id, answer: "Answer")
        surveyViewModel.submittedAnswers.append(answer)
        
        return (question, answer, surveyViewModel, false)
    }
}
