//
//  InputViewModel.swift
//  HangulTracing
//
//  Created by junwoo on 2018. 4. 6..
//  Copyright © 2018년 samchon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

struct InputViewModel {
  let sceneCoordinator: SceneCoordinatorType
  let localService: LocalService
  let selectedCategory: Category
  let capturedPhotoSubject = PublishSubject<Data>()
  
  init(sceneCoordinator: SceneCoordinatorType,
       localService: LocalService,
       selectedCategory: Category) {
    self.sceneCoordinator = sceneCoordinator
    self.localService = localService
    self.selectedCategory = selectedCategory
  }
  
  func onAddCard() -> Action<(String, Data), Void> {
    return Action { tuple in
      let newCard = WordCard(word: tuple.0, imageData: tuple.1)
      return self.localService.addCard(newCard: newCard, category: self.selectedCategory).map{ _ in }
    }
  }
  
  func dismissView() {
    sceneCoordinator.pop()
  }
  
  func goToCameraScene() {
    let cameraScene = Scene.camera(self)
    sceneCoordinator.transition(to: cameraScene, type: .modal)
  }
  
}
