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

class CategoryViewController: UIViewController {
  private let bag = DisposeBag()
  var viewModel: CategoryViewModel!
  let transition = PopAnimator()
  private weak var selectedCell: CategoryCell?
  var categoryManager = CategoryManager.instance
  private var didSetupConstraints = false
  lazy var categoryDataProvider: CategoryDataProvider = {
    let provider = CategoryDataProvider()
    return provider
  }()
  lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
    view.backgroundColor = UIColor.clear
    view.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
    view.delegate = categoryDataProvider
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
    title = "단어장"
    
    WordCards().setupDefaultCards()
    view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    view.addSubview(collectionView)
    view.addSubview(showBtn)
    
    navigationController?.delegate = self
    navigationController?.setNavigationBarHidden(true, animated: true)
    view.setNeedsUpdateConstraints()
    bindViewModel()
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      collectionView.snp.makeConstraints({ (make) in
        make.edges.equalTo(view)
      })
      showBtn.snp.makeConstraints({ (make) in
        make.width.height.equalTo(70)
        make.right.bottom.equalTo(self.view).offset(-20)
      })
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  func bindViewModel() {
    showBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [unowned self] _ in
        self.showBtnTapped()
      })
      .disposed(by: bag)
    
    viewModel.categories()
      .bind(to: collectionView.rx.items) { [unowned self]
        (collectionView: UICollectionView, index: Int, item: Category) in
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier,
                                                         for: IndexPath(item: index, section: 0)) as? CategoryCell {
          cell.configCell(category: item, cellMode: CellMode.normal, action: self.viewModel.onDelete(index: index))
          return cell
        }
        return CategoryCell()
      }
      .disposed(by: bag)
    
  }
  
  func showBtnTapped() {
    let popUpBtnVC = PopUpBtnVC()
    popUpBtnVC.setParentVC(vc: self)
    popUpBtnVC.modalPresentationStyle = .overFullScreen
    popUpBtnVC.modalTransitionStyle = .crossDissolve
    present(popUpBtnVC, animated: true, completion: nil)
  }
  
  func pushCardListVC(indexPath: IndexPath) {
    let category = categoryManager.categories[indexPath.item]
    let manager = CardManager.instance
    manager.changeCategory(category: category.title)
    let cardListVC = CardListVC()
    cardListVC.transitioningDelegate = self
    let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
    self.selectedCell = cell
    navigationController?.pushViewController(cardListVC, animated: true)
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    collectionView.collectionViewLayout.invalidateLayout()
  }

}

extension CategoryViewController: UIViewControllerTransitioningDelegate {
}

extension CategoryViewController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    //push
    if fromVC is CategoryViewController, toVC is CardListVC {
      guard let selectedCell = selectedCell else { fatalError() }
      transition.originFrame = selectedCell.convert(selectedCell.bounds, to: nil)
      transition.presenting = true
      return transition
    }
    //pop
    else if fromVC is CardListVC, toVC is CategoryViewController {
      transition.presenting = false
      return transition
    }
    return nil
  }
  
}

