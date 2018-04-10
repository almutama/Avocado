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
    print("------realmfile-------", RealmConfig.main.configuration.fileURL)
    let result = withRealm("categories") { realm -> Observable<Results<Category>> in
      let categories = realm.objects(Category.self)
      return Observable.collection(from: categories)
    }
    return result ?? .empty()
  }
  
  func addCategory(newCategoryTitle: String) -> Observable<Category> {
    let result = withRealm("addCategory") { realm -> Observable<Category> in
      if let _ = realm.object(ofType: Category.self, forPrimaryKey: newCategoryTitle) {
      } else {
        let newCategory = Category(category: newCategoryTitle)
        try! realm.write {
          realm.add(newCategory)
        }
        return .just(newCategory)
      }
      return .empty()
    }
    return result ?? .empty()
  }
  
  func categoryAt(categoryTitle: String) -> Observable<Category> {
    let result = withRealm("categoryAt") { realm -> Observable<Category> in
      if let category = realm.object(ofType: Category.self, forPrimaryKey: categoryTitle) {
        return .just(category)
      }
      return .empty()
    }
    return result ?? .empty()
  }
  
  func removeCategoryAt(categoryTitle: String) -> Completable {
    let result = withRealm("removeCategoryAt") { realm -> Completable in
      return Completable.create(subscribe: { completable -> Disposable in
        if let category = realm.object(ofType: Category.self, forPrimaryKey: categoryTitle) {
          try! realm.write {
            realm.delete(category)
            completable(.completed)
          }
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
  
  func cards(category: Category) -> Observable<Results<WordCard>> {
    let result = withRealm("cards") { realm -> Observable<Results<WordCard>> in
      if let category = realm.object(ofType: Category.self, forPrimaryKey: category.title) {
        let cards = category.cards.filter("word != ''")
        return Observable.collection(from: cards)
      }
      return .empty()
    }
    return result ?? .empty()
  }
  
  func addCard(newCard: WordCard, category: Category) -> Observable<WordCard> {
    let result = withRealm("categoryAt") { realm -> Observable<WordCard> in
      if let category = realm.object(ofType: Category.self, forPrimaryKey: category.title) {
        try! realm.write {
          category.cards.append(newCard)
        }
        if let card = realm.object(ofType: WordCard.self, forPrimaryKey: newCard.word) {
          return .just(card)
        }
      }
      return .empty()
    }
    return result ?? .empty()
  }
  
  func cardAt(cardWord: String, categoryTitle: String) -> Observable<WordCard> {
    let result = withRealm("categoryAt") { realm -> Observable<WordCard> in
      if let category = realm.object(ofType: Category.self, forPrimaryKey: categoryTitle) {
        if let card = category.cards.filter("title = '\(cardWord)'").first {
          return .just(card)
        }
      }
      return .empty()
    }
    return result ?? .empty()
  }
  
  func removeCardAt(cardWord: String, categoryTitle: String) -> Completable {
    let result = withRealm("removeCardAt") { realm -> Completable in
      return Completable.create(subscribe: { completable -> Disposable in
        if let category = realm.object(ofType: Category.self, forPrimaryKey: categoryTitle) {
          if let card = category.cards.filter("word = '\(cardWord)'").first {
            try! realm.write {
              realm.delete(card)
              completable(.completed)
            }
          }
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
}

extension LocalService {
  fileprivate func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
    do {
      let realm = try Realm(configuration: RealmConfig.main.configuration)
      return try action(realm)
    } catch let err {
      print("Failed \(operation) realm with error: \(err)")
      return nil
    }
  }
  
  func defaultCategory(realm: Realm, title: String) -> Category {
    if let category = realm.object(ofType: Category.self, forPrimaryKey: title) {
      return category
    }
    let newCategory = Category(category: title)
    realm.add(newCategory)
    return realm.object(ofType: Category.self, forPrimaryKey: title)!
  }
  
  func defaultCard(realm: Realm, word: String, imgData: Data) -> WordCard {
    if let card = realm.object(ofType: WordCard.self, forPrimaryKey: word) {
      return card
    }
    let newCard = WordCard(word: word, imageData: imgData)
    realm.add(newCard)
    return realm.object(ofType: WordCard.self, forPrimaryKey: word)!
  }
  
  static func migrate(_ migration: Migration, fileSchemaVersion: UInt64) {
    
  }
  
  static func copyInitialData(_ from: URL, to: URL) {
    let copy = {
      _ = try? FileManager.default.removeItem(at: to)
      try! FileManager.default.copyItem(at: from, to: to)
    }
    let exists: Bool
    do {
      exists = try to.checkPromisedItemIsReachable()
    } catch {
      copy()
      return
    }
    if !exists {
      copy()
    }
  }
}
