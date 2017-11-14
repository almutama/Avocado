//
//  WordCardCell.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 8..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

protocol DeleteBtnDelegate: class {
  func deleteBtnTapped(sender: UIButton)
}

extension DeleteBtnDelegate {
  func deleteBtnTapped(sender: UIButton) {}
}

class WordCardCell: UICollectionViewCell {
  
  weak var deleteBtnDelegate: DeleteBtnDelegate?
  
  var imgView: UIImageView = {
    let imgView = UIImageView()
    imgView.contentMode = .scaleAspectFill
    return imgView
  }()
  var deleteBtn: UIButton = {
    let btn = UIButton()
    btn.setImage(UIImage(named: "delete"), for: .normal)
    return btn
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.layer.cornerRadius = 15
    contentView.layer.borderColor = UIColor(hex: "1EC545").cgColor
    contentView.layer.borderWidth = 1
    contentView.layer.masksToBounds = true
    contentView.addSubview(imgView)
    contentView.addSubview(deleteBtn)
    deleteBtn.isHidden = true
    deleteBtn.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)

    imgView.snp.makeConstraints { (make) in
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
  
  func configCell(card: WordCard, cellMode: CellMode) {
    
    if cellMode == .normal {
      deleteBtn.isHidden = true
    } else {
      deleteBtn.isHidden = false
    }
    imgView.image = UIImage(data: card.imgData)
  }
  
  @objc func deleteBtnTapped() {
    self.deleteBtnDelegate?.deleteBtnTapped(sender: deleteBtn)
  }
}

