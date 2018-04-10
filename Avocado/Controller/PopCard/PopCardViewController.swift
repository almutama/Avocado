//
//  PopCardViewController.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 17..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PopCardViewController: UIViewController, BindableType {
  private let bag = DisposeBag()
  var viewModel: PopCardViewModel!
  private var viewFrame: CGRect!
  lazy var imgView: UIImageView = {
    let imgView = UIImageView()
    imgView.contentMode = .scaleAspectFill
    imgView.layer.cornerRadius = 15
    imgView.clipsToBounds = true
    return imgView
  }()
  private lazy var backView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 15
    view.clipsToBounds = true
    view.backgroundColor = UIColor(hex: "FED230")
    view.isHidden = true
    return view
  }()
  private lazy var wordLabel: UILabel = {
    let label = UILabel()
    label.isUserInteractionEnabled = true
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
  private lazy var deleteBtn: UIButton = {
    let btn = UIButton()
    btn.setImage(UIImage(named: "delete"), for: .normal)
    return btn
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.clear
    view.addSubview(imgView)
    view.addSubview(backView)
    backView.addSubview(wordLabel)
    backView.addSubview(tracingBtn)
    backView.addSubview(deleteBtn)
    
    imgView.frame = viewFrame
    backView.frame = viewFrame
    wordLabel.snp.makeConstraints({ (make) in
      make.edges.equalTo(backView)
    })
    tracingBtn.snp.makeConstraints { (make) in
      make.top.right.equalTo(backView)
      make.width.height.equalTo(50)
    }
    deleteBtn.snp.makeConstraints { (make) in
      make.top.left.equalTo(backView)
      make.width.height.equalTo(50)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    flip(toImageView: false) { (success) in
    }
  }
  
  init(viewFrame: CGRect) {
    self.viewFrame = viewFrame
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bindViewModel() {
    wordLabel.text = viewModel.selectedCard.word
    imgView.image = UIImage(data: viewModel.selectedCard.imgData)
    
    tracingBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.audioPlayer.playSoundEffect(name: "writing", extender: "mp3")
        self.viewModel.goToTracingScene()
      })
      .disposed(by: bag)
    
    deleteBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [unowned self] _ in
        self.flip(toImageView: true, completion: { bool in
          if bool {
            self.viewModel.dismissView()
          }
        })
      })
      .disposed(by: bag)
  }
  
  func flip(toImageView: Bool, completion: @escaping (_ Success: Bool) -> ()) {
    if toImageView {
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
