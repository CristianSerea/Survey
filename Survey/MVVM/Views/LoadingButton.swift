//
//  LoadingButton.swift
//  Survey
//
//  Created by Cristian Serea on 02.04.2024.
//

import SwiftUI
import PreviewSnapshots

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
                        .accessibilityIdentifier(IdentifierConstants.loadingButtonProgressView)
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

struct LoadingButton_Previews: PreviewProvider {
    static var previews: some View {
        previewSnapshots.previews.previewLayout(.sizeThatFits)
    }
    
    static var previewSnapshots: PreviewSnapshots<Bool> {
        PreviewSnapshots(configurations: [
            .init(name: "LoadingButton without loading visible", state: false),
            .init(name: "LoadingButton with loading visible", state: true)
        ], configure: { state in
            LoadingButton(isLoading: .constant(state), text: LocalizableConstants.surveyViewStartSurvey, action: {})
        })
    }
}
