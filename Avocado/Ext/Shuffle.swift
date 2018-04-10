//
//  Shuffle.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 16..
//  Copyright © 2017년 samchon. All rights reserved.
//

import Foundation

extension Array {
  
  func getShuffledArr() -> [Any] {
    var counts = count
    var tempArr = self
    var resultArr = [Any]()
    
    while resultArr.count < count {
      let randomIndex = chooseRandomIndex(count: counts)
      let removedElement = tempArr.remove(at: randomIndex)
      resultArr.append(removedElement)
      counts -= 1
    }
    return resultArr
  }
  
  func chooseRandomIndex(count: Int) -> Int {
    let randomUInt = arc4random_uniform(UInt32(count))
    return Int(randomUInt)
  }
  
}


