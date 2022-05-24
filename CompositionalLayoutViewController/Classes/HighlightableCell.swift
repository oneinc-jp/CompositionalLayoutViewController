//
//  HighlightableCell.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/01/06.
//

import UIKit

public protocol HighlightableCell where Self: UICollectionViewCell {
    var clvc_isHighlightable: Bool { get }
    var clvc_highlightedColor: UIColor? { get }
    var clvc_defaultColor: UIColor? { get }
}

public extension HighlightableCell {
    var clvc_defaultColor: UIColor? {
        return nil
    }
}
