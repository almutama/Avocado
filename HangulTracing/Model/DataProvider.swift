//
//  DataProvider.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 8..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

enum CellMode: Int {
  case normal
  case delete
}

class DataProvider: NSObject {
  private var parentVC: CardListVC!
  weak var cardManager: CardManager?
  var cellMode: CellMode = .normal
  private var audioPlayer = SoundPlayer()
  
  func setParentVC(vc: CardListVC) {
    self.parentVC = vc
  }
}

extension DataProvider: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let cardManager = cardManager else { fatalError() }
    return cardManager.toDoCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cardManager = cardManager else { fatalError() }
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCardCell", for: indexPath) as? WordCardCell {
      cell.configCell(card: cardManager.cardAt(index: indexPath.item), cellMode: cellMode)
      return cell
    } else {
      return WordCardCell()
    }
  }
}

extension DataProvider: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    audioPlayer.playSoundEffect(name: "open", extender: "wav")
    parentVC.presentCellVC(indexPath: indexPath)
  }
  
}

extension DataProvider: PinterestLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    guard let cardManager = cardManager else { fatalError() }
    let imgData =  cardManager.cardAt(index: indexPath.item).imgData
    guard let image = UIImage(data: imgData) else { return 0 }
    let ratio = image.size.width / image.size.height
    let leftRightInset: CGFloat = 20.0
    let cellPadding: CGFloat = 6.0
    let numberOfColumn: CGFloat = 2.0
    let cellWidth = (UIScreen.main.bounds.width - leftRightInset - cellPadding) / numberOfColumn
    
    return cellWidth / ratio
  }
}
