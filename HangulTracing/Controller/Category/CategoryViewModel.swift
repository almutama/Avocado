//
//  CategoryViewModel.swift
//  HangulTracing
//
//  Created by junwoo on 2018. 4. 3..
//  Copyright © 2018년 samchon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import Action

protocol ViewModelType {}

struct CategoryViewModel: ViewModelType {
  private let bag = DisposeBag()
  let localService: LocalService
  let cellMode = BehaviorRelay<CellMode>(value: .normal)
  let sceneCoordinator: SceneCoordinatorType
  var audioPlayer: SoundPlayer
  
  init(localService: LocalService,
       sceneCoordinator: SceneCoordinatorType,
       audioPlayer: SoundPlayer) {
    self.localService = localService
    self.sceneCoordinator = sceneCoordinator
    self.audioPlayer = audioPlayer
  }
  
  func categories() -> Observable<Results<Category>> {
    return localService.categories()
  }
  
  func removeCategoryAt(title: String) -> Completable {
    return localService.removeCategoryAt(categoryTitle: title)
  }
  
  func goToPopUpScene() {
    let popUpViewModel = PopUpViewModel(localService: localService,
                                        parentViewModel: self,
                                        sceneCoordinator: sceneCoordinator)
    let popUpScene = Scene.popUp(popUpViewModel)
    sceneCoordinator.transition(to: popUpScene, type: .modal)
  }
  
  func goToCardScene(category: Category) {
    let cardViewModel = CardViewModel(localService: localService,
                                      selectedCategory: category,
                                      sceneCoordinator: sceneCoordinator,
                                      audioPlayer: audioPlayer)
    let cardScene = Scene.card(cardViewModel)
    sceneCoordinator.transition(to: cardScene, type: .push)
  }
  
  func onDelete(categoryTitle: String) -> CocoaAction {
    return CocoaAction {
      return self.localService.removeCategoryAt(categoryTitle: categoryTitle)
        .asObservable().map{ _ in }
    }
  }
}
