//
//  PopAnimator.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 17..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  private let duration = 0.5
  var presenting = true
  var originFrame = CGRect.zero
  
  var dismissCompletion: (()->Void)?
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    containerView.backgroundColor = UIColor.white
    guard let toView = transitionContext.view(forKey: .to) else { return }
    let cellView = presenting ? toView : transitionContext.view(forKey: .from)!
    
    let initialFrame = presenting ? originFrame : cellView.bounds
    let finalFrame = presenting ? cellView.bounds : originFrame
    
    let xScaleFactor = presenting ?
      initialFrame.width / finalFrame.width :
      finalFrame.width / initialFrame.width
    
    let yScaleFactor = presenting ?
      initialFrame.height / finalFrame.height :
      finalFrame.height / initialFrame.height
    
    let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
    
    if presenting {
      cellView.transform = scaleTransform
      cellView.center = CGPoint(
        x: initialFrame.midX,
        y: initialFrame.midY)
      cellView.clipsToBounds = true
    }
    
    containerView.addSubview(toView)
    containerView.bringSubview(toFront: cellView)
    
    
    UIView.animate(withDuration: duration, delay: 0.0,
                   usingSpringWithDamping: 1, initialSpringVelocity: 0.0,
                   animations: {
                    cellView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
                    cellView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
    }, completion: { _ in
      if !self.presenting {
        self.dismissCompletion?()
      }
      transitionContext.completeTransition(true)
    })
  }
}


