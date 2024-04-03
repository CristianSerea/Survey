//
//  String+Extension.swift
//  Survey
//
//  Created by Cristian Serea on 03.04.2024.
//

import Foundation

extension String {
    var localizable: String {
        guard let bundle = getBundle() else {
            return self
        }

        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }

    func getBundle() -> Bundle? {
        guard let path = Bundle.main.path(forResource: "en", ofType: "lproj") else {
            return nil
        }

        return Bundle(path: path)
    }
}
