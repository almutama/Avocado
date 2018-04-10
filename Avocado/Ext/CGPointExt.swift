//
//  CGPointExt.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 7..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

extension CGPoint : Hashable {
  func distance(point: CGPoint) -> Float {
    let dx = Float(x - point.x)
    let dy = Float(y - point.y)
    return sqrt((dx * dx) + (dy * dy))
  }
  public var hashValue: Int {
    
    return x.hashValue << 32 ^ y.hashValue
  }
}

func ==(lhs: CGPoint, rhs: CGPoint) -> Bool {
  return lhs.distance(point: rhs) < 0.000001
}
