//
//  UIImageExt.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 16..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

extension UIImage{
  
  func downSizeImageWith(downRatio: CGFloat) -> UIImage {
    
    let newSize = CGSize(width: size.width * downRatio, height: size.height * downRatio)
    UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
    draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
  }
}
