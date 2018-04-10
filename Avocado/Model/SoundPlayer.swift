//
//  SoundPlayer.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 22..
//  Copyright © 2017년 samchon. All rights reserved.
//

import Foundation
import AVFoundation

struct SoundPlayer {
  
  private var soundPlayer = AVAudioPlayer()
  
  mutating func playSoundEffect(name: String, extender: String) {
    do {
      soundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: extender)!))
      soundPlayer.prepareToPlay()
      soundPlayer.play()
    } catch {
      print(error)
    }
  }
}
