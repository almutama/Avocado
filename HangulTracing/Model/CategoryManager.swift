//
//  CategoryManager.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 19..
//  Copyright © 2017년 samchon. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryManager: NSObject {
  private var realm: Realm!
  var categories: Results<Category>!
  static let instance = CategoryManager()
  
  override init() {
    realm = try! Realm()
    categories = realm.objects(Category.self)
  }
  
  func addCategory(newCategory: Category) {
    let myPrimaryKey = newCategory.title
    if realm.object(ofType: Category.self, forPrimaryKey: myPrimaryKey) == nil {
      try! realm.write {
        realm.add(newCategory)
      }
    }
  }
  
  func categoryAt(index: Int) -> Category {
    return categories[index]
  }
  
  func removeCategoryAt(index: Int) {
    let toDoCards = realm.objects(WordCard.self).filter("category = %@", categories[index].title)
    try! realm.write {
      realm.delete(categories[index])
      realm.delete(toDoCards)
    }
  }
  
  func removeAll() {
    try! realm.write {
      realm.delete(categories)
    }
  }
  
  //TDD 초기화
  func makeRealmEmpty() {
    try! realm.write {
      realm.deleteAll()
    }
  }
}
