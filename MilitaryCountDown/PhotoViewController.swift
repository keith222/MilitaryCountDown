//
//  PhotoViewController.swift
//  MilitaryCountDown
//
//  Created by Yang Tun-Kai on 2016/1/1.
//  Copyright © 2016年 Yang Tun-Kai. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var previewImage: UIImageView!
    @IBOutlet var circleChartView: UIView!
    @IBOutlet var percentLabel: UILabel!
    @IBOutlet var daysLabel: UILabel!
    @IBOutlet var sentenseLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    //初始NSUserDefaults
    let userDefault = NSUserDefaults.standardUserDefaults()
    let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    
    let dateFormat: NSDateFormatter = NSDateFormatter()
    var sentensePicker: UIPickerView = UIPickerView()
    //國軍金句名言
    let sentenseArray = ["學長好","很老了ㄋㄟ","我破月啦（入伍）","我破百啦（入伍）","我破月啦","我破百啦","報告，新兵請示入列","注意是不會看前面喔","好重的菜味","歡樂無線，體力有線","舉手答有，手是不會打直是不是！","唱歌答數，腳不會抬高是吧","菜比八！！","我在強姦地球！","菜，不是該死。而是罪該萬死。","這禮拜放么八還是洞八阿","一梯差三步，你要站多遠？","一生甲駕，終生...","動作暫停～","寢室熄燈","現在時間，部隊起床","注意~媽的!注意還動阿","你這個菜逼八！菜蟲爬滿身了！","注意！叫注意還動啊！","倒背包30秒，講完還有20秒，開始！","菜渣集中!!!!","其實我不想那麼快退伍呀！","放假要去哪裡","親、愛、精、誠","加強磨練，永遠忠誠","一路！服從！","風雲起，山河動～","六查開始，幹部出列！","國家有綱常，軍隊有...","一二，一二，一N"]
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.previewImage.image = image
        self.sentensePicker.delegate = self
        self.sentensePicker.dataSource = self
        self.sentensePicker.frame = CGRectMake(0, self.view.bounds.height - 130, self.view.bounds.width, 130)
        self.sentensePicker.backgroundColor = UIColor.whiteColor()
        self.saveButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.cancelButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.sentenseLabel.userInteractionEnabled = true
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "sentensePicker:")
        self.sentenseLabel.addGestureRecognizer(tapGesture)
        
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
        // Do any additional setup after loading the view.
    }
    //label 手勢事件
    func sentensePicker(sender:UITapGestureRecognizer){
        self.view.addSubview(self.sentensePicker)
    }
    //UIPicker生成
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.sentenseArray.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.sentenseArray[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sentenseLabel.text = self.sentenseArray[row]
        pickerView.removeFromSuperview()
    }
    
    func addCircleView(myView: UIView, duration: NSTimeInterval, fromValue: CGFloat, toValue: CGFloat){
        //設定circlechart 的長寬
        let circleWidth = CGFloat(100)
        let circleHeight = circleWidth
        
        //畫出新的CircleView
        let circleView = CircleView(frame: CGRectMake(0,0,circleWidth,circleHeight))
        
        //設定circlechart線條顏色
        circleView.setStrokeColor(UIColor(red: 43.0/255.0, green: 236.0/255.0, blue: 127.0/255.0, alpha: 0.8).CGColor)
        
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
