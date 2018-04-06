//
//  CategoryCell.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 18..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

enum CellMode: Int {
  case normal
  case delete
}

class CategoryCell: UICollectionViewCell {
  static let reuseIdentifier = "CategoryCell"
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = label.font.withSize(50)
    label.baselineAdjustment = .alignCenters
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.1
    label.textColor = UIColor(hex: "65418F")
    return label
  }()
  private lazy var deleteBtn: UIButton = {
    let btn = UIButton()
    btn.setImage(UIImage(named: "delete"), for: .normal)
    return btn
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = UIColor(hex: "FED230")
    contentView.layer.cornerRadius = 15
    contentView.clipsToBounds = true
    contentView.addSubview(titleLabel)
    contentView.addSubview(deleteBtn)
    deleteBtn.isHidden = true
    
    titleLabel.snp.makeConstraints { (make) in
      make.edges.equalTo(contentView)
    }
    
    deleteBtn.snp.makeConstraints { (make) in
      make.left.top.equalTo(contentView)
      make.width.height.equalTo(40)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configCell(category: Category, cellMode: CellMode, action: CocoaAction) {
    deleteBtn.rx.action = action
    
    if cellMode == .normal {
      deleteBtn.isHidden = true
    } else {
      deleteBtn.isHidden = false
      wiggle()
    }
    titleLabel.text = category.title
  }
  
}
