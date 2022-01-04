//
//  CollectionViewSection.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/01/03.
//

import UIKit

public protocol CollectionViewSection {
    var snapshotItems: [AnyHashable] { get }

    func registerCell(collectionView: UICollectionView)
    func registerSupplementaryView(collectionView: UICollectionView)
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
    func cell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell?
    func supplementaryView(_ collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView?
    func configureSupplementaryView(_ view: UICollectionReusableView, indexPath: IndexPath)

    func makeUnique()
}

public extension CollectionViewSection {
    var nonce: String? {
        var nonceKey: UInt8 = 0
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
        if let nonce = nonce {
            hasher.combine(nonce)
        }
        return hasher.finalize()
    }

    func makeUnique() {
        var nonceKey: UInt8 = 0
        objc_setAssociatedObject(
            self,
            &nonceKey,
            UUID().uuidString,
            .OBJC_ASSOCIATION_RETAIN
        )
    }
}
