//
//  ButtonCell.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/05/16.
//

import Reusable
import UIKit

protocol ButtonCellDelegate: AnyObject {
    func didButtonPress()
}

class ButtonCell: UICollectionViewCell, NibReusable {
    static let defaultHeight: CGFloat = 55

    @IBOutlet private var button: UIButton!
    weak var delegate: ButtonCellDelegate?
    var title: String? {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }

    var buttonBackgroundColor: UIColor? {
        get {
            return button.backgroundColor
        }
        set {
            button.backgroundColor = newValue
        }
    }

    var buttonTitleFont: UIFont? {
        get {
            return button.titleLabel?.font
        }
        set {
            button.titleLabel?.font = newValue
        }
    }

    var isEnabled = true {
        didSet {
            button.isEnabled = isEnabled
            button.alpha = isEnabled ? 1 : 0.4
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        button.layer.cornerRadius = 7
    }

    func setTitleColor(_ color: UIColor?, for state: UIButton.State) {
        button.setTitleColor(color, for: state)
    }

    @IBAction private func buttonPressed(_ sender: Any) {
        delegate?.didButtonPress()
    }
}
