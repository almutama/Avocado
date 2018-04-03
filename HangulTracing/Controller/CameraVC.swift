//
//  CameraVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 8..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {
  
  private var didSetupConstraints = false
  private var spinner: UIActivityIndicatorView!
  private var captureSession: AVCaptureSession!
  private var cameraOutput: AVCapturePhotoOutput!
  private var previewLayer: AVCaptureVideoPreviewLayer!
  private var photoData: Data?
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
    return btn
  }()
  private lazy var exitBtn: UIButton = {
    let btn = UIButton()
    btn.setImage(UIImage(named: "delete"), for: .normal)
    return btn
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    spinner = UIActivityIndicatorView()
    view.addSubview(cameraView)
    view.addSubview(capturedImgView)
    view.addSubview(saveBtn)
    view.addSubview(exitBtn)
    view.addSubview(spinner)
    spinner.isHidden = true
    saveBtn.isHidden = true
    saveBtn.addTarget(self, action: #selector(CameraVC.saveBtnTapped(_:)), for: .touchUpInside)
    exitBtn.addTarget(self, action: #selector(CameraVC.exitBtnTapped(_:)), for: .touchUpInside)
    view.setNeedsUpdateConstraints()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    previewLayer.frame = cameraView.bounds
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
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
      spinner.snp.makeConstraints({ (make) in
        make.width.height.equalTo(50)
        make.center.equalTo(self.view)
      })
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCameraView))
    tap.numberOfTapsRequired = 1
    
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
        cameraView.addGestureRecognizer(tap)
        captureSession.startRunning()
      }
    } catch {
      debugPrint("could not setup camera :", error.localizedDescription)
    }
  }
  
  @objc func didTapCameraView() {
    cameraView.isUserInteractionEnabled = false
    
    //let settings = AVCapturePhotoSettings()
    let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg,
                                                         AVVideoCompressionPropertiesKey: [AVVideoQualityKey : NSNumber(value: 0.1)]])
    settings.previewPhotoFormat = settings.embeddedThumbnailPhotoFormat
    cameraOutput.capturePhoto(with: settings, delegate: self)
  }
  
  @objc func saveBtnTapped(_ sender: UIButton) {
    if capturedImgView.image != nil {
      self.spinner.isHidden = false
      self.spinner.startAnimating()
      self.saveBtn.isEnabled = false
      NotificationCenter.default.post(name: Constants().NOTI_PHOTO_SELECTED, object: nil, userInfo: ["photoData":photoData])
      dismiss(animated: true, completion: {
        self.saveBtn.isEnabled = true
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
      })
    }
  }
  @objc func exitBtnTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}

extension CameraVC: AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    if let error = error {
      debugPrint(error)
    } else {
      photoData = photo.fileDataRepresentation()
      let image = UIImage(data: photoData!)
      self.capturedImgView.image = image
      cameraView.isUserInteractionEnabled = true
      saveBtn.isHidden = false
    }
  }
}
