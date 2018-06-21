//
//  CategoryViewController.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 18..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class CategoryViewController: UIViewController, BindableType {
  private let bag = DisposeBag()
  var viewModel: CategoryViewModel!
  let transition = PopAnimator()
  private weak var selectedCell: CategoryCell?
  private var itemsPerRow: CGFloat = 2
  private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
  
  lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: self.view.frame,
                                collectionViewLayout: UICollectionViewFlowLayout())
    view.backgroundColor = UIColor.clear
    view.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
    view.delegate = self
    return view
  }()
  private lazy var showBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = UIColor.white
    btn.layer.cornerRadius = 35
    btn.setImage(UIImage(named: "showBtn"), for: .normal)
    return btn
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  func setupView() {
    title = "단어장"
    view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    view.addSubview(collectionView)
    view.addSubview(showBtn)
    collectionView.snp.makeConstraints({ (make) in
      if #available(iOS 11.0, *) {
        make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
        make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
      } else {
        make.top.equalTo(view)
        make.bottom.equalTo(view)
        make.left.equalTo(view)
        make.right.equalTo(view)
      }
    })
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
  }
  
  func bindViewModel() {
    
    showBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.changeCellMode(toNormal: true)
        self.viewModel.goToPopUpScene()
      })
      .disposed(by: bag)
    
    viewModel.categories()
      .bind(to: collectionView.rx.items) { [unowned self]
        (collectionView: UICollectionView, index: Int, item: Category) in
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier,
                                                         for: IndexPath(item: index, section: 0)) as? CategoryCell {
          cell.configCell(category: item,
                          cellMode: self.viewModel.cellMode.value,
                          action: self.onDelete(categoryTitle: item.title))
          return cell
        }
        return CategoryCell()
      }
      .disposed(by: bag)
    
    viewModel.cellMode
      .asObservable()
      .subscribe(onNext: { [unowned self] _ in
        self.collectionView.reloadData()
      })
      .disposed(by: bag)
    
    collectionView.rx.itemSelected
      .subscribe(onNext: { [unowned self] indexPath in
        let cell = self.collectionView.cellForItem(at: indexPath) as! CategoryCell
        self.selectedCell = cell
        self.viewModel.audioPlayer.playSoundEffect(name: "enter", extender: "wav")
      })
      .disposed(by: bag)
    
    collectionView.rx.modelSelected(Category.self)
      .subscribe(onNext: { [unowned self] category in
        self.viewModel.goToCardScene(category: category)
      })
      .disposed(by: bag)
  }
  
  func onDelete(categoryTitle: String) -> CocoaAction {
    return CocoaAction {
      return Observable<()>.create { [unowned self] observer in
        let alertVC = UIAlertController(title: "알림",
                                        message: "해당 카테고리의 단어들이 모두 삭제됩니다. 정말 삭제하시겠습니까?",
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
          self.viewModel.removeCategoryAt(title: categoryTitle)
            .subscribe(onCompleted: {
              self.viewModel.changeCellMode(toNormal: true)
              observer.onCompleted()
            })
            .disposed(by: self.bag)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {_ in
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
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    if traitCollection.horizontalSizeClass == .compact {
      itemsPerRow = 2
    } else {
      itemsPerRow = 3
    }
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  override func viewWillTransition(to size: CGSize,
                                   with coordinator: UIViewControllerTransitionCoordinator) {
    collectionView.collectionViewLayout.invalidateLayout()
  }
}

extension CategoryViewController: UIViewControllerTransitioningDelegate {
}

extension CategoryViewController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    //push
    if fromVC is CategoryViewController, toVC is CardViewController {
      guard let selectedCell = selectedCell else { fatalError() }
      transition.originFrame = selectedCell.convert(selectedCell.bounds, to: nil)
      transition.presenting = true
      return transition
    }
    //pop
    else if fromVC is CardViewController, toVC is CategoryViewController {
      transition.presenting = false
      return transition
    }
    return nil
  }
}

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = UIScreen.main.bounds.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
