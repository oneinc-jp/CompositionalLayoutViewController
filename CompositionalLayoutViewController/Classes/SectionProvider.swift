//
//  SectionProvider.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/05/22.
//

import Foundation

public protocol SectionProvider: AnyObject {
    var sections: [CollectionViewSection] { get }

    func section(for sectionIndex: Int) -> CollectionViewSection
}

extension SectionProvider {
    public func section(for sectionIndex: Int) -> CollectionViewSection {
        return sections[sectionIndex]
    }
}
