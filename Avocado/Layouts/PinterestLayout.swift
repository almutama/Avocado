//
//  PinterestLayout.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 8..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate: class {
  //사진높이
  func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
  weak var delegate: PinterestLayoutDelegate!
  fileprivate var numberOfColumns = 2
  fileprivate var cellPadding: CGFloat = 6
  fileprivate var cache = [UICollectionViewLayoutAttributes]()
  fileprivate var contentHeight: CGFloat = 0
  fileprivate var contentWidth: CGFloat {
    guard let collectionView = collectionView else { return 0 }
    let insets = collectionView.contentInset
    collectionView.frame = UIScreen.main.bounds
    return collectionView.bounds.width - (insets.left + insets.right)
  }
  
  //셀 사이즈
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func prepare() {
    
    cache = []
    contentHeight = 0
    guard let collectionView = collectionView else { return }

    //셀의 x 위치
    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    var xOffset = [CGFloat]()
    for column in 0 ..< numberOfColumns {
      xOffset.append(CGFloat(column) * columnWidth)
    }
    var column = 0
    var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)

    //셀의 사진 높이 받아서 프레임 설정
    for item in 0 ..< collectionView.numberOfItems(inSection: 0) {

      let indexPath = IndexPath(item: item, section: 0)
      let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
      let height = cellPadding * 2 + photoHeight
      let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

      //캐시에 프레임값 담기
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)

      //셀 높이 업데이트, 셀의 y위치
      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] = yOffset[column] + height

      column = column < (numberOfColumns - 1) ? (column + 1) : 0
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
    var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
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
