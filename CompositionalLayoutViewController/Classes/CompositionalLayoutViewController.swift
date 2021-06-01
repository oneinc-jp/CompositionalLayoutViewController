//
//  CompositionalLayoutViewController.swift
//  CompositionalLayoutViewController
//
//  Created by Akira Matsuda on 2021/01/23.
//

import UIKit

open class CompositionalLayoutViewController: UIViewController {
    public var collectionView: UICollectionView!
    public var highlightedColor: UIColor?
    public var dataSource: UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>!
    public weak var provider: SectionProvider?

    override open func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [unowned self] sectionIndex, environment -> NSCollectionLayoutSection? in
            let section = provider?.section(for: sectionIndex)
            let layout = section?.layoutSection(environment: environment)
            configureSection(section, layout: layout)
            return layout
        }, configuration: layoutConfiguration())
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.delaysContentTouches = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        dataSource = UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>(
            collectionView: collectionView
        ) { [unowned self] _, indexPath, _ -> UICollectionViewCell? in
            let section = provider?.section(for: indexPath.section)
            let cell = section?.configuredCell(collectionView, indexPath: indexPath)
            configureCell(cell)
            return cell
        }
        dataSource.supplementaryViewProvider = { [unowned self] _, kind, indexPath in
            guard let section = provider?.section(for: indexPath.section) else {
                return nil
            }
            let view = section.supplementaryView(
                collectionView,
                kind: kind,
                indexPath: indexPath
            )
            if let view = view {
                section.configureSupplementaryView(view, indexPath: indexPath)
            }
            return view
        }
    }

    open func layoutConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
        return UICollectionViewCompositionalLayoutConfiguration()
    }
    
    open func configureCell(_ cell: UICollectionViewCell?) {}

    open func configureSection(_ section: CollectionViewSection?, layout: NSCollectionLayoutSection?) {}

    open func registerViews(_ sections: [CollectionViewSection]) {
        for section in sections {
            section.registerCell(collectionView: collectionView)
            section.registerSupplementaryView(collectionView: collectionView)
        }
    }

    open func updateDataSource(_ sections: [CollectionViewSection]) {
        registerViews(sections)
        var snapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>()
        for section in sections {
            snapshot.appendSections([section.snapshotSection])
            snapshot.appendItems(section.snapshotItems, toSection: section.snapshotSection)
        }
        dataSource.apply(snapshot)
    }

    open func reloadSections() {
        guard let provider = provider else {
            return
        }
        updateDataSource(provider.sections)
    }

    open func didSelectItem(at indexPath: IndexPath) {}
}

extension CompositionalLayoutViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem(at: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? HighlightableCell, cell.clvc_isHighlightable {
            cell.contentView.backgroundColor = highlightedColor
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? HighlightableCell, cell.clvc_isHighlightable {
            cell.contentView.backgroundColor = nil
        }
    }
}
