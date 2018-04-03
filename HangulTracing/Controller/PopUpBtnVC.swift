//
//  PopUpBtnVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 24..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class PopUpBtnVC: UIViewController {
  private weak var parentVC: UIViewController?
  private var didSetupConstraints = false
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
    label.text = "카테고리 삭제"
    return label
  }()
  private lazy var addCardBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = UIColor(hex: "5F9EF2")
    btn.layer.cornerRadius = 25
    btn.setImage(UIImage(named: "addCard"), for: .normal)
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
    return label
  }()
  private lazy var gameBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = UIColor(hex: "5F9EF2")
    btn.layer.cornerRadius = 25
    btn.setImage(UIImage(named: "game"), for: .normal)
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
    return label
  }()
  private var presenting = true
  private lazy var popUpView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 15
    view.backgroundColor = UIColor(hex: "1EBBBC")
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
    view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    setBgViewTap()
    
    hideBtn.addTarget(self, action: #selector(PopUpBtnVC.dismissPopUp), for: .touchUpInside)
    deleteCardBtn.addTarget(self, action: #selector(PopUpBtnVC.deleteBtnTapped(_:)), for: .touchUpInside)
    addCardBtn.addTarget(self, action: #selector(PopUpBtnVC.addCardBtnTapped(_:)), for: .touchUpInside)
    gameBtn.addTarget(self, action: #selector(PopUpBtnVC.gameBtnTapped(_:)), for: .touchUpInside)
    view.addSubview(addCardBtn)
    view.addSubview(deleteCardBtn)
    view.addSubview(deleteCardLabel)
    view.addSubview(addCardLabel)
    view.addSubview(gameBtn)
    view.addSubview(gameLabel)
    view.addSubview(hideBtn)
    
    deleteCardLabel.isHidden = true
    addCardLabel.isHidden = true
    gameLabel.isHidden = true
    
    cancleBtn.addTarget(self, action: #selector(PopUpBtnVC.dismissPopUp), for: .touchUpInside)
    saveBtn.addTarget(self, action: #selector(PopUpBtnVC.saveBtnTapped(_:)), for: .touchUpInside)
    popUpView.addSubview(categoryTxtField)
    popUpView.addSubview(cancleBtn)
    popUpView.addSubview(saveBtn)
    view.addSubview(popUpView)
    popUpView.isHidden = true
    view.setNeedsUpdateConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    animateBtn { (success) in
    }
  }
  
  func setParentVC(vc: UIViewController) {
    self.parentVC = vc
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      hideBtn.snp.makeConstraints({ (make) in
        make.width.height.equalTo(70)
        make.bottom.right.equalTo(self.view).offset(-20)
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
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  @objc func dismissPopUp() {
    animateBtn { (success) in
      if success {
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  @objc func saveBtnTapped(_ sender: UIButton) {
    guard let parentVC = parentVC as? CategoryViewController else { return }
    guard let text = categoryTxtField.text , !text.components(separatedBy: " ").joined(separator: "").isEmpty else { return }
    view.endEditing(true)
    parentVC.categoryManager.addCategory(newCategory: Category(category: text))
    parentVC.collectionView.reloadData()
    categoryTxtField.text = ""
    UIView.animate(withDuration: 1.0, animations: {
      self.popUpView.transform = .identity
    }) { (success) in
      self.popUpView.isHidden = true
    }
    dismissPopUp()
  }
  
  @objc func addCardBtnTapped(_ sender: UIButton) {
    if parentVC is CardListVC {
      guard let parentVC = parentVC as? CardListVC else { return }
      let inputVC = InputVC()
      inputVC.setCardListVC(vc: parentVC)
      animateBtn { (success) in
        if success {
          self.dismiss(animated: true, completion: {
            parentVC.present(inputVC, animated: true, completion: nil)
          })
        }
      }
    } else if parentVC is CategoryViewController {
      popUpView.isHidden = false
      UIView.animate(withDuration: 1.0, animations: {
        self.popUpView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height / 2)
      }, completion: nil)
    }
    
  }
  
  @objc func gameBtnTapped(_ sender: UIButton) {
    guard let parentVC = parentVC as? CardListVC else { return }
    
    let gameVC = GameVC()
    
    animateBtn { (success) in
      if success {
        self.dismiss(animated: true, completion: {
          parentVC.present(gameVC, animated: true, completion: nil)
        })
      }
    }
  }
  
  @objc func deleteBtnTapped(_ sender: UIButton) {
    if parentVC is CategoryViewController {
      guard let parentVC = parentVC as? CategoryViewController else { return }
      if parentVC.categoryDataProvider.cellMode == .normal {
        parentVC.categoryDataProvider.cellMode = .delete
      } else {
        parentVC.categoryDataProvider.cellMode = .normal
      }
      parentVC.collectionView.reloadData()
    }
    else if parentVC is CardListVC {
      guard let parentVC = parentVC as? CardListVC else { return }
      if parentVC.dataProvider.cellMode == .normal {
        parentVC.dataProvider.cellMode = .delete
      } else {
        parentVC.dataProvider.cellMode = .normal
      }
      parentVC.collectionView.reloadData()
    }
    dismissPopUp()
  }
  
  func setBgViewTap() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(PopUpBtnVC.dismissPopUp))
    view.addGestureRecognizer(tap)
  }
  
  func animateBtn(completion: @escaping CompletionHandler) {
    
    if presenting {
      UIView.animate(withDuration: 0.2, animations: {
        self.addCardBtn.transform = CGAffineTransform(translationX: 0, y: -70)
        self.deleteCardBtn.transform = CGAffineTransform(translationX: 0, y: -130)
        self.addCardLabel.transform = CGAffineTransform(translationX: 0, y: -70)
        self.deleteCardLabel.transform = CGAffineTransform(translationX: 0, y: -130)
        if self.parentVC is CardListVC {
          self.gameBtn.transform = CGAffineTransform(translationX: 0, y: -190)
          self.gameLabel.transform = CGAffineTransform(translationX: 0, y: -190)
        }
        
        self.presenting = false
      }, completion: { (success) in
        if self.parentVC is CardListVC {
          self.gameLabel.isHidden = false
          self.addCardLabel.text = "단어 추가"
          self.deleteCardLabel.text = "단어 삭제"
        }
        self.addCardLabel.isHidden = false
        self.deleteCardLabel.isHidden = false
        
        completion(true)
      })
    } else {
      UIView.animate(withDuration: 0.2, animations: {
        self.addCardBtn.transform = CGAffineTransform.identity
        self.gameBtn.transform = CGAffineTransform.identity
        self.addCardLabel.transform = CGAffineTransform.identity
        self.gameLabel.transform = CGAffineTransform.identity
        self.deleteCardLabel.transform = CGAffineTransform.identity
        self.deleteCardBtn.transform = CGAffineTransform.identity
        self.presenting = true
      }, completion: { (success) in
        self.addCardLabel.isHidden = true
        self.gameLabel.isHidden = true
        self.deleteCardLabel.isHidden = true
        completion(true)
      })
      
    }
  }
  
}
