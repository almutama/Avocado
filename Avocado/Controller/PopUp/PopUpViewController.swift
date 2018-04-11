//
//  PopUpViewController.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 24..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Action

class PopUpViewController: UIViewController, BindableType {
  var viewModel: PopUpViewModel!
  private let bag = DisposeBag()
  private lazy var hideBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = UIColor.white
    btn.layer.cornerRadius = 35
    btn.setImage(UIImage(named: "hideBtn"), for: .normal)
    return btn
  }()
  private lazy var deleteCardBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = UIColor(hex: "5F9EF2")
    btn.layer.cornerRadius = 25
    btn.setImage(UIImage(named: "trash"), for: .normal)
    btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    return btn
  }()
  private lazy var deleteCardLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = label.font.withSize(50)
    label.baselineAdjustment = .alignCenters
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.1
    label.textColor = UIColor.white
    label.isHidden = true
    label.text = "카테고리 삭제"
    return label
  }()
  private lazy var addCardBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = UIColor(hex: "5F9EF2")
    btn.layer.cornerRadius = 25
    btn.setImage(UIImage(named: "addCard"), for: .normal)
    btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    return btn
  }()
  private lazy var addCardLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = label.font.withSize(50)
    label.baselineAdjustment = .alignCenters
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.1
    label.textColor = UIColor.white
    label.text = "카테고리 추가"
    label.isHidden = true
    return label
  }()
  private lazy var gameBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = UIColor(hex: "5F9EF2")
    btn.layer.cornerRadius = 25
    btn.setImage(UIImage(named: "game"), for: .normal)
    btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    return btn
  }()
  private lazy var gameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = label.font.withSize(50)
    label.baselineAdjustment = .alignCenters
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.1
    label.textColor = UIColor.white
    label.text = "스피드퀴즈"
    label.isHidden = true
    return label
  }()
  private lazy var popUpView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 15
    view.backgroundColor = UIColor(hex: "1EBBBC")
    view.isHidden = true
    return view
  }()
  private lazy var categoryTxtField: UITextField = {
    let txtField = UITextField()
    txtField.backgroundColor = UIColor.white
    txtField.keyboardAppearance = .dark
    txtField.keyboardType = .default
    txtField.autocorrectionType = .default
    txtField.placeholder = "새 카테고리 입력"
    txtField.clearButtonMode = .whileEditing
    txtField.layer.cornerRadius = 15
    txtField.textAlignment = .center
    txtField.sizeToFit()
    txtField.adjustsFontSizeToFitWidth = true
    txtField.minimumFontSize = 10
    txtField.textColor = UIColor(hex: "65418F")
    return txtField
  }()
  private lazy var cancleBtn: UIButton = {
    let btn = UIButton()
    btn.layer.cornerRadius = 15
    btn.setTitle("취소", for: .normal)
    btn.backgroundColor = UIColor(hex: "F8CF41")
    return btn
  }()
  private lazy var saveBtn: UIButton = {
    let btn = UIButton()
    btn.layer.cornerRadius = 15
    btn.setTitle("저장", for: .normal)
    btn.backgroundColor = UIColor(hex: "F35C4C")
    return btn
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  func setupView() {
    view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    view.addSubview(addCardBtn)
    view.addSubview(deleteCardBtn)
    view.addSubview(deleteCardLabel)
    view.addSubview(addCardLabel)
    view.addSubview(gameBtn)
    view.addSubview(gameLabel)
    view.addSubview(hideBtn)
    popUpView.addSubview(categoryTxtField)
    popUpView.addSubview(cancleBtn)
    popUpView.addSubview(saveBtn)
    view.addSubview(popUpView)
    
    hideBtn.snp.makeConstraints({ (make) in
      make.width.height.equalTo(70)
      if #available(iOS 11.0, *) {
        make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
      } else {
        make.bottom.equalTo(view).offset(-20)
        make.right.equalTo(view).offset(-20)
      }
    })
    
    addCardBtn.snp.makeConstraints({ (make) in
      make.height.width.equalTo(50)
      make.center.equalTo(hideBtn)
    })
    
    deleteCardBtn.snp.makeConstraints({ (make) in
      make.height.width.equalTo(50)
      make.center.equalTo(hideBtn)
    })
    gameBtn.snp.makeConstraints({ (make) in
      make.height.width.equalTo(50)
      make.center.equalTo(hideBtn)
    })
    addCardLabel.snp.makeConstraints({ (make) in
      make.height.equalTo(20)
      make.width.equalTo(100)
      make.centerY.equalTo(addCardBtn)
      make.right.equalTo(addCardBtn.snp.left).offset(-8)
    })
    deleteCardLabel.snp.makeConstraints({ (make) in
      make.height.equalTo(20)
      make.width.equalTo(100)
      make.centerY.equalTo(gameBtn)
      make.right.equalTo(gameBtn.snp.left).offset(-8)
    })
    gameLabel.snp.makeConstraints({ (make) in
      make.height.equalTo(20)
      make.width.equalTo(100)
      make.centerY.equalTo(gameBtn)
      make.right.equalTo(gameBtn.snp.left).offset(-8)
    })
    
    popUpView.snp.makeConstraints({ (make) in
      make.width.height.equalTo(UIScreen.main.bounds.width / 2)
      make.centerX.equalTo(self.view)
      make.centerY.equalTo(-UIScreen.main.bounds.width * 1 / 4)
    })
    categoryTxtField.snp.makeConstraints({ (make) in
      make.top.equalTo(popUpView).offset(10)
      make.left.equalTo(popUpView).offset(10)
      make.right.equalTo(popUpView).offset(-10)
      make.bottom.equalTo(popUpView).offset(-100)
    })
    cancleBtn.snp.makeConstraints({ (make) in
      make.top.equalTo(categoryTxtField.snp.bottom).offset(20)
      make.left.equalTo(popUpView).offset(10)
      make.bottom.equalTo(popUpView).offset(-20)
      make.right.equalTo(saveBtn.snp.left).offset(-10)
      make.width.equalTo(saveBtn)
    })
    saveBtn.snp.makeConstraints({ (make) in
      make.top.equalTo(categoryTxtField.snp.bottom).offset(20)
      make.right.equalTo(popUpView).offset(-10)
      make.bottom.equalTo(popUpView).offset(-20)
    })
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.animateBtn(willShow: true)
      .subscribe()
      .disposed(by: bag)
  }
  
  func bindViewModel() {
    view.rx.tapGesture { [unowned self] gestureRecognizer, delegate in
      gestureRecognizer.delegate = self
    }.skip(1)
      .throttle(0.5, scheduler: MainScheduler.instance)
      .flatMap { [unowned self] _ -> Observable<Bool> in
        return self.animateBtn(willShow: false)
      }.subscribe(onNext: { [unowned self] bool in
        if bool {
          self.viewModel.dismissPopUpView()
        }
      })
      .disposed(by: bag)
    
    hideBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .flatMap { [unowned self] _ -> Observable<Bool> in
        return self.animateBtn(willShow: false)
      }.subscribe(onNext: { [unowned self] bool in
        if bool {
          self.viewModel.dismissPopUpView()
        }
      })
      .disposed(by: bag)
    
    deleteCardBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .do(onNext: { [unowned self] _ in
        if let categoryViewModel = self.viewModel.parentViewModel as? CategoryViewModel {
          if categoryViewModel.cellMode.value == .normal {
            categoryViewModel.cellMode.accept(.delete)
          } else {
            categoryViewModel.cellMode.accept(.normal)
          }
        }
        else if let cardViewModel = self.viewModel.parentViewModel as? CardViewModel {
          if cardViewModel.cellMode.value == .normal {
            cardViewModel.cellMode.accept(.delete)
          } else {
            cardViewModel.cellMode.accept(.normal)
          }
        }
      })
      .flatMap({ [unowned self] _ -> Observable<Bool> in
        return self.animateBtn(willShow: false)
      })
      .subscribe(onNext: { [unowned self] bool in
        if bool {
          self.viewModel.dismissPopUpView()
        }
      })
      .disposed(by: bag)
    
    addCardBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [unowned self] _ in
        if let _ = self.viewModel.parentViewModel as? CardViewModel {
          self.viewModel.goToInputScene()
        } else if let _ = self.viewModel.parentViewModel as? CategoryViewModel {
          self.popUpView.isHidden = false
          UIView.animate(withDuration: 1.0,
                         animations: {
            self.popUpView.transform = CGAffineTransform(translationX: 0,
                                                         y: UIScreen.main.bounds.height / 2)
          },
                         completion: nil)
        }
      })
      .disposed(by: bag)
    
    gameBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.goToGamneScene()
      })
      .disposed(by: bag)
    
    cancleBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .flatMap { [unowned self] _ -> Observable<Bool> in
        return self.animateBtn(willShow: false)
      }.subscribe(onNext: { [unowned self] bool in
        if bool {
          self.viewModel.dismissPopUpView()
        }
      })
      .disposed(by: bag)
    
    saveBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .filter{ [unowned self] _ in self.categoryTxtField.text != nil &&
        !self.categoryTxtField.text!
          .components(separatedBy: " ")
          .joined(separator: "")
          .isEmpty
      }
      .map { [unowned self] _  -> String in
        let title = self.categoryTxtField.text!
        return title
      }
      .bind(to: viewModel.onAddNewCategory.inputs)
      .disposed(by: bag)
    
    viewModel.onAddNewCategory.executionObservables
      .take(1)
      .do(onNext: { [weak self] _ in
        self?.categoryTxtField.text = ""
        UIView.animate(withDuration: 1.0, animations: {
          self?.popUpView.transform = .identity
        }) { (success) in
          self?.popUpView.isHidden = true
        }
      })
      .flatMap { [unowned self] _ -> Observable<Bool> in
        return self.animateBtn(willShow: false)
      }.subscribe(onNext: { [unowned self] bool in
        if bool {
          self.viewModel.dismissPopUpView()
        }
      })
      .disposed(by: bag)
  }
  
  func animateBtn(willShow: Bool) -> Observable<Bool> {
    return Observable<Bool>.create({ [unowned self] observer -> Disposable in
      if willShow {
        UIView.animate(withDuration: 0.2, animations: {
          self.addCardBtn.transform = CGAffineTransform(translationX: 0, y: -70)
          self.deleteCardBtn.transform = CGAffineTransform(translationX: 0, y: -130)
          self.addCardLabel.transform = CGAffineTransform(translationX: 0, y: -70)
          self.deleteCardLabel.transform = CGAffineTransform(translationX: 0, y: -130)
          if let _ = self.viewModel.parentViewModel as? CardViewModel {
            self.gameBtn.transform = CGAffineTransform(translationX: 0, y: -190)
            self.gameLabel.transform = CGAffineTransform(translationX: 0, y: -190)
          }
        }, completion: { (success) in
          if let _ = self.viewModel.parentViewModel as? CardViewModel {
            self.gameLabel.isHidden = false
            self.addCardLabel.text = "단어 추가"
            self.deleteCardLabel.text = "단어 삭제"
          }
          self.addCardLabel.isHidden = false
          self.deleteCardLabel.isHidden = false
          observer.onNext(true)
        })
      } else {
        UIView.animate(withDuration: 0.2, animations: {
          self.addCardBtn.transform = CGAffineTransform.identity
          self.gameBtn.transform = CGAffineTransform.identity
          self.addCardLabel.transform = CGAffineTransform.identity
          self.gameLabel.transform = CGAffineTransform.identity
          self.deleteCardLabel.transform = CGAffineTransform.identity
          self.deleteCardBtn.transform = CGAffineTransform.identity
        }, completion: { (success) in
          self.addCardLabel.isHidden = true
          self.gameLabel.isHidden = true
          self.deleteCardLabel.isHidden = true
          observer.onNext(true)
        })
      }
      return Disposables.create()
    })
    
  }
  
}

extension PopUpViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return touch.view == gestureRecognizer.view
  }
}
