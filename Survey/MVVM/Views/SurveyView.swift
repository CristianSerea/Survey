//
//  SurveyView.swift
//  Survey
//
//  Created by Cristian Serea on 02.04.2024.
//

import SwiftUI
import PreviewSnapshots

struct SurveyView: View {
    @StateObject private var surveyViewModel = SurveyViewModel()
    @State private var isQuestionsViewPresented: Bool = false
    @State private var isFetchingQuestions: Bool = false
    @State private var toast: Toast?
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack(spacing: GlobalConstants.Layout.marginOffset * 2) {
                Text(LocalizableConstants.surveyViewWelcome)
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.accent)
                    .accessibilityIdentifier(IdentifierConstants.surveyViewWelcome)
                
                Text(LocalizableConstants.surveyViewDescription)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityIdentifier(IdentifierConstants.surveyViewDescription)
                
                LoadingButton(isLoading: $isFetchingQuestions, 
                              text: LocalizableConstants.surveyViewStartSurvey,
                              action: {
                    fetchQuestions()
                })
                .accessibilityIdentifier(IdentifierConstants.surveyViewStartSurvery)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.top, GlobalConstants.Layout.marginOffset)
            .padding(GlobalConstants.Layout.marginOffset)
        }
        .toastView(toast: $toast, onRetryTapped: {
            fetchQuestions()
        })
        .navigationTitle(LocalizableConstants.surveyViewSurvey)
        .navigationDestination(isPresented: $isQuestionsViewPresented) {
            QuestionsView(surveyViewModel: surveyViewModel)
        }
    }
    
    private func fetchQuestions() {
        isFetchingQuestions.toggle()
        
        surveyViewModel.fetchQuestions() { result in
            isFetchingQuestions.toggle()
            
            switch result {
            case .success:
                isQuestionsViewPresented.toggle()
                
            case .failure(let failure):
                toast = Toast(toastStyle: .failure,
                              title: LocalizableConstants.surveyViewFailure,
                              message: failure.localizedDescription)
            }
        }
    }
}

struct SurveyView_Previews: PreviewProvider {
    static var previews: some View {
        previewSnapshots.previews.previewLayout(.sizeThatFits)
    }
    
    static var previewSnapshots: PreviewSnapshots<Any?> {
        PreviewSnapshots(configurations: [
            .init(name: "SurveyView", state: nil),
        ], configure: { _ in
            NavigationStack {
                SurveyView()
            }
        })
    }
}
