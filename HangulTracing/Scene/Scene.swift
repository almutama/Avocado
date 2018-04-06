//
//  Scene.swift
//  HangulTracing
//
//  Created by junwoo on 2018. 4. 4..
//  Copyright © 2018년 samchon. All rights reserved.
//

import UIKit

enum Scene {
  case category(CategoryViewModel)
  case card(CardViewModel)
  case popUp(PopUpViewModel)
  case popCard(PopCardViewModel, CGRect, WordCard)
  case tracing(PopCardViewModel)
  case input(InputViewModel)
  case camera(InputViewModel)
  case game(GameViewModel)
}

extension Scene {
  func viewController() -> UIViewController {
    
    switch self {
    case .category(let viewModel):
      var vc = CategoryViewController()
      vc.bindViewModel(to: viewModel)
      let nav = UINavigationController(rootViewController: vc)
      nav.setNavigationBarHidden(true, animated: true)
      return nav
    case .card(let viewModel):
      var vc = CardViewController()
      vc.bindViewModel(to: viewModel)
      return vc
    case .popUp(let viewModel):
      var vc = PopUpViewController()
      vc.bindViewModel(to: viewModel)
      vc.modalPresentationStyle = .overFullScreen
      vc.modalTransitionStyle = .crossDissolve
      return vc
    case .popCard(let viewModel, let rect, _):
      var vc = PopCardViewController(viewFrame: rect)
      vc.bindViewModel(to: viewModel)
      return vc
    case .tracing(let viewModel):
      var vc = TracingViewController()
      vc.bindViewModel(to: viewModel)
      return vc
    case .input(let viewModel):
      var vc = InputViewController()
      vc.bindViewModel(to: viewModel)
      return vc
    case .camera(let viewModel):
      var vc = CameraViewController()
      vc.bindViewModel(to: viewModel)
      return vc
    case .game(let viewModel):
      var vc = GameViewController()
      vc.bindViewModel(to: viewModel)
      return vc
    }
  }
}
