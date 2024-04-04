//
//  ToastView.swift
//  Survey
//
//  Created by Cristian Serea on 03.04.2024.
//

import SwiftUI
import PreviewSnapshots

struct ToastView: View {
    let toast: Toast
    var onDismissTapped: (() -> Void)?
    var onRetryTapped: (() -> Void)?
    
    let toastHeight: CGFloat = 40
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(toast.title)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                if let message = toast.message {
                    Text(message)
                        .foregroundColor(Color(.systemGray5))
                        .padding(.top, GlobalConstants.Layout.marginOffset / 8)
                }
            }
            
            Spacer()
            
            if toast.toastStyle == .failure {
                Button(LocalizableConstants.toastViewRetry.uppercased()) {
                    onRetryTapped?()
                }
                .fontWeight(.semibold)
                .padding(.horizontal)
                .padding(.vertical, GlobalConstants.Layout.marginOffset / 2)
                .foregroundStyle(.white)
                .background(.accent)
                .clipShape(Capsule())
            }
        }
        .onTapGesture {
            onDismissTapped?()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(toast.toastStyle.color)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var dispatchWorkItem: DispatchWorkItem?
    var onDismiss: (() -> Void)?
    var onRetryTapped: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(toastViewOverlay())
            .onChange(of: toast) { _, newToast in
                showToast(toast: newToast)
            }
    }
    
    @ViewBuilder func toastViewOverlay() -> some View {
        if let toast = toast {
            VStack {
                ToastView(toast: toast, onDismissTapped: {
                    dismissToast()
                }, onRetryTapped: {
                    onRetryTapped?()
                    dismissToast()
                })
                Spacer()
            }.animation(.spring(), value: toast)
        }
    }
    
    private func showToast(toast: Toast?) {
        guard toast != nil else {
            return
        }
        
        dispatchWorkItem?.cancel()
        
        let task = DispatchWorkItem {
            dismissToast()
        }
        
        dispatchWorkItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + GlobalConstants.Toast.duration, execute: task)
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
            onDismiss?()
        }
        
        dispatchWorkItem?.cancel()
        dispatchWorkItem = nil
    }
}

extension View {
    func toastView(toast: Binding<Toast?>,
                   onDismiss: (() -> Void)? = nil,
                   onRetryTapped: (() -> Void)? = nil) -> some View {
        self.modifier(ToastModifier(toast: toast,
                                    onDismiss: onDismiss,
                                    onRetryTapped: onRetryTapped))
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        previewSnapshots.previews.previewLayout(.sizeThatFits)
    }
    
    static var previewSnapshots: PreviewSnapshots<Toast> {
        PreviewSnapshots(configurations: [
            .init(name: "ToastView failure", 
                  state: Toast(toastStyle: .failure, title: LocalizableConstants.questionsViewFailure)),
            .init(name: "ToastView success",
                  state: Toast(toastStyle: .success, title: LocalizableConstants.questionsViewSuccess))
        ], configure: { state in
            ToastView(toast: state)
        })
    }
}
