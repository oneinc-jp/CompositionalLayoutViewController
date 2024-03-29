//
//  CollectionViewSection.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/01/03.
//

import UIKit

public protocol CollectionViewSection {
    var identifier: String { get }
    var snapshotItems: [AnyHashable] { get }

    func registerCell(collectionView: UICollectionView)
    func registerSupplementaryView(collectionView: UICollectionView)
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
    func cell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell?
    func supplementaryView(_ collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView?
    func configureSupplementaryView(_ view: UICollectionReusableView, indexPath: IndexPath)

    func makeUnique(nonce: String)
}

var nonceKey: UInt8 = 0
public extension CollectionViewSection {
    var nonce: String? {
        guard let associatedObject = objc_getAssociatedObject(
            self,
            &nonceKey
        ) as? String else {
            return nil
        }
        return associatedObject
    }

    var snapshotSection: AnyHashable {
        var hasher = Hasher()
        snapshotItems.forEach {
            hasher.combine($0)
        }
        hasher.combine(nonce)
        hasher.combine(identifier)
        return hasher.finalize()
    }

    func makeUnique(nonce: String = UUID().uuidString) {
        objc_setAssociatedObject(
            self,
            &nonceKey,
            nonce,
            .OBJC_ASSOCIATION_RETAIN
        )
    }
}
