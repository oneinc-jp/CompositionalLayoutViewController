//
//  TextForm.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/05/19.
//

import UIKit

struct TextForm {
    struct ValidationAppearance {
        let textColor: UIColor
    }

    var placeholder: String?
    var isSecureTextEntry = false
    var keyboardType: UIKeyboardType = .default
    var spellCheckingType: UITextSpellCheckingType = .default
    var autocorrectionType: UITextAutocorrectionType = .default
    var autocapitalizationType: UITextAutocapitalizationType = .sentences
    var contentType: UITextContentType?
    var validationHandler: ((String?) -> Bool)?
    var validationAppearance: ValidationAppearance = .init(textColor: .systemRed)
}
