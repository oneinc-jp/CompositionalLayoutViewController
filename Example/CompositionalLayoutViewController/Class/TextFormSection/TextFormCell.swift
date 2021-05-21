//
//  TextFormCell.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/05/19.
//

import Combine
import Reusable
import UIKit

class TextFormCell: UICollectionViewCell, NibReusable {
    static let defaultHeight: CGFloat = 49

    @IBOutlet private var textField: UITextField!
    private var cancellable = Set<AnyCancellable>()
    private var shouldValidate = false

    var isSecureTextEntry: Bool {
        get {
            return textField.isSecureTextEntry
        }
        set {
            textField.isSecureTextEntry = newValue
        }
    }

    @Published var text: String? {
        didSet {
            textField.text = text
        }
    }

    var viewModel: TextFormViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            cancellable.removeAll()
            textField.text = viewModel.text
            textField.isSecureTextEntry = viewModel.textForm.isSecureTextEntry
            textField.placeholder = viewModel.textForm.placeholder
            textField.keyboardType = viewModel.textForm.keyboardType
            textField.spellCheckingType = viewModel.textForm.spellCheckingType
            textField.autocorrectionType = viewModel.textForm.autocorrectionType
            textField.autocapitalizationType = viewModel.textForm.autocapitalizationType
            if let contentType = viewModel.textForm.contentType {
                textField.textContentType = contentType
            }
            viewModel.shuldFocuseSubject.sink { [weak self] _ in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.textField.becomeFirstResponder()
            }.store(in: &cancellable)
            NotificationCenter.default.publisher(
                for: UITextField.textDidChangeNotification,
                object: textField
            ).sink { [weak self] _ in
                guard let weakSelf = self, let viewModel = weakSelf.viewModel else {
                    return
                }
                if weakSelf.shouldValidate,
                   let handler = viewModel.textForm.validationHandler,
                   handler(weakSelf.textField.text) == false {
                    weakSelf.textField.textColor = viewModel.textForm.validationAppearance.textColor
                }
                else {
                    weakSelf.textField.textColor = .darkText
                }
                viewModel.text = weakSelf.textField.text
            }.store(in: &cancellable)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
        layer.cornerRadius = 7
    }

    @discardableResult
    func focuse() -> Bool {
        return textField.becomeFirstResponder()
    }

    @discardableResult
    func resign() -> Bool {
        return textField.resignFirstResponder()
    }
}

extension TextFormCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldValidate = true
        if let viewModel = viewModel,
           let handler = viewModel.textForm.validationHandler,
           handler(textField.text) == false {
            textField.textColor = viewModel.textForm.validationAppearance.textColor
        }
        else {
            textField.textColor = .darkText
        }
        if viewModel?.focuseNext() == false {
            resign()
        }
        return true
    }
}
