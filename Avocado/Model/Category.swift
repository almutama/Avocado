//
//  Category.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 22..
//  Copyright © 2017년 samchon. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var title: String = ""
  var cards = List<WordCard>()
  
  convenience init(category: String) {
    self.init()
    self.title = category
  }
  
  override static func primaryKey() -> String? {
    return "title"
  }
}
