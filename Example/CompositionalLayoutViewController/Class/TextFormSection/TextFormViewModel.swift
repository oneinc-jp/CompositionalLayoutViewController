//
//  TextFormViewModel.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/05/19.
//

import Combine
import CompositionalLayoutViewController
import UIKit

class TextFormViewModel: Hashable {
    static func == (lhs: TextFormViewModel, rhs: TextFormViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }

    @Published var text: String?
    let textForm: TextForm
    var nextForm: TextFormViewModel?
    var previousForm: TextFormViewModel?
    private(set) var shuldFocuseSubject = PassthroughSubject<Void, Never>()

    init(initialText: String?, textForm: TextForm) {
        text = initialText
        self.textForm = textForm
    }

    @discardableResult
    func focuseNext() -> Bool {
        nextForm?.shuldFocuseSubject.send(())
        guard let form = nextForm else {
            return false
        }
        form.shuldFocuseSubject.send(())
        return true
    }

    @discardableResult
    func focusePrevious() -> Bool {
        guard let form = previousForm else {
            return false
        }
        form.shuldFocuseSubject.send(())
        return true
    }
}
