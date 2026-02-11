//
//  Grid3ItemsCollection.swift
//  StocksSnapKit
//
//  Created by Aziz Bibitov on 17/01/2026.
//

import UIKit

fileprivate let collectionView: UICollectionView = {
   

    let sectionHorizontalInset: CGFloat = 2
    let itemSpacing: CGFloat = 1
    let numberOfColumns: CGFloat = 3

    let availableWidth = UIScreen.main.bounds.width - sectionHorizontalInset * 2 - itemSpacing * (numberOfColumns - 1)

    let itemWidth = availableWidth / numberOfColumns

    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    layout.minimumLineSpacing = itemSpacing
    layout.minimumInteritemSpacing = itemSpacing
    layout.sectionInset = UIEdgeInsets(
        top: 0,
        left: sectionHorizontalInset,
        bottom: 0,
        right: sectionHorizontalInset
    )

    return UICollectionView(frame: .zero, collectionViewLayout: layout)
}()
