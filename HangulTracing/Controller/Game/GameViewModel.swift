//
//  GameViewModel.swift
//  HangulTracing
//
//  Created by junwoo on 2018. 4. 6..
//  Copyright © 2018년 samchon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct GameViewModel {
  private let bag = DisposeBag()
  let sceneCoordinator: SceneCoordinatorType
  let localService: LocalService
  let selectedCategory: Category
  let cardsSubject = BehaviorRelay<[WordCard]>(value: [])
  
  init(sceneCoordinator: SceneCoordinatorType,
       localService: LocalService,
       selectedCategory: Category) {
    self.sceneCoordinator = sceneCoordinator
    self.localService = localService
    self.selectedCategory = selectedCategory
    
    bindOutput()
  }
  
  func bindOutput() {
    localService.cards(category: selectedCategory)
      .bind(to: cardsSubject)
      .disposed(by: bag)
  }
  
  func numberOfCards() -> Int {
    return cardsSubject.value.count
  }
  
  func dismissView() {
    sceneCoordinator.pop()
  }
  
  func canPaging(page: Int) -> Bool {
    return page < cardsSubject.value.count - 1
  }
}
