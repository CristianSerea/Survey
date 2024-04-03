//
//  LoadingButton.swift
//  Survey
//
//  Created by Cristian Serea on 02.04.2024.
//

import SwiftUI

struct LoadingButton: View {
    @Binding var isLoading: Bool
    
    var isDisabled: Bool = false
    let text: String
    let action: () -> Void
    
    var disabled: Bool {
        return isDisabled || isLoading
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text.capitalized)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding()
                
                if isLoading {
                    ProgressView()
                        .tint(.white)
                        .padding(.trailing)
                }
            }
            .padding()
            .background(disabled ? .disabled : .accent)
            .frame(height: GlobalConstants.Layout.defaultHeight)
            .clipShape(Capsule())
        }
        .disabled(disabled)
    }
}

#Preview {
    return LoadingButton(isLoading: .constant(false),
                         text: LocalizableConstants.surveyViewStartSurvey, 
                         action: {})
}
