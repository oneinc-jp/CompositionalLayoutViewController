//
//  TextFormSection.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/05/19.
//

import Combine
import CompositionalLayoutViewController
import Reusable
import UIKit

extension Array where Element == TextFormViewModel {
    func link() {
        var iterator = makeIterator()
        var current: TextFormViewModel? = iterator.next()
        var previous: TextFormViewModel?
        while let next = iterator.next() {
            current?.previousForm = previous
            current?.nextForm = next
            previous = current
            current = next
        }
    }
}

extension TextFormSection {
    static func form(_ forms: [TextFormViewModel]) -> TextFormSection {
        return .init(
            items: forms
        )
    }
}

class TextFormSection: CollectionViewSection {
    var snapshotSection: AnyHashable {
        var hasher = Hasher()
        items.forEach {
            hasher.combine($0)
        }
        return hasher.finalize()
    }
    
    var snapshotItems: [AnyHashable] {
        return items
    }

    let items: [TextFormViewModel]

    init(items: [TextFormViewModel]) {
        self.items = items
        self.items.link()
    }

    func registerCell(collectionView: UICollectionView) {
        collectionView.register(cellType: TextFormCell.self)
    }

    func registerSupplementaryView(collectionView: UICollectionView) {}

    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(TextFormCell.defaultHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = .init(
            top: 0,
            leading: 23,
            bottom: 0,
            trailing: 23
        )
        return section
    }

    func cell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TextFormCell.self)
        cell.viewModel = items[indexPath.row]
        return cell
    }

    func supplementaryView(_ collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        return nil
    }

    func configureSupplementaryView(_ view: UICollectionReusableView, indexPath: IndexPath) {}
}
