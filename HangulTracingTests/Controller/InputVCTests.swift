//
//  InputVCTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 10..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class InputVCTests: XCTestCase {
  
  var sut: InputVC!
  
  override func setUp() {
    super.setUp()
    sut = InputVC()
    let cardListVC = CardListVC()
    cardListVC.cardManager.changeCategory(category: "동물")
    sut.setCardListVC(vc: cardListVC)
    
    _ = sut.view
    
  }
  
  override func tearDown() {
    sut.cardManager.makeRealmEmpty()
    super.tearDown()
  }
  
  func test_Has_Property() {
    XCTAssertNotNil(sut.wordTextField)
    XCTAssertNotNil(sut.imageView)
    XCTAssertNotNil(sut.cameraBtn)
    XCTAssertNotNil(sut.addBtn)
    XCTAssertNotNil(sut.cancelBtn)
    XCTAssertNotNil(sut.cardListVC)
    XCTAssertNotNil(sut.cardManager)
  }
  
  func test_AddBtn_HasAction() {
    let addBtn: UIButton = sut.addBtn

    guard let actions = addBtn.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
      XCTFail(); return
    }

    XCTAssertTrue(actions.contains("addBtnTapped:"))
  }
  
  func test_WhenGivenTextAndIMG_AddBtn_Call_Dismiss() {
    let categoryVC = CategoryVC()
    let mockNav = MockNavigationController(rootViewController: categoryVC)
    UIApplication.shared.keyWindow?.rootViewController = mockNav
    _ = categoryVC.view
    categoryVC.collectionView.reloadData()
    categoryVC.collectionView.layoutIfNeeded()
    categoryVC.collectionView.delegate?.collectionView!(categoryVC.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
    guard let cardListVC = mockNav.pushedVC as? CardListVC else { fatalError() }
    let mockInputVC = MockInputVC()
    mockInputVC.setCardListVC(vc: cardListVC)
    cardListVC.present(mockInputVC, animated: true) {
      _ = mockInputVC.view
      mockInputVC.wordTextField.text = "개"
      mockInputVC.capturedPhotoData = WordCards().dogImgData!
      
      let addBtn: UIButton = mockInputVC.addBtn
      mockInputVC.addBtnTapped(addBtn)
      XCTAssertTrue(mockInputVC.dismissIsCalled)
    }
    
   
  }

//  func test_WhenNotGivenTextAndIMG_AddBtn_NotCall_Dismiss() {
//    let cardListVC = CardListVC()
//    UIApplication.shared.keyWindow?.rootViewController = cardListVC
//    let mockInputVC = MockInputVC()
//    mockInputVC.setCardListVC(vc: cardListVC)
//    cardListVC.present(mockInputVC, animated: true, completion: nil)
//    mockInputVC.wordTextField.text = ""
//    mockInputVC.capturedPhotoData = Data()
//    let addBtn: UIButton = mockInputVC.addBtn
//    mockInputVC.addBtnTapped(addBtn)
//    XCTAssertFalse(mockInputVC.dismissIsCalled)
//  }
  
  func test_cameraBtn_HasAction() {
    let cameraBtn = sut.cameraBtn
    guard let actions = cameraBtn.actions(forTarget: sut, forControlEvent: .touchUpInside) else { XCTFail(); return }
    XCTAssertTrue(actions.contains("cameraBtnTapped:"))
  }
  
  func test_libraryBtn_HasAction() {
    let libraryBtn = sut.libraryBtn
    guard let actions = libraryBtn.actions(forTarget: sut, forControlEvent: .touchUpInside) else { XCTFail(); return }
    XCTAssertTrue(actions.contains("libraryBtnTapped:"))
  }
  
  func test_cancelBtn_HasAction() {
    let cancelBtn = sut.cancelBtn
    guard let actions = cancelBtn.actions(forTarget: sut, forControlEvent: .touchUpInside) else { XCTFail(); return }
    XCTAssertTrue(actions.contains("cancelBtnTapped:"))
  }
  
  func test_cancelBtn_callDismiss() {
    let mockInputVC = MockInputVC()
    let cancelBtn: UIButton = mockInputVC.cancelBtn
    mockInputVC.cancelBtnTapped(cancelBtn)
    XCTAssertTrue(mockInputVC.dismissIsCalled)
  }
}

extension InputVCTests {
  class MockInputVC: InputVC {
    var dismissIsCalled = false
    var completionHandler: (() -> Void)?
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
      dismissIsCalled = true
      completionHandler?()
    }
  }
  
  class MockNavigationController: UINavigationController {
    var pushedVC: UIViewController?
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
      pushedVC = viewController
      super.pushViewController(viewController, animated: animated)
    }
  }
}
