//
//  SupplementaryItem.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/08/14.
//

import UIKit

public protocol SupplementaryItem {
    static var elementKind: String { get }

    static func supplementaryItem(absoluteOffset: CGPoint) -> NSCollectionLayoutBoundarySupplementaryItem
}
