//
//  InputVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 8..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class InputVC: UIViewController {
  
  private var didSetupConstraints = false
  private var cardManager = CardManager.instance
  private var cardListVC: CardListVC!
  private var spinner: UIActivityIndicatorView!
  private lazy var wordTextField: UITextField = {
    let textField = UITextField()
    textField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    textField.textAlignment = .center
    textField.font = textField.font?.withSize(20)
    textField.placeholder = "단어를 입력하세요"
    return textField
  }()
  private lazy var cardView: UIView = {
    let view = UIView()
    view.layer.borderWidth = 1
    view.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    view.backgroundColor = UIColor.clear
    view.layer.cornerRadius = 15
    view.clipsToBounds = true
    return view
  }()
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "empty")
    imageView.clipsToBounds = true
    return imageView
  }()
  private lazy var cameraBtn: UIButton = {
    let btn = UIButton()
    btn.setImage(UIImage(named: "camera"), for: .normal)
    return btn
  }()
  private lazy var libraryBtn: UIButton = {
    let btn = UIButton()
    btn.setImage(UIImage(named: "library"), for: .normal)
    return btn
  }()
  private lazy var addBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = UIColor(hex: "F35C4C")
    btn.setTitle("ADD", for: .normal)
    btn.layer.cornerRadius = 15
    return btn
  }()
  private lazy var cancelBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = UIColor(hex: "F8CF41")
    btn.setTitle("CANCEL", for: .normal)
    btn.layer.cornerRadius = 15
    return btn
  }()
  var capturedPhotoData: Data?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    NotificationCenter.default.addObserver(self, selector: #selector(InputVC.photoCaptured(_:)), name: Constants().NOTI_PHOTO_SELECTED, object: nil)
    
    view.bindToKeyboard()
    let tap = UITapGestureRecognizer(target: self, action: #selector(InputVC.closeTap))
    view.addGestureRecognizer(tap)
    
    cameraBtn.addTarget(self, action: #selector(InputVC.cameraBtnTapped(_:)), for: .touchUpInside)
    libraryBtn.addTarget(self, action: #selector(InputVC.libraryBtnTapped(_:)), for: .touchUpInside)
    addBtn.addTarget(self, action: #selector(InputVC.addBtnTapped(_:)), for: .touchUpInside)
    cancelBtn.addTarget(self, action: #selector(InputVC.cancelBtnTapped(_:)), for: .touchUpInside)
    view.setNeedsUpdateConstraints()
    
  }
  
  func setupView() {
    spinner = UIActivityIndicatorView()
    view.backgroundColor = UIColor(hex: "1EBBBC")
    view.addSubview(cardView)
    cardView.addSubview(wordTextField)
    cardView.addSubview(imageView)
    view.addSubview(libraryBtn)
    view.addSubview(cameraBtn)
    view.addSubview(addBtn)
    view.addSubview(cancelBtn)
    view.addSubview(spinner)
    spinner.isHidden = true
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      cardView.snp.makeConstraints({ (make) in
        make.top.equalTo(self.view).offset(100)
        make.bottom.equalTo(self.view).offset(-100)
        make.left.equalTo(self.view).offset(50)
        make.right.equalTo(self.view).offset(-50)
      })
      wordTextField.snp.makeConstraints({ (make) in
        make.height.equalTo(50)
        make.left.right.bottom.equalTo(cardView)
      })
      imageView.snp.makeConstraints({ (make) in
        make.bottom.equalTo(wordTextField.snp.top).offset(-8)
        make.left.right.top.equalTo(cardView)
      })
      cameraBtn.snp.makeConstraints({ (make) in
        make.width.height.equalTo(50)
        make.bottom.equalTo(cardView.snp.top).offset(-8)
        make.left.equalTo(self.view).offset(50)
      })
      libraryBtn.snp.makeConstraints({ (make) in
        make.centerY.equalTo(cameraBtn)
        make.left.equalTo(cameraBtn.snp.right).offset(8)
      })
      addBtn.snp.makeConstraints({ (make) in
        make.right.equalTo(self.view).offset(-50)
        make.bottom.equalTo(self.view).offset(-50)
        make.top.equalTo(cardView.snp.bottom).offset(10)
        make.left.equalTo(cancelBtn.snp.right).offset(8)
        make.width.equalTo(cancelBtn)
      })
      cancelBtn.snp.makeConstraints({ (make) in
        make.left.equalTo(self.view).offset(50)
        make.bottom.equalTo(self.view).offset(-50)
        make.top.equalTo(cardView.snp.bottom).offset(10)
      })
      spinner.snp.makeConstraints({ (make) in
        make.center.equalTo(self.view)
        make.width.height.equalTo(50)
      })
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  func setCardListVC(vc: CardListVC) {
    self.cardListVC = vc
  }
  
  @objc func cameraBtnTapped(_ sender: UIButton) {
    cameraBtn.isEnabled = false
    spinner.isHidden = false
    spinner.startAnimating()
    let cameraVC = CameraVC()
    present(cameraVC, animated: true) {
      self.spinner.stopAnimating()
      self.spinner.isHidden = true
      self.cameraBtn.isEnabled = true
    }
  }
  
  @objc func libraryBtnTapped(_ sender: UIButton) {
    libraryBtn.isEnabled = false
    spinner.isHidden = false
    spinner.startAnimating()
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
    present(imagePickerController, animated: true) {
      self.spinner.stopAnimating()
      self.spinner.isHidden = true
      self.libraryBtn.isEnabled = true
    }
    
  }
  
  @objc func addBtnTapped(_ sender: UIButton) {
    guard let text = wordTextField.text , !text.components(separatedBy: " ").joined(separator: "").isEmpty else { return }
    let filterdText = text.components(separatedBy: " ").joined(separator: "")
    guard let photoData = capturedPhotoData else { return }
    cardManager.addCard(newCard: WordCard(word: filterdText, imageData: photoData, category: cardManager.title!))

    guard let cardListVC = self.cardListVC else { return }
    cardListVC.collectionView.reloadData()
    
    dismiss(animated: true, completion: nil)
  }
  
  @objc func cancelBtnTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
    
  }
  
  @objc func photoCaptured(_ notification: NSNotification) {
    guard let photoData = notification.userInfo!["photoData"] as? Data else { fatalError() }
    capturedPhotoData = photoData
    self.imageView.image = UIImage(data: photoData)
  }
  @objc func closeTap() {
    view.endEditing(true)
  }
}

extension InputVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
    imageView.image = pickedImage
    let downSizedImg = pickedImage.downSizeImageWith(downRatio: 0.1)
    let imageData = UIImageJPEGRepresentation(downSizedImg, 1)
    capturedPhotoData = imageData
    dismiss(animated: true, completion: nil)
  }
}
