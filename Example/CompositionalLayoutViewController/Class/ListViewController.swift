//
//  ListViewController.swift
//  CompositionalLayoutViewController_Example
//
//  Created by Akira Matsuda on 2021/10/12.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import CompositionalLayoutViewController

struct ListItem: Hashable {
    let title: String?
    private let identifier = UUID()
}

class ListViewController: CompositionalLayoutViewController, SectionProvider {
    var sections = [CollectionViewSection]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset.top = 32
        provider = self

        sections = [
            ListSection<ListItem>(
                items: [
                    ListItem(title: "a"),
                    ListItem(title: "b"),
                    ListItem(title: "c")
                ]
            ) { cell, item in
                var content = cell.defaultContentConfiguration()
                content.text = item.title
                return content
            }
        ]
        reloadSections()
    }

    override func layoutConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 17
        return config
    }

    override func didSelectItem(at indexPath: IndexPath) {
        print(sections[indexPath.section].snapshotItems[indexPath.row])
    }
}
