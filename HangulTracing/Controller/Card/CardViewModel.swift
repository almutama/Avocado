//
//  CardViewModel.swift
//  HangulTracing
//
//  Created by junwoo on 2018. 4. 4..
//  Copyright © 2018년 samchon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

struct CardViewModel: ViewModelType {
  var localService: LocalService
  var selectedCategory: Category
  var sceneCoordinator: SceneCoordinatorType
  let cellMode = BehaviorRelay<CellMode>(value: .normal)
  var audioPlayer: SoundPlayer
  
  init(localService: LocalService,
       selectedCategory: Category,
       sceneCoordinator: SceneCoordinatorType,
       audioPlayer: SoundPlayer) {
    self.localService = localService
    self.selectedCategory = selectedCategory
    self.sceneCoordinator = sceneCoordinator
    self.audioPlayer = audioPlayer
  }
  
  func cards() -> Observable<[WordCard]> {
    return localService.cards(category: selectedCategory)
  }
  
  func dismissCardView() {
    sceneCoordinator.pop()
  }
  
  func goToPopUpScene() {
    let popUpViewModel = PopUpViewModel(localService: localService,
                                        parentViewModel: self,
                                        sceneCoordinator: sceneCoordinator)
    let popUpScene = Scene.popUp(popUpViewModel)
    sceneCoordinator.transition(to: popUpScene, type: .modal)
  }
  
  func cardAt(index: Int) -> WordCard {
    return selectedCategory.cards.toArray()[index]
  }
  
  func goToPopCardScene(rect: CGRect, card: WordCard) {
    let popCardViewModel = PopCardViewModel(selectedCard: card,
                                            sceneCoordinator: self.sceneCoordinator,
                                            audioPlayer: self.audioPlayer)
    let popCardScene = Scene.popCard(popCardViewModel, rect, card)
    self.sceneCoordinator.transition(to: popCardScene, type: .push)
  }
  
  func removeCardAt(word: String) -> Completable {
    return localService.removeCardAt(cardWord: word, categoryTitle: selectedCategory.title)
  }
  
  func onDelete(card: WordCard, collectionView: UICollectionView) -> CocoaAction {
    return CocoaAction {
      return self.localService.removeCardAt(cardWord: card.word, categoryTitle: self.selectedCategory.title)
        .asObservable().map{ _ in collectionView.reloadData() }
    }
  }
  
}
