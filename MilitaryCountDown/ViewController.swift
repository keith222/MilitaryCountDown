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
    
    //初始NSUserDefaults
    let userDefault = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newToValue: CGFloat = 0.5 as CGFloat
        addCircleView(self.circleChartView, isForeground: true, duration: 0.5, fromValue: 0.0, toValue: newToValue)
        // Do any additional setup after loading the view, typically from a nib.
    
    }
    
    override func viewDidAppear(animated: Bool) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewControllerWithIdentifier("DateSelect") as! DateSelectViewController
        
        //如果userdefault裡面沒有日期資料則跳出設定視窗
        if(userDefault.stringForKey("entryDay")! == "" && userDefault.stringForKey("quitDay")! == ""){
            self.presentViewController(resultViewController, animated:true, completion:nil)
        }

    }
    
    func addCircleView(myView: UIView, isForeground: Bool, duration: NSTimeInterval, fromValue: CGFloat, toValue: CGFloat){
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

