//
//  asdasd.swift
//  Bonial
//
//  Created by Fernando Cani on 08/07/2024.
//

import UIKit

class CustomNewsLayout: UICollectionViewFlowLayout {
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    
    private let cellHeight: CGFloat = 280
    private let sectionInsets: CGFloat = 10
    private let fullWidthItemInterval = 7
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        self.cache.removeAll()
        self.contentHeight = 0
        
        let insets = collectionView.adjustedContentInset
        let availableWidth = collectionView.bounds.width - insets.left - insets.right - sectionInset.left - sectionInset.right
        
        let numberOfColumns = collectionView.bounds.width > collectionView.bounds.height ? 3 : 2
        let totalSpacing = minimumInteritemSpacing * CGFloat(numberOfColumns - 1)
        let cellWidth = (availableWidth - totalSpacing) / CGFloat(numberOfColumns)
        
        self.itemSize = CGSize(width: cellWidth, height: self.cellHeight)
        self.sectionInset = UIEdgeInsets(top: self.sectionInsets, left: self.sectionInsets, bottom: self.sectionInsets, right: self.sectionInsets)
        self.minimumInteritemSpacing = self.sectionInsets
        self.minimumLineSpacing = self.sectionInsets
        
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(sectionInset.left + CGFloat(column) * (cellWidth + minimumInteritemSpacing))
        }
        
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: sectionInset.top, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            if item % self.fullWidthItemInterval == 0 {
                // Full-width item
                let frame = CGRect(x: sectionInset.left, y: yOffset[column], width: availableWidth, height: self.cellHeight)
                attributes.frame = frame
                self.contentHeight = max(self.contentHeight, frame.maxY)
                yOffset = .init(repeating: frame.maxY + minimumLineSpacing, count: numberOfColumns)
            } else {
                // Regular item
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: cellWidth, height: self.cellHeight)
                attributes.frame = frame
                self.contentHeight = max(self.contentHeight, frame.maxY)
                yOffset[column] += self.cellHeight + minimumLineSpacing
                column = (column + 1) % numberOfColumns
            }
            self.cache.append(attributes)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.bounds.width, height: self.contentHeight + sectionInset.bottom)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.cache.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cache[indexPath.item]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
