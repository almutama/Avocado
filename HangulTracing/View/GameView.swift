//
//  GameView.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 11..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class GameView: UIView {
  
  private var words: String
  private lazy var wordLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = label.font.withSize(100)
    label.baselineAdjustment = .alignCenters
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.1
    label.textColor = UIColor.white
    return label
  }()
  
  init(frame: CGRect, word: String) {
    self.words = word
    super.init(frame: frame)
    
    backgroundColor = UIColor(patternImage: UIImage(named: "blackBoard")!)
    wordLabel.text = words
    addSubview(wordLabel)
    
    wordLabel.snp.makeConstraints { (make) in
      make.left.top.equalTo(self).offset(50)
      make.bottom.right.equalTo(self).offset(-50)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setWords(words: String) {
    wordLabel.text = words
  }
  
}
