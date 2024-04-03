//
//  GlobalConstants.swift
//  Survey
//
//  Created by Cristian Serea on 02.04.2024.
//

import Foundation

struct GlobalConstants {
    struct Server {
        static let domain = "https://xm-assignment.web.app"
        static let fetchQuestions = "/questions"
        static let submitQuestion = "/question/submit"
    }
    
    struct Layout {
        static let marginOffset: CGFloat = 16
        static let defaultHeight: CGFloat = 48
    }
    
    struct Toast {
        static let duration: CGFloat = 2
    }
}

