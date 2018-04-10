//
//  InputViewController.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 8..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InputViewController: UIViewController, BindableType {
  private let bag = DisposeBag()
  var viewModel: InputViewModel!
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
    view.bindToKeyboard()
  }
  
  func setupView() {
    view.backgroundColor = UIColor(hex: "1EBBBC")
    view.addSubview(cardView)
    cardView.addSubview(wordTextField)
    cardView.addSubview(imageView)
    view.addSubview(libraryBtn)
    view.addSubview(cameraBtn)
    view.addSubview(addBtn)
    view.addSubview(cancelBtn)
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
      make.width.height.equalTo(50)
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
  }
  
  func bindViewModel() {
    view.rx.tapGesture()
      .skip(1)
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [unowned self] _ in
        self.view.endEditing(true)
      })
      .disposed(by: bag)
    
    viewModel.capturedPhotoSubject
      .subscribe(onNext: { [unowned self] photoData in
        self.capturedPhotoData = photoData
        self.imageView.image = UIImage(data: photoData)
      })
      .disposed(by: bag)
    
    viewModel.onAddCard.executionObservables
      .take(1)
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.dismissView()
      })
      .disposed(by: bag)
    
    addBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .filter{ [unowned self] _ in self.wordTextField.text != nil }
      .filter{ [unowned self] _ in !self.wordTextField.text!.components(separatedBy: " ").joined(separator: "").isEmpty }
      .filter{ [unowned self] _ in self.capturedPhotoData != nil }
      .map { [unowned self] _ -> (String, Data) in
        return (self.wordTextField.text!, self.capturedPhotoData!)
      }
      .bind(to: viewModel.onAddCard.inputs)
      .disposed(by: bag)
    
    cameraBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [unowned self] _ in
        self.cameraBtn.isEnabled = true
        self.viewModel.goToCameraScene()
      })
      .disposed(by: bag)
    
    libraryBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [unowned self] _ in
        self.libraryBtn.isEnabled = false
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePickerController, animated: true) {
          self.libraryBtn.isEnabled = true
        }
      })
      .disposed(by: bag)
    
    cancelBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.dismissView()
      })
      .disposed(by: bag)
  }
  
}

extension InputViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
    imageView.image = pickedImage
    let downSizedImg = pickedImage.downSizeImageWith(downRatio: 0.1)
    let imageData = UIImageJPEGRepresentation(downSizedImg, 1)
    capturedPhotoData = imageData
    dismiss(animated: true, completion: nil)
  }
}
