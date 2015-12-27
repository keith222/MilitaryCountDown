//
//  ViewController.swift
//  MilitaryCountDown
//
//  Created by Yang Tun-Kai on 2015/12/21.
//  Copyright © 2015年 Yang Tun-Kai. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    
    @IBOutlet var circleChartView: UIView!
    @IBOutlet var percentLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let userDefault = NSUserDefaults.standardUserDefaults()
        print(userDefault.stringForKey("entryDay"))
        print(userDefault.stringForKey("quitDay"))
        
    }
    
    func adCircleView(myView: UIView, isForeground: Bool, duration: NSTimeInterval, fromValue: CGFloat, toValue: CGFloat){
        //設定circlechart 的長寬
        let circleWidth = CGFloat(250)
        let circleHeight = circleWidth
        
        //畫出新的CircleView
        let circleView = CicleView(frame: CGRectMake(0,0,circleWidth,circleHeight))
        
        if(isForeground == true){
            //設定circlechart線條顏色
            circleView.setStrokeColor(UIColor(red: 53.0/255.0, green: 193.0/255.0, blue: 78.0/255.0, alpha: 1).CGColor)
        }
        
        myView.addSubview(circleView)
        
        //初始圓圈從0度(上）開始畫
        circleView.transform = CGAffineTransformMakeRotation(-1.56)
        
        //繪圖動畫
        circleView.animateCircleTo(duration, fromValue: fromValue, toValue: toValue)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

