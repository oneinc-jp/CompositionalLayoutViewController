//
//  HashableObject.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/01/26.
//

import Foundation

open class HashableObject: NSObject {
    let identifier = UUID()

    open func isEqual(_ object: HashableObject?) -> Bool {
        return identifier == object?.identifier
    }
}
