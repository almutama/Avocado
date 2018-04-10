//
//  PlayerVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 16..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import AVKit

class PlayerVC: AVPlayerViewController, orientationIsOnlyLandScapeRight {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.layer.cornerRadius = 15
    view.clipsToBounds = true
  }
}
