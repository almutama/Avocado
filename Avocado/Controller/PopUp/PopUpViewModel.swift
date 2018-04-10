//
//  PopUpViewModel.swift
//  HangulTracing
//
//  Created by junwoo on 2018. 4. 3..
//  Copyright © 2018년 samchon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

struct PopUpViewModel {
  private let localService: LocalService
  let parentViewModel: ViewModelType
  var sceneCoordinator: SceneCoordinatorType
  
  init(localService: LocalService,
       parentViewModel: ViewModelType,
       sceneCoordinator: SceneCoordinatorType) {
    self.localService = localService
    self.parentViewModel = parentViewModel
    self.sceneCoordinator = sceneCoordinator
  }
  
  lazy var onAddNewCategory: Action<String, Void> = { this in
    return Action { categoryTitle in
      return this.localService.addCategory(newCategoryTitle: categoryTitle).map{ _ in }
    }
  }(self)

  func dismissPopUpView() {
    sceneCoordinator.pop()
  }
  
  func goToInputScene() {
    guard let cardViewModel = parentViewModel as? CardViewModel else { fatalError() }
    let inputViewModel = InputViewModel(sceneCoordinator: sceneCoordinator,
                                        localService: localService,
                                        selectedCategory: cardViewModel.selectedCategory)
    let inputScene = Scene.input(inputViewModel)
    sceneCoordinator.transition(to: inputScene, type: .modal)
  }
  
  func goToGamneScene() {
    guard let cardViewModel = parentViewModel as? CardViewModel else { fatalError() }
    let gameViewModel = GameViewModel(sceneCoordinator: sceneCoordinator,
                                      localService: localService,
                                      selectedCategory: cardViewModel.selectedCategory)
    let gameScene = Scene.game(gameViewModel)
    sceneCoordinator.transition(to: gameScene, type: .modal)
  }
}
