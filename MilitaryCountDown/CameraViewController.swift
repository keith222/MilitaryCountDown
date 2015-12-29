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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //高解析度照相
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        for device in devices {
            if device.position == AVCaptureDevicePosition.Front{
                frontFaceingCamera = device
            }else if device.position == AVCaptureDevicePosition.Back{
                backFacingCamera = device
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
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
