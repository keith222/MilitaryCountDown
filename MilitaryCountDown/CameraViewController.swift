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
        
        self.photoButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.photoButton.setTitleColor(UIColor.darkGrayColor(), forState: .Highlighted)
        self.backButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        //高解析度照相
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        for device in devices {
            if device.position == AVCaptureDevicePosition.Back{
                self.backFacingCamera = device
            }else if device.position == AVCaptureDevicePosition.Front{
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
        self.view.bringSubviewToFront(self.photoButton)
        self.view.bringSubviewToFront(self.switchButton)
        self.view.bringSubviewToFront(self.backButton)
        captureSession.startRunning()
        // Do any additional setup after loading the view.
    }
    
    //手勢放大
    func zoomGesture() {
        if self.zoomGestureRecognizer.state == UIGestureRecognizerState.Changed{
            if let zoomFactor = self.currentDevice?.videoZoomFactor{
                var newZoomFactor:CGFloat?
                if zoomFactor < 5.0{
                    newZoomFactor = min(zoomFactor + 1.0, 5.0)
                    do {
                        try self.currentDevice?.lockForConfiguration()
                        self.currentDevice?.rampToVideoZoomFactor(newZoomFactor!, withRate: 1.0)
                        self.currentDevice?.unlockForConfiguration()
                    } catch {
                        print(error)
                    }
                }else if zoomFactor > 1.0{
                    newZoomFactor = max(zoomFactor - 1.0, 1.0)
                    do {
                        try self.currentDevice?.lockForConfiguration()
                        self.currentDevice?.rampToVideoZoomFactor(newZoomFactor!, withRate: 1.0)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPhoto"{
            let photoViewController = segue.destinationViewController as! PhotoViewController
            photoViewController.image = self.stillImage
        }
    }
    
    @IBAction func switchButton(sender: AnyObject) {
        captureSession.beginConfiguration()
        
        //變更相機位置
        let newDevice = (self.currentDevice?.position == AVCaptureDevicePosition.Back) ? self.frontFaceingCamera : self.backFacingCamera
        
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
    
    @IBAction func captureButton(sender: AnyObject) {
        let videoConnection = self.stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo)
        
        self.stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
            (imageDataSampleBuffer, error)-> Void in
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
            self.stillImage = UIImage(data: imageData)
            self.performSegueWithIdentifier("showPhoto", sender: self)
        })
    }
}
