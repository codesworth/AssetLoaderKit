//
//  PinCellsLayoutView.swift
//  ExampleApp
//
//  Created by Shadrach Mensah on 02/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import UIKit


protocol PinCellsLayoutDelegate:class {
    func
        heightForItem(at indexPath: IndexPath, for width:CGFloat) -> CGFloat
}

class PinCellsLayout:UICollectionViewLayout{
    
    
    
    weak var delegate:PinCellsLayoutDelegate?
    
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 0
    
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {return 0}
        
        
        return collectionView.bounds.width
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
    }
    
    
    override var collectionViewContentSize: CGSize{
        return CGSize(width: contentWidth, height: contentHeight)
        
    }
    
    override func prepare() {
        let totalItems = collectionView?.numberOfItems(inSection: 0) ?? 0
        guard let collectionView = collectionView, cache.count < totalItems  else {return}
        let startIndex = cache.isEmpty ? 0 : cache.count
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        var xOffset: [CGFloat] = []
        
        for column in 0..<numberOfColumns{
            xOffset.append(CGFloat(column) * columnWidth)
            
        }
        
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in startIndex..<collectionView.numberOfItems(inSection: 0){
            let indexPath = IndexPath(row: item, section: 0)
            
            let photoHeight = delegate?.heightForItem(at: indexPath, for: columnWidth) ?? 120
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = insetFrame
            cache.append(attribute)
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
        
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes()
        attribute.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        attribute.alpha = 0
        return attribute
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attr in cache{
            if attr.frame.intersects(rect){
                visibleLayoutAttributes.append(attr)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let collectionView = collectionView{
            return collectionView.frame.height != newBounds.height
        }
        return false
    }
    
}
