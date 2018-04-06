//
//  PopCardViewModel.swift
//  HangulTracing
//
//  Created by junwoo on 2018. 4. 5..
//  Copyright © 2018년 samchon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

struct PopCardViewModel {
  var selectedCard: WordCard
  var sceneCoordinator: SceneCoordinatorType
  var audioPlayer: SoundPlayer
  
  init(selectedCard: WordCard,
       sceneCoordinator: SceneCoordinatorType,
       audioPlayer: SoundPlayer) {
    self.selectedCard = selectedCard
    self.sceneCoordinator = sceneCoordinator
    self.audioPlayer = audioPlayer
  }
  
  func goToTracingScene() {
    let tracingScene = Scene.tracing(self)
    sceneCoordinator.transition(to: tracingScene, type: .push)
  }
  
  func popView() {
    sceneCoordinator.pop()
  }
}
