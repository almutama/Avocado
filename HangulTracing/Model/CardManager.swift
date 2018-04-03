//
//  CardManager.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 3..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import RealmSwift

class CardManager: NSObject {
  
  static let instance = CardManager()
  
  private var realm = try! Realm()
  var toDoCards: Results<WordCard>!
  var toDoCount: Int { return toDoCards.count }
  var title: String?
  
  override init() {
    super.init()
    toDoCards = realm.objects(WordCard.self)
  }
  
  func changeCategory(category: String) {
    toDoCards = realm.objects(WordCard.self).filter("category = %@", category)
    self.title = category
  }
  
  func addCard(newCard: WordCard) {
    let myPrimaryKey = newCard.word
    if realm.object(ofType: WordCard.self, forPrimaryKey: myPrimaryKey) == nil {
      try! realm.write {
        realm.add(newCard)
      }
    }
  }
  
  func cardAt(index: Int) -> WordCard {
    return toDoCards[index]
  }
  
  func removeCardAt(index: Int) {
    try! realm.write {
      realm.delete(toDoCards[index])
    }
  }
  
  func removeAll() {
    try! realm.write {
      realm.delete(toDoCards)
    }
  }
  
  func canPaging(page: Int) -> Bool {
    return page < toDoCount - 1
  }
  
  //TDD 초기화
  func makeRealmEmpty() {
    try! realm.write {
      realm.deleteAll()
    }
  }
}
