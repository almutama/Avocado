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

struct CategoryViewModel {
  private let localService = LocalService()
  
  func categories() -> Observable<Results<Category>> {
    return localService.categories()
  }
  
  func onDelete(index: Int) -> CocoaAction {
    return CocoaAction {
      return self.localService.removeCategoryAt(index: index).asObservable().map{ _ in }
    }
  }
}
