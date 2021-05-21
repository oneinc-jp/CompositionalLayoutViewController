//
//  String+Validation.swift
//  CompositionalLayoutViewController_Example
//
//  Created by Akira Matsuda on 2021/05/21.
//

import Foundation

extension String {
    func isValidEmailAddress() -> Bool {
        let regularExpression = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return NSPredicate(format: "SELF MATCHES %@", regularExpression).evaluate(with: self)
    }
}
