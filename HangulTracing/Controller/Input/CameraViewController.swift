//
//  CameraViewController.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 8..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

class CameraViewController: UIViewController, BindableType {
  private let bag = DisposeBag()
  var viewModel: InputViewModel!
  private var captureSession: AVCaptureSession!
  private var cameraOutput: AVCapturePhotoOutput!
  private var previewLayer: AVCaptureVideoPreviewLayer!
  private lazy var cameraView: UIView = {
    let view = UIView()
    return view
  }()
  private lazy var capturedImgView: UIImageView = {
    let imgView = UIImageView()
    imgView.backgroundColor = UIColor(hex: "1EC545")
    imgView.layer.cornerRadius = 15
    imgView.clipsToBounds = true
    return imgView
  }()
  private lazy var saveBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.3548831371, blue: 0.08110601978, alpha: 1)
    btn.setTitle("SAVE", for: .normal)
    btn.layer.cornerRadius = 15
    btn.isHidden = true
    return btn
  }()
  private lazy var exitBtn: UIButton = {
    let btn = UIButton()
    btn.setImage(UIImage(named: "delete"), for: .normal)
    return btn
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(cameraView)
    view.addSubview(capturedImgView)
    view.addSubview(saveBtn)
    view.addSubview(exitBtn)
    
    cameraView.snp.makeConstraints({ (make) in
      make.edges.equalTo(self.view)
    })
    capturedImgView.snp.makeConstraints({ (make) in
      make.right.bottom.equalTo(self.view).offset(-20)
      make.height.equalTo(128)
      make.width.equalTo(75)
    })
    saveBtn.snp.makeConstraints({ (make) in
      make.height.equalTo(50)
      make.width.equalTo(75)
      make.top.equalTo(self.view).offset(20)
      make.right.equalTo(self.view).offset(-20)
    })
    exitBtn.snp.makeConstraints({ (make) in
      make.width.height.equalTo(50)
      make.top.left.equalTo(self.view).offset(8)
    })
  }
  
  func bindViewModel() {
    saveBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [unowned self] _ in
        if self.capturedImgView.image != nil {
          self.viewModel.dismissView()
        }
      })
      .disposed(by: bag)
    
    exitBtn.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.dismissView()
      })
      .disposed(by: bag)
    
    cameraView.rx.tapGesture()
      .throttle(0.5, scheduler: MainScheduler.instance)
      .filter{ [unowned self] recong in recong.numberOfTapsRequired == 1 }
      .subscribe(onNext: { [unowned self] _ in
        self.cameraView.isUserInteractionEnabled = false
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg,
                                                       AVVideoCompressionPropertiesKey: [AVVideoQualityKey : NSNumber(value: 0.1)]])
        settings.previewPhotoFormat = settings.embeddedThumbnailPhotoFormat
        self.cameraOutput.capturePhoto(with: settings, delegate: self)
      })
      .disposed(by: bag)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    previewLayer.frame = cameraView.bounds
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    captureSession = AVCaptureSession()
    captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
    let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
    
    do {
      //input
      let input = try AVCaptureDeviceInput(device: backCamera!)
      if captureSession.canAddInput(input) {
        captureSession.addInput(input)
      }
      
      //output
      cameraOutput = AVCapturePhotoOutput()
      if captureSession.canAddOutput(cameraOutput) {
        captureSession.addOutput(cameraOutput)
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //aspect ratio
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraView.layer.addSublayer(previewLayer)
        captureSession.startRunning()
      }
    } catch {
      debugPrint("could not setup camera :", error.localizedDescription)
    }
  }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    if let error = error {
      debugPrint(error)
    } else {
      let photoData = photo.fileDataRepresentation()
      self.viewModel.capturedPhotoSubject.onNext(photoData!)
      let image = UIImage(data: photoData!)
      self.capturedImgView.image = image
      cameraView.isUserInteractionEnabled = true
      saveBtn.isHidden = false
    }
  }
}
