//
//  TwoColumnLayoutDelegate.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 21/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

// Delegate for the size of the image
protocol TwoColumnLayoutDelegate: class {
  func collectionView(_ collectionView:UICollectionView, imgSize indexPath:IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
  weak var delegate: TwoColumnLayoutDelegate!
  
  fileprivate var numberOfColumns = 2
  fileprivate var cellPadding: CGFloat = 6
  
  fileprivate var cache = [UICollectionViewLayoutAttributes]()
  fileprivate var cacheNumberItems = 0
  
  fileprivate var contentHeight: CGFloat = 0
  
  fileprivate var contentWidth: CGFloat {
    guard let collectionView = collectionView else { return 0 }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func prepare() {
    guard let collectionView = collectionView, cacheNumberItems != collectionView.numberOfItems(inSection: 0) else { return }
    // Pre-Calcuate the X Offset for every column, add an array to increment the max Y Offset for each column
    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    var xOffset = [CGFloat]()
    for column in 0 ..< numberOfColumns {
      xOffset.append(CGFloat(column) * columnWidth)
    }
    var column = 0
    var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
    
    // Iterate through the list of items in the first section
    for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
      
      let indexPath = IndexPath(item: item, section: 0)
      
      // Calculate the cell frame using the height from the delegate
      let photoHeight = delegate.collectionView(collectionView, imgSize: indexPath)
      let height = cellPadding * 2 + photoHeight
      let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
      
      // Create an UICollectionViewLayoutItem and add to the cache
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)
      
      // Update the collectionView content height
      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] = yOffset[column] + height
      
      column = column < (numberOfColumns - 1) ? (column + 1) : 0
    }
    
    cacheNumberItems = collectionView.numberOfItems(inSection: 0)
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
    var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    // Get the rect details from the cache
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    return visibleLayoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
  
}
