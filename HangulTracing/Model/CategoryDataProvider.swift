//
//  CategoryDataProvider.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 18..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CategoryDataProvider: NSObject {
  private weak var parentVC: CategoryViewController!
  var categoryManager = CategoryManager.instance
  var cellMode: CellMode = .normal
  private let itemsPerRow: CGFloat = 2
  private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
  private var audioPlayer = SoundPlayer()
  
  func setParentVC(vc: CategoryViewController) {
    self.parentVC = vc
  }
}

extension CategoryDataProvider: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    audioPlayer.playSoundEffect(name: "enter", extender: "wav")
    parentVC.pushCardListVC(indexPath: indexPath)
  }
}

extension CategoryDataProvider: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = UIScreen.main.bounds.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
