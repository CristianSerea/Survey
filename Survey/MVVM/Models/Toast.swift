//
//  Toast.swift
//  Survey
//
//  Created by Cristian Serea on 03.04.2024.
//

import Foundation

struct Toast: Equatable {
    var toastStyle: ToastStyle
    var title: String
    var message: String?
    var duration: Double = GlobalConstants.Toast.duration
}
