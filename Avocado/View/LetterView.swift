//
//  LetterView.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 7..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

class LetterView: UIView, Speakable {
  let completeSubject = PublishSubject<Bool>()
  private let bag = DisposeBag()
  private var audioPlayer = SoundPlayer()
  private var letter: String!
  private var path: UIBezierPath!
  private var screenPointsSet: Set<CGPoint>!
  private var letterSet: Set<CGPoint>!
  private var drawSet = Set<CGPoint>()
  private var unionPath = UIBezierPath()
  private lazy var speakerBtn: UIButton = {
    let btn = UIButton()
    btn.setImage(UIImage(named: "speaker"), for: .normal)
    return btn
  }()
  internal lazy var speechSynthesizer = AVSpeechSynthesizer()
  
  init(frame: CGRect, letter: String) {
    self.letter = letter
    super.init(frame: frame)
    
    setupView()
    
    screenPointsSet = getScreenPointsSet()
    bindViewModel()
  }
  
  func bindViewModel() {
    speakerBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [unowned self] _ in
        self.synthesizeSpeech(fromString: self.letter)
      })
      .disposed(by: bag)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    path = UIBezierPath(rect: rect)
    path.lineWidth = 10
    
    let font = UIFont(name: "NanumBarunpen", size: UIScreen.main.bounds.width * 4 / 5)!
    var unichars = [UniChar](letter.utf16)
    var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
    
    let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
    
    if gotGlyphs {
      let cgpath = CTFontCreatePathForGlyph(font, glyphs[0], nil)!
      path.cgPath = cgpath
      path.apply(CGAffineTransform(scaleX: 1, y: -1))
      path.apply(CGAffineTransform(translationX: (UIScreen.main.bounds.width - UIScreen.main.bounds.width * 4 / 5),
                                   y: UIScreen.main.bounds.height * 1 / 2))
      
      UIColor.white.setStroke()
      path.stroke()
      UIColor.clear.setFill()
      path.fill()
    }
    letterSet = getContainingPoints(tempSet: screenPointsSet, path: path)
  }
  
  func setupView() {
    backgroundColor = UIColor(patternImage: UIImage(named: "blackBoard")!)
    addSubview(speakerBtn)
    speakerBtn.snp.makeConstraints { (make) in
      make.width.height.equalTo(50)
      make.top.equalTo(self).offset(10)
      make.right.equalTo(self).offset(-10)
    }
    
  }
  
  func getScreenPointsSet() -> Set<CGPoint> {
    var tempSet = Set<CGPoint>()
    let viewWidth = Int(self.frame.width / 10)
    let viewHeight = Int(self.frame.height / 10)
    
    for w in 0..<viewWidth {
      for h in 0..<viewHeight {
        let x = CGFloat(w * 10)
        let y = CGFloat(h * 10)
        let point = CGPoint(x: x, y: y)
        tempSet.insert(point)
      }
    }
    return tempSet
  }
  
  func getContainingPoints(tempSet: Set<CGPoint>, path: UIBezierPath) -> Set<CGPoint> {
    var pointsSet = Set<CGPoint>()
    for point in tempSet {
      if path.contains(point) {
        pointsSet.insert(point)
      }
    }
    return pointsSet
  }
  
  func addLine(_ center: CGPoint) {
    let r: CGFloat = UIScreen.main.bounds.width / 20
    let path = UIBezierPath()
    
    path.addArc(withCenter: center, radius: r, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = path.cgPath
    shapeLayer.fillColor = UIColor.white.withAlphaComponent(0.8).cgColor
    
    shapeLayer.lineWidth = UIScreen.main.bounds.width / 100
    unionPath.append(path)
    DispatchQueue.main.async {
      self.layer.addSublayer(shapeLayer)
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let currentPoint = touch.location(in: self)
      if path.contains(currentPoint) {
        addLine(currentPoint)
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    audioPlayer.playSoundEffect(name: "chalk", extender: "mp3")
    drawSet = getContainingPoints(tempSet: letterSet, path: unionPath)
    if drawSet.count * 100 / letterSet.count >= 90 {
      self.completeSubject.onNext(true)
    }
  }
  
}
