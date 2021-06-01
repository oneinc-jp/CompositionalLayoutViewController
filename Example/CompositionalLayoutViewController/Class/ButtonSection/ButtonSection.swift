//
//  MyAccountLogOutButtonSection.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/05/16.
//

import Combine
import CompositionalLayoutViewController
import UIKit

class ButtonSection: HashableObject, CollectionViewSection {
    struct Appearance {
        let backgroundColor: UIColor?
        let titleColor: UIColor?
        let font: UIFont?
    }

    enum Action {
        case handler(() -> Void)
    }

    private var cancellable = Set<AnyCancellable>()

    var snapshotItems: [AnyHashable] {
        return [buttonTitle]
    }

    var buttonTitle: String
    var appearance: Appearance?
    var action: Action
    @Published var isEnabled = true

    init(buttonTitle: String, appearance: Appearance? = nil, action: Action) {
        self.buttonTitle = buttonTitle
        self.appearance = appearance
        self.action = action
    }

    func registerCell(collectionView: UICollectionView) {
        collectionView.register(cellType: ButtonCell.self)
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
            heightDimension: .absolute(ButtonCell.defaultHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 0,
            leading: 23,
            bottom: 0,
            trailing: 23
        )
        return section
    }

    func configuredCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        cancellable.removeAll()
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ButtonCell.self)
        cell.title = buttonTitle
        if let appearance = appearance {
            cell.setTitleColor(appearance.titleColor, for: .normal)
            cell.buttonBackgroundColor = appearance.backgroundColor
            cell.buttonTitleFont = appearance.font
        }
        cell.delegate = self
        $isEnabled.sink { enabled in
            cell.isEnabled = enabled
        }.store(in: &cancellable)
        return cell
    }

    func supplementaryView(_ collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        return nil
    }

    func configureSupplementaryView(_ view: UICollectionReusableView, indexPath: IndexPath) {}
}

extension ButtonSection: ButtonCellDelegate {
    func didButtonPress() {
        switch action {
        case let .handler(handler):
            handler()
        }
    }
}
