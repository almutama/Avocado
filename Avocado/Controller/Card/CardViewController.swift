//
//  CardViewController.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 8..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class CardViewController: UIViewController, BindableType {
  private let bag = DisposeBag()
  var viewModel: CardViewModel!
  private var columns: Int = 2
  private var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
  var selectedCell: WordCardCell?
  private let transition = PopAnimator()
  lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: CGRect(x: 0, y: 0,
                                              width: UIScreen.main.bounds.width,
                                              height: UIScreen.main.bounds.height),
                                collectionViewLayout: PinterestLayout(numberOfColumns: columns,
                                                                      layoutDelegate: self))
    view.backgroundColor = UIColor.clear
    view.register(WordCardCell.self, forCellWithReuseIdentifier: WordCardCell.reuseIdentifier)
    return view
  }()
  private lazy var showBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = UIColor.white
    btn.layer.cornerRadius = 35
    btn.setImage(UIImage(named: "showBtn"), for: .normal)
    return btn
  }()
  private lazy var indicateLabel: UILabel = {
    let label = UILabel()
    label.text = "Swipe down to exit"
    label.textColor = UIColor.lightGray
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  func setupView() {
    view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    view.addSubview(collectionView)
    view.addSubview(showBtn)
    view.addSubview(indicateLabel)
    
    transition.dismissCompletion = {
      self.selectedCell?.isHidden = false
    }
    
    collectionView.snp.makeConstraints { make in
      if #available(iOS 11.0, *) {
        make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
        make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
      } else {
        make.edges.equalTo(view)
      }
    }
    collectionView.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
    showBtn.snp.makeConstraints({ (make) in
      make.width.height.equalTo(70)
      if #available(iOS 11.0, *) {
        make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
        make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
      } else {
        make.right.equalTo(view).offset(-20)
        make.bottom.equalTo(view).offset(-20)
      }
    })
    indicateLabel.snp.makeConstraints { (make) in
      indicateLabel.sizeToFit()
      make.centerX.equalTo(view)
      if #available(iOS 11.0, *) {
        make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      } else {
        make.top.equalTo(view)
      }
    }
  }
  
  func bindViewModel() {
    title = viewModel.selectedCategory.title
    
    viewModel.cards()
      .bind(to: collectionView.rx.items) { [unowned self]
        (collectionView: UICollectionView, index: Int, item: WordCard) in
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCardCell.reuseIdentifier,
                                                         for: IndexPath(item: index, section: 0)) as? WordCardCell {
          cell.configCell(card: item,
                          cellMode: self.viewModel.cellMode.value,
                          action: self.onDelete(cardWord: item.word))
          return cell
        }
        return WordCardCell()
      }
      .disposed(by: bag)
    
    viewModel.cellMode
      .subscribe(onNext: { [unowned self] _ in
        self.collectionView.reloadData()
      })
      .disposed(by: bag)
    
    showBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.changeCellMode(toNormal: true)
        self.viewModel.goToPopUpScene()
      })
      .disposed(by: bag)
    
    collectionView.rx.panGesture()
      .subscribe(onNext: { [unowned self] recognizer in
        self.swipeView(recognizer: recognizer)
      })
      .disposed(by: bag)
    
    collectionView.rx.itemSelected
      .subscribe(onNext: { [unowned self] indexPath in
        let cell = self.collectionView.cellForItem(at: indexPath) as! WordCardCell
        self.selectedCell = cell
        self.viewModel.audioPlayer.playSoundEffect(name: "enter", extender: "wav")
        let imgHeight = cell.imgView.frame.height
        let imgWidth = cell.imgView.frame.width
        let viewWidth = UIScreen.main.bounds.width * 2 / 3
        let viewHeight = imgHeight * viewWidth / imgWidth
        let centerX = UIScreen.main.bounds.width / 2
        let centerY = UIScreen.main.bounds.height / 2
        let rect = CGRect(x: centerX - viewWidth / 2,
                          y: centerY - viewHeight / 2,
                          width: viewWidth,
                          height: viewHeight)
        let card = self.viewModel.cardAt(index: indexPath.item)
        self.viewModel.goToPopCardScene(rect: rect, card: card)
      })
      .disposed(by: bag)
  }
  
  func onDelete(cardWord: String) -> CocoaAction {
    return CocoaAction {
      return Observable<()>.create { [unowned self] observer in
        let alertVC = UIAlertController(title: "알림",
                                        message: "해당 카드가 삭제됩니다. 정말 삭제하시겠습니까?",
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Delete",
                                        style: .destructive,
                                        handler: { _ in
          self.viewModel.removeCardAt(word: cardWord)
            .subscribe(onCompleted: {
              self.viewModel.changeCellMode(toNormal: true)
              observer.onCompleted()
            })
            .disposed(by: self.bag)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel",
                                        style: .default,
                                        handler: {_ in
          self.viewModel.changeCellMode(toNormal: true)
          observer.onCompleted()
        }))
        self.present(alertVC, animated: true, completion: nil)
        return Disposables.create {
          self.dismiss(animated: true, completion: nil)
        }
      }
    }
  }
  
  func swipeView(recognizer: UIPanGestureRecognizer) {
    if collectionView.contentOffset.y <= -collectionView.contentInset.top {
      let touchPoint = recognizer.location(in: self.view?.window)
      if recognizer.state == UIGestureRecognizerState.began {
        initialTouchPoint = touchPoint
      } else if recognizer.state == UIGestureRecognizerState.changed {
        if touchPoint.y - initialTouchPoint.y > 0 {
          self.view.frame = CGRect(x: 0,
                                   y: touchPoint.y - initialTouchPoint.y,
                                   width: self.view.frame.size.width,
                                   height: self.view.frame.size.height)
        }
      } else if recognizer.state == UIGestureRecognizerState.ended || recognizer.state == UIGestureRecognizerState.cancelled {
        if touchPoint.y - initialTouchPoint.y > 100 {
          self.viewModel.dismissCardView()
        } else {
          UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x: 0,
                                     y: 0,
                                     width: self.view.frame.size.width,
                                     height: self.view.frame.size.height)
          })
        }
      }
    }
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    if traitCollection.horizontalSizeClass == .compact {
      columns = 2
      collectionView.collectionViewLayout = PinterestLayout(numberOfColumns: 2, layoutDelegate: self)
    } else {
      columns = 3
      collectionView.collectionViewLayout = PinterestLayout(numberOfColumns: 3, layoutDelegate: self)
    }
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    collectionView.collectionViewLayout.invalidateLayout()
  }
}

extension CardViewController: UIViewControllerTransitioningDelegate {
}

extension CardViewController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    //push
    if fromVC is CardViewController, toVC is PopCardViewController {
      guard let selectedCell = selectedCell else { fatalError() }
      transition.originFrame = selectedCell.convert(selectedCell.bounds, to: nil)
      transition.presenting = true
      return transition
    }
      //pop
    else if fromVC is PopCardViewController, toVC is CardViewController {
      transition.presenting = false
      return transition
    }
    return nil
  }
}

//scroll과 pangesture 가 동시에 인식되도록
extension CardViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}

extension CardViewController: PinterestLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    let imgData =  viewModel.cardAt(index: indexPath.item).imgData
    guard let image = UIImage(data: imgData) else { return 0 }
    let ratio = image.size.width / image.size.height
    let leftRightInset: CGFloat = 20.0
    let cellPadding: CGFloat = 6.0
    let cellWidth = (UIScreen.main.bounds.width - leftRightInset - cellPadding) / CGFloat(columns)
    return cellWidth / ratio
  }
}
