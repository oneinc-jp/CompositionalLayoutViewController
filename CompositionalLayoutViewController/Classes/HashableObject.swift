//
//  HashableObject.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/01/26.
//

import Foundation

open class HashableObject: Hashable {
    let identifier = UUID()

    public init() {}

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    public static func == (lhs: HashableObject, rhs: HashableObject) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
