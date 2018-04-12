//
//  WordCardCell.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 8..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class WordCardCell: UICollectionViewCell {
  
  static let reuseIdentifier = "WordCardCell"
  lazy var imgView: UIImageView = {
    let imgView = UIImageView()
    imgView.contentMode = .scaleAspectFill
    return imgView
  }()
  private lazy var deleteBtn: UIButton = {
    let btn = UIButton()
    btn.setImage(UIImage(named: "delete"), for: .normal)
    return btn
  }()
  
  func setupSubviews() {
    contentView.layer.cornerRadius = 15
    contentView.clipsToBounds = true
    contentView.addSubview(imgView)
    contentView.addSubview(deleteBtn)
    deleteBtn.isHidden = true
    
    imgView.snp.makeConstraints { (make) in
      make.edges.equalTo(contentView)
    }
    deleteBtn.snp.makeConstraints { (make) in
      make.left.top.equalTo(contentView)
      make.width.height.equalTo(40)
    }
  }
  
  func configCell(card: WordCard, cellMode: CellMode, action: CocoaAction) {
    setupSubviews()
    deleteBtn.rx.action = action
    
    if cellMode == .normal {
      deleteBtn.isHidden = true
    } else {
      deleteBtn.isHidden = false
    }
    imgView.image = UIImage(data: card.imgData)
  }
}

