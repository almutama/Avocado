//
//  CategoryDataProvider.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 18..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CategoryDataProvider: NSObject {
  private(set) var parentVC: CategoryVC!
  var categoryManager: CategoryManager?
  var cellMode: CellMode = .normal
  let itemsPerRow: CGFloat = 3
  let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
  var audioPlayer = SoundPlayer()
  
  func setParentVC(vc: CategoryVC) {
    self.parentVC = vc
  }
}

extension CategoryDataProvider: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let categoryManager = categoryManager else { fatalError() }
    return categoryManager.categories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let categoryManager = categoryManager else { fatalError() }
    let category = categoryManager.categories[indexPath.item]
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell {
      cell.configCell(category: category, cellMode: cellMode)
      cell.deleteBtnDelegate = parentVC
      return cell
    }
    return CategoryCell()
  }
}

extension CategoryDataProvider: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let categoryManager = categoryManager else { fatalError() }
    audioPlayer.playSoundEffect(name: "enter", extender: "wav")
    let category = categoryManager.categories[indexPath.item]
    let cardListVC = CardListVC()
    cardListVC.setCategoryAndManager(category: category, manager: CardManager(categoryTitle: category.title))
    parentVC.navigationController?.pushViewController(cardListVC, animated: true)
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
