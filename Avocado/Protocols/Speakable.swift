//
//  Speakable.swift
//  Avocado
//
//  Created by junwoo on 19/06/2018.
//  Copyright © 2018 samchon. All rights reserved.
//

import UIKit
import AVFoundation

protocol Speakable: class {
  var speechSynthesizer: AVSpeechSynthesizer { get set }
}

extension Speakable where Self: UIView {
  
  func synthesizeSpeech(fromString string:String) {
    let speechUtterence = AVSpeechUtterance(string: string)
    speechUtterence.voice = AVSpeechSynthesisVoice(language: "ko")
    speechUtterence.rate = 0.25
    speechSynthesizer.speak(speechUtterence)
  }
  
}

extension Speakable where Self: UIViewController {
  
  func synthesizeSpeech(fromString string:String) {
    let speechUtterence = AVSpeechUtterance(string: string)
    speechUtterence.voice = AVSpeechSynthesisVoice(language: "ko")
    speechUtterence.rate = 0.5
    speechSynthesizer.speak(speechUtterence)
  }
  
}
