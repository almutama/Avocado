//
//  TracingVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 7..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import AVFoundation

class TracingVC: UIViewController {
  private var didSetupConstraints = false
  private var cardInfo: (CardManager, Int)?
  private var characters = [Character]()
  private var characterViews = [LetterView]()
  private var speechSynthesizer: AVSpeechSynthesizer!
  private var audioPlayer = SoundPlayer()
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.isPagingEnabled = true
    scrollView.isScrollEnabled = false
    scrollView.bounces = false
    return scrollView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    speechSynthesizer = AVSpeechSynthesizer()
    self.title = "따라쓰세요"
    NotificationCenter.default.addObserver(self, selector: #selector(TracingVC.goToNextLetter(_:)), name: Constants().NOTI_DRAW_COMPLETED, object: nil)
    view.addSubview(scrollView)
    
    navigationController?.setNavigationBarHidden(false, animated: true)
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      scrollView.snp.makeConstraints({ (make) in
        make.left.right.bottom.equalTo(self.view)
        make.top.equalTo(self.view).offset(44)
      })
      
      scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(characters.count), height: UIScreen.main.bounds.height - 44.0)
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getCharactersView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  func setCardInfo(index: Int) {
    let manager = CardManager.instance
    self.cardInfo = (manager, index)
  }
  
  func getCharactersView() {
    guard let cardInfo = cardInfo else { fatalError() }
    let selectedWord = cardInfo.0.cardAt(index: cardInfo.1).word
    for character in selectedWord {
      characters.append(character)
    }
    characterViews.removeAll()
    for i in 0..<characters.count {
      let view = LetterView(frame: CGRect(x: UIScreen.main.bounds.width * CGFloat(i), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 44.0), letter: String(characters[i]))
      characterViews.append(view)
      scrollView.addSubview(view)
    }
  }
  
  @objc func goToNextLetter(_ notification: NSNotification) {
    guard let cardInfo = cardInfo else { fatalError() }
    let selectedWord = cardInfo.0.cardAt(index: cardInfo.1).word
    let page = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
    if page < characterViews.count - 1 {
      UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.scrollView.contentOffset.x = self.scrollView.bounds.size.width * CGFloat(page + 1)}, completion: nil)
    } else if page == characterViews.count - 1 {
      let lastView = GameView(frame: CGRect(x: UIScreen.main.bounds.width * CGFloat(characterViews.count), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), word: selectedWord)
      scrollView.addSubview(lastView)
      UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.scrollView.contentOffset.x = self.scrollView.bounds.size.width * CGFloat(page + 1)}, completion: nil)
      synthesizeSpeech(fromString: selectedWord)
      audioPlayer.playSoundEffect(name: "cheering", extender: "wav")
    }
    
  }
  
  func synthesizeSpeech(fromString string:String) {
    let speechUtterence = AVSpeechUtterance(string: string)
    speechSynthesizer.speak(speechUtterence)
  }
  
}
