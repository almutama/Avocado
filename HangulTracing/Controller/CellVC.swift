//
//  CellVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 17..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CellVC: UIViewController {
  private var viewFrame: CGRect!
  private weak var cardListVC: CardListVC?
  private var didSetupConstraints = false
  private var cardManager = CardManager.instance
  lazy var imgView: UIImageView = {
    let imgView = UIImageView()
    imgView.contentMode = .scaleAspectFill
    imgView.layer.cornerRadius = 15
    imgView.clipsToBounds = true
    return imgView
  }()
  private var audioPlayer = SoundPlayer()
  private lazy var backView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 15
    view.clipsToBounds = true
    view.backgroundColor = UIColor(hex: "FED230")
    return view
  }()
  private var isBackViewShowing = false
  private lazy var wordLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = label.font.withSize(50)
    label.baselineAdjustment = .alignCenters
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.1
    label.textColor = UIColor(hex: "65418F")
    return label
  }()
  private lazy var tracingBtn: UIButton = {
    let btn = UIButton()
    btn.layer.cornerRadius = 15
    btn.setImage(UIImage(named: "tracing"), for: .normal)
    return btn
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.clear
    view.addSubview(imgView)
    view.addSubview(backView)
    
    tracingBtn.addTarget(self, action: #selector(CellVC.tracingBtnTapped(_:)), for: .touchUpInside)
    backView.addSubview(wordLabel)
    let dismissTap = UITapGestureRecognizer(target: self, action: #selector(CellVC.wordLBLTapped))
    wordLabel.addGestureRecognizer(dismissTap)
    wordLabel.isUserInteractionEnabled = true
    backView.addSubview(tracingBtn)
    backView.isHidden = true
    
    view.setNeedsUpdateConstraints()
  }
  
  init(viewFrame: CGRect) {
    self.viewFrame = viewFrame
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setParentVC(vc: CardListVC) {
    self.cardListVC = vc
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      imgView.frame = viewFrame
      backView.frame = viewFrame
      wordLabel.snp.makeConstraints({ (make) in
        make.edges.equalTo(backView)
      })
      tracingBtn.snp.makeConstraints { (make) in
        make.top.right.equalTo(backView)
        make.width.height.equalTo(50)
      }
      
      
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  func flip(completion: @escaping (_ Success: Bool) -> ()) {
    if isBackViewShowing {
      
      UIView.transition(from: backView,
                        to: imgView,
                        duration: 1.0,
                        options: [.transitionFlipFromLeft, .showHideTransitionViews],
                        completion:{ (success) in
                          completion(true)
      })
    } else {
      
      UIView.transition(from: imgView,
                        to: backView,
                        duration: 1.0,
                        options: [.transitionFlipFromRight, .showHideTransitionViews],
                        completion: { (success) in
                          self.animateTracingBtn()
                          completion(true)
      })
    }
    isBackViewShowing = !isBackViewShowing
  }
  
  func configView(card: WordCard) {
    wordLabel.text = card.word
    imgView.image = UIImage(data: card.imgData)
  }
  
  @objc func wordLBLTapped() {
    flip { (success) in
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  @objc func tracingBtnTapped(_ sender: UIButton) {
    guard let cardListVC = cardListVC else { return }
    cardListVC.startSpinner()
    audioPlayer.playSoundEffect(name: "writing", extender: "mp3")
    
    dismiss(animated: true) {
      cardListVC.selectedCell?.isHidden = false
      cardListVC.stopSpinner()
      cardListVC.pushTracingVC()
    }
    
  }
  
  func animateTracingBtn() {
    tracingBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.2,
                   initialSpringVelocity: 6.0, options: .allowUserInteraction,
                   animations: { [weak self] in
                    self?.tracingBtn.transform = .identity
                  }, completion: { (finished) in
                      self.animateTracingBtn()
                  })
  }
  
}
