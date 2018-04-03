//
//  LocalService.swift
//  HangulTracing
//
//  Created by junwoo on 2018. 4. 3..
//  Copyright © 2018년 samchon. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa
import RxRealm

class LocalService {
  
  func categories() -> Observable<Results<Category>> {
    let result = withRealm("categories") { realm -> Observable<Results<Category>> in
      let categories = realm.objects(Category.self)
      return Observable.collection(from: categories)
    }
    return result ?? .empty()
  }
  
  func addCategory(newCategory: Category) -> Observable<Category> {
    let result = withRealm("addCategory") { realm -> Observable<Category> in
      let myPrimaryKey = newCategory.title
      if realm.object(ofType: Category.self, forPrimaryKey: myPrimaryKey) == nil {
        try! realm.write {
          realm.add(newCategory)
        }
        if let managedCategory = realm.object(ofType: Category.self, forPrimaryKey: myPrimaryKey) {
          return .just(managedCategory)
        }
      }
      return .empty()
    }
    return result ?? .empty()
  }
  
  func categoryAt(index: Int) -> Observable<Category> {
    let result = withRealm("categoryAt") { realm -> Observable<Category> in
      let categories = realm.objects(Category.self)
      return .just(categories[index])
    }
    return result ?? .empty()
  }
  
  func removeCategoryAt(index: Int) -> Completable {
    let result = withRealm("removeCategoryAt") { realm -> Completable in
      return Completable.create(subscribe: { completable -> Disposable in
        let categories = realm.objects(Category.self)
        let toDoCards = realm.objects(WordCard.self).filter("category = %@", categories[index].title)
        try! realm.write {
          realm.delete(categories[index])
          realm.delete(toDoCards)
          completable(.completed)
        }
        return Disposables.create()
      })
    }
    return result ?? .empty()
    
  }
  
  func removeAll() -> Completable {
    let result = withRealm("removeCategoryAt") { realm -> Completable in
      return Completable.create(subscribe: { completable -> Disposable in
        let categories = realm.objects(Category.self)
        try! realm.write {
          realm.delete(categories)
          completable(.completed)
        }
        return Disposables.create()
      })
    }
    return result ?? .empty()
  }
  
//  func changeCategory(category: String) {
//    let toDoCards = realm.objects(WordCard.self)
//    toDoCards = realm.objects(WordCard.self).filter("category = %@", category)
//    self.title = category
//  }
  
  func addCard(newCard: WordCard) -> Observable<WordCard> {
    let result = withRealm("categoryAt") { realm -> Observable<WordCard> in
      let myPrimaryKey = newCard.word
      if realm.object(ofType: WordCard.self, forPrimaryKey: myPrimaryKey) == nil {
        try! realm.write {
          realm.add(newCard)
        }
        if let managedCard = realm.object(ofType: WordCard.self, forPrimaryKey: newCard.word) {
          return .just(managedCard)
        }
      }
      return .empty()
    }
    return result ?? .empty()
    
  }
  
  func cardAt(index: Int) -> Observable<WordCard> {
    let result = withRealm("categoryAt") { realm -> Observable<WordCard> in
      let toDoCards = realm.objects(WordCard.self)
      return .just(toDoCards[index])
    }
    return result ?? .empty()
  }
  
  func removeCardAt(index: Int) -> Completable {
    let result = withRealm("removeCardAt") { realm -> Completable in
      return Completable.create(subscribe: { completable -> Disposable in
        let toDoCards = realm.objects(WordCard.self)
        try! realm.write {
          realm.delete(toDoCards[index])
          completable(.completed)
        }
        return Disposables.create()
      })
    }
    return result ?? .empty()
  }
  
  func removeAllCards() -> Completable {
    let result = withRealm("removeAll") { realm -> Completable in
      return Completable.create(subscribe: { completable -> Disposable in
        let toDoCards = realm.objects(WordCard.self)
        try! realm.write {
          realm.delete(toDoCards)
          completable(.completed)
        }
        return Disposables.create()
      })
    }
    return result ?? .empty()
  }
  
  func canPaging(page: Int) -> Bool {
    let realm = try! Realm()
    let toDoCards = realm.objects(WordCard.self)
    return page < toDoCards.count - 1
  }
}

extension LocalService {
  fileprivate func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
    do {
      let realm = try Realm()
      return try action(realm)
    } catch let err {
      print("Failed \(operation) realm with error: \(err)")
      return nil
    }
  }
}
