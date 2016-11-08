//
//  CameraViewController.swift
//  MilitaryCountDown
//
//  Created by Yang Tun-Kai on 2015/12/29.
//  Copyright © 2015年 Yang Tun-Kai. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    @IBOutlet var photoButton: UIButton!
    @IBOutlet var switchButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    //AVFoundation核心
    let captureSession = AVCaptureSession()
    
    //設定相機
    var backFacingCamera: AVCaptureDevice?
    var frontFaceingCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?

    //靜態影像
    var stillImageOutput: AVCaptureStillImageOutput?
    var stillImage: UIImage?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var zoomGestureRecognizer = UIPinchGestureRecognizer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoButton.layer.borderColor = UIColor.white.cgColor
        self.photoButton.setTitleColor(UIColor.darkGray, for: .highlighted)
        self.backButton.layer.borderColor = UIColor.white.cgColor
        
        //高解析度照相
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
        for device in devices {
            if device.position == AVCaptureDevicePosition.back{
                self.backFacingCamera = device
            }else if device.position == AVCaptureDevicePosition.front{
                self.frontFaceingCamera = device
            }
        }
        self.currentDevice = frontFaceingCamera
        
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: self.currentDevice)
            captureSession.addInput(captureDeviceInput)
        }catch let error as NSError{
            print(error)
        }
        
        //靜態影像設定
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        captureSession.addOutput(stillImageOutput)
        
        //建構相機view
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        self.view.bringSubview(toFront: self.photoButton)
        self.view.bringSubview(toFront: self.switchButton)
        self.view.bringSubview(toFront: self.backButton)
        captureSession.startRunning()
        // Do any additional setup after loading the view.
    }
    
    //手勢放大
    func zoomGesture() {
        if self.zoomGestureRecognizer.state == UIGestureRecognizerState.changed{
            if let zoomFactor = self.currentDevice?.videoZoomFactor{
                var newZoomFactor:CGFloat?
                if zoomFactor < 5.0{
                    newZoomFactor = min(zoomFactor + 1.0, 5.0)
                    do {
                        try self.currentDevice?.lockForConfiguration()
                        self.currentDevice?.ramp(toVideoZoomFactor: newZoomFactor!, withRate: 1.0)
                        self.currentDevice?.unlockForConfiguration()
                    } catch {
                        print(error)
                    }
                }else if zoomFactor > 1.0{
                    newZoomFactor = max(zoomFactor - 1.0, 1.0)
                    do {
                        try self.currentDevice?.lockForConfiguration()
                        self.currentDevice?.ramp(toVideoZoomFactor: newZoomFactor!, withRate: 1.0)
                        self.currentDevice?.unlockForConfiguration()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto"{
            let photoViewController = segue.destination as! PhotoViewController
            photoViewController.image = self.stillImage
        }
    }
    
    @IBAction func switchButton(_ sender: AnyObject) {
        captureSession.beginConfiguration()
        
        //變更相機位置
        let newDevice = (self.currentDevice?.position == AVCaptureDevicePosition.back) ? self.frontFaceingCamera : self.backFacingCamera
        
        //移除輸入
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        //變更為新的輸入
        let cameraInput:AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice)
        } catch {
            print(error)
            return
        }
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        self.currentDevice = newDevice
        captureSession.commitConfiguration()
        
    }
    
    @IBAction func captureButton(_ sender: AnyObject) {
        let videoConnection = self.stillImageOutput?.connection(withMediaType: AVMediaTypeVideo)
        
        self.stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {
            (imageDataSampleBuffer, error)-> Void in
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
            self.stillImage = UIImage(data: imageData!)
            self.performSegue(withIdentifier: "showPhoto", sender: self)
        })
    }
}
