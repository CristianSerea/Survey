//
//  SurveyView.swift
//  Survey
//
//  Created by Cristian Serea on 02.04.2024.
//

import SwiftUI

struct SurveyView: View {
    @StateObject private var surveyViewModel = SurveyViewModel()
    @State private var isQuestionsViewPresented: Bool = false
    @State private var isFetchingQuestions: Bool = false
    @State private var toast: Toast? = nil
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack(spacing: GlobalConstants.Layout.marginOffset * 2) {
                Text(LocalizableConstants.surveyViewWelcome)
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.accent)
                
                Text(LocalizableConstants.surveyViewDescription)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LoadingButton(isLoading: $isFetchingQuestions, 
                              text: LocalizableConstants.surveyViewStartSurvey,
                              action: {
                    fetchQuestions()
                })
                
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

#Preview {
    NavigationStack {
        SurveyView()
    }
}
