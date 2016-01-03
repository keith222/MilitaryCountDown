//
//  ViewController.swift
//  MilitaryCountDown
//
//  Created by Yang Tun-Kai on 2015/12/21.
//  Copyright © 2015年 Yang Tun-Kai. All rights reserved.
//

import UIKit
import iAd

class ViewController: UIViewController{
    
    
    @IBOutlet var circleChartView: UIView!
    @IBOutlet var percentLabel: UILabel!
    @IBOutlet var daysLabel: UILabel!
    
    //初始NSUserDefaults
    let userDefault = NSUserDefaults.standardUserDefaults()
    let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    let dateFormat: NSDateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //放iAD
        self.canDisplayBannerAds = true
        
        if(userDefault.stringForKey("entryDay") != nil && userDefault.stringForKey("quitDay") != nil){
            //取出userdefaults裡的日期
            dateFormat.dateFormat = "yyyy-MM-dd"
            let entryDay = dateFormat.dateFromString(userDefault.stringForKey("entryDay")!)
            let quitDay = dateFormat.dateFromString(userDefault.stringForKey("quitDay")!)
            
            //計算日期相減及比例
            let nowDays = calendar.components(.Day, fromDate: entryDay!, toDate: NSDate(), options: [])
            let durationDays = calendar.components(.Day, fromDate: entryDay!, toDate:quitDay!, options: [])
            let surplusDays = calendar.components(.Day, fromDate: NSDate(), toDate: quitDay!, options: [])
            var percentage = CGFloat(nowDays.day)/CGFloat(durationDays.day)
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .DecimalStyle
            percentage = CGFloat(formatter.numberFromString(formatter.stringFromNumber(percentage)!)!)
            self.percentLabel.text = formatter.stringFromNumber(percentage*100)!+"%"
            self.daysLabel.text = String(surplusDays.day)
            
            //加入circle chart
            addCircleView(self.circleChartView, duration: 0.5, fromValue: 0.0, toValue: percentage)
        }

        
    }
    
    override func viewDidAppear(animated: Bool) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewControllerWithIdentifier("DateSelect") as! DateSelectViewController
        
        //如果userdefault裡面沒有日期資料則跳出設定視窗
        if(userDefault.stringForKey("entryDay") == nil && userDefault.stringForKey("quitDay") == nil){
            self.presentViewController(resultViewController, animated:true, completion:nil)
        }

    }
    
    func addCircleView(myView: UIView, duration: NSTimeInterval, fromValue: CGFloat, toValue: CGFloat){

        //設定circlechart 的長寬
        let circleWidth = CGFloat(250)
        let circleHeight = circleWidth
        
        //畫出新的CircleView
        let circleView = CircleView(frame: CGRectMake(0,0,circleWidth,circleHeight))
        
        //設定circlechart線條顏色
        circleView.setStrokeColor(UIColor(red: 53.0/255.0, green: 193.0/255.0, blue: 78.0/255.0, alpha: 1).CGColor)
        
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
    
    @IBAction func unwindToCamera(segue:UIStoryboardSegue) {
    }

}

