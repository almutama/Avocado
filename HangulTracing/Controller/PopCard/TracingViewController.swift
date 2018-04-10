//
//  TracingViewController.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 7..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

class TracingViewController: UIViewController, BindableType {
  
  var viewModel: PopCardViewModel!
  private let bag = DisposeBag()
  private var characters = [Character]()
  private var characterViews = [LetterView]()
  private var speechSynthesizer = AVSpeechSynthesizer()
  private var audioPlayer = SoundPlayer()
  
  private lazy var topView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.clear
    return view
  }()
  private lazy var topLabel: UILabel = {
    let view = UILabel()
    view.text = "따라쓰세요"
    return view
  }()
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.isPagingEnabled = true
    scrollView.isScrollEnabled = false
    scrollView.bounces = false
    return scrollView
  }()
  
  private lazy var backButton: UIButton = {
    let view = UIButton()
    view.setTitle("BACK", for: UIControlState.normal)
    view.setTitleColor(UIColor.black, for: UIControlState.normal)
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(topView)
    topView.addSubview(backButton)
    topView.addSubview(topLabel)
    view.addSubview(scrollView)
    
    topView.snp.makeConstraints { (make) in
      make.height.equalTo(44)
      if #available(iOS 11.0, *) {
        make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
        make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
        make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      } else {
        make.left.equalTo(view)
        make.right.equalTo(view)
        make.top.equalTo(view)
      }
      
    }
    backButton.snp.makeConstraints { (make) in
      backButton.sizeToFit()
      make.left.equalTo(topView).offset(10)
      make.centerY.equalTo(topView)
    }
    topLabel.snp.makeConstraints { (make) in
      topLabel.sizeToFit()
      make.center.equalTo(topView)
    }
    scrollView.snp.makeConstraints({ (make) in
      make.top.equalTo(topView.snp.bottom)
      if #available(iOS 11.0, *) {
        make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
        make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
        make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      } else {
        make.left.equalTo(view)
        make.right.equalTo(view)
        make.bottom.equalTo(view)
      }
    })
    
    scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(characters.count), height: UIScreen.main.bounds.height - 44.0)
  }
  
  func bindViewModel() {
    backButton.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.dismissView()
      })
      .disposed(by: bag)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getCharactersView()
  }
  
  func getCharactersView() {
    let selectedWord = viewModel.selectedCard.word
    for character in selectedWord {
      characters.append(character)
    }
    characterViews.removeAll()
    for i in 0..<characters.count {
      let view = LetterView(frame: CGRect(x: UIScreen.main.bounds.width * CGFloat(i), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 44.0), letter: String(characters[i]))
      characterViews.append(view)
      scrollView.addSubview(view)
      view.completeSubject.asObservable()
        .subscribe(onNext: { [unowned self] _ in
          self.goToNextLetter()
        })
        .disposed(by: bag)
    }
  }
  
  func goToNextLetter() {
    let selectedWord = viewModel.selectedCard.word
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
