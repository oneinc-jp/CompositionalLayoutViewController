//
//  CollectionViewSection.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/01/03.
//

import UIKit

public protocol CollectionViewSection: HashableObject {
    var snapshotItems: [AnyHashable] { get }

    func registerCell(collectionView: UICollectionView)
    func registerSupplementaryView(collectionView: UICollectionView)
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
    func cell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell?
    func supplementaryView(_ collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView?
    func configureSupplementaryView(_ view: UICollectionReusableView, indexPath: IndexPath)
}

extension CollectionViewSection {
    var snapshotSection: AnyHashable {
        return self
    }
}
