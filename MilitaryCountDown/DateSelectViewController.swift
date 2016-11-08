//
//  DateSelectViewController.swift
//  MilitaryCountDown
//
//  Created by Yang Tun-Kai on 2015/12/22.
//  Copyright © 2015年 Yang Tun-Kai. All rights reserved.
//

import UIKit
import iAd

class DateSelectViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var entryDate: UITextField!
    @IBOutlet var decreaseDays: UITextField!
    @IBOutlet var quitDate: UITextField!
    @IBOutlet var sendButton: UIButton!
    
    let entryDatePicker:UIDatePicker = UIDatePicker()
    let quitDatePicker:UIDatePicker = UIDatePicker()
    let userCallendar = Calendar.current
    let dateFormat = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //放iAd
        self.canDisplayBannerAds = true
        //按鈕外框
        self.sendButton.layer.cornerRadius = 20
        self.sendButton.layer.borderWidth = 1
        self.sendButton.layer.borderColor = UIColor.white.cgColor
        
        self.decreaseDays.delegate = self
        self.decreaseDays.addTarget(self, action: #selector(DateSelectViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        //建立按鈕在鍵盤上
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        //設定按鈕
        let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(DateSelectViewController.endEditingNow) )
        let toolbarButtons = [item]
        
        //顯示按鈕
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        textField.inputAccessoryView = keyboardDoneButtonView
        
        return true
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
        //在折抵天數輸入後自動換算新的退伍日期
        self.dateFormat.dateFormat = "yyyy-MM-dd"
        let entryDate = self.dateFormat.date(from: self.entryDate.text!)
        var decreaseDays = self.decreaseDays.text
        if(decreaseDays == ""){
            decreaseDays = "0"
        }
        var quitDay = (self.userCallendar as NSCalendar).date(byAdding: .year, value: 1, to: entryDate!, options: [])
        quitDay = (self.userCallendar as NSCalendar).date(byAdding: .day, value: -Int(decreaseDays!)!, to: quitDay!, options: [])
        self.quitDate.text = self.dateFormat.string(from: quitDay!)
    
    }
    
    func endEditingNow(){
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dateSelect(_ sender:UIDatePicker){
        
        //入伍日期及退伍日期用的date picker
        self.dateFormat.dateFormat = "yyyy-MM-dd"
        if (sender == self.entryDatePicker){//入伍日期
            self.entryDate.text = dateFormat.string(from: sender.date)
            self.quitDate.text = dateFormat.string(from: 1.years.daysFrom(sender.date))
            self.entryDate.resignFirstResponder()
        }else{//退伍日期（如果折抵算錯可自行更改
            self.quitDate.text = dateFormat.string(from: sender.date)
            self.quitDate.resignFirstResponder()
        }
        //入伍及退伍日皆有才可按
        if (self.entryDate.text != nil && self.quitDate.text != nil){
             self.sendButton.isEnabled = true
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func quitDaysTextField(_ sender: UITextField) {
        //退伍日期按鈕事件 開啟date picker
        self.quitDatePicker.datePickerMode = UIDatePickerMode.date
        sender.inputView = self.quitDatePicker
        
        self.quitDatePicker.addTarget(self, action: #selector(DateSelectViewController.dateSelect(_:)), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func dateTextField(_ sender: UITextField) {
        //入伍日期按鈕事件 開啟datepicker
        self.entryDatePicker.datePickerMode = UIDatePickerMode.date
        sender.inputView = self.entryDatePicker
        self.entryDatePicker.addTarget(self, action: #selector(DateSelectViewController.dateSelect(_:)), for: UIControlEvents.valueChanged)
    }
    

    @IBAction func saveDateButton(_ sender: AnyObject) {
        
        //將入伍日期及退伍日期存入NSUserDefaults
        let userDefault = UserDefaults.standard
        self.dateFormat.dateFormat = "yyyy-MM-dd"
        let entryDay = self.entryDate.text!
        let quitDay = self.quitDate.text!
        userDefault.set(entryDay as NSString, forKey: "entryDay")
        userDefault.set(quitDay as NSString, forKey: "quitDay")
        userDefault.synchronize()
        print("entry:\(entryDay)")
        print("quit:\(quitDay)")
        
        //設定Local Notification
        UIApplication.shared.cancelAllLocalNotifications()
        let pushMonth = 30.days.daysFrom(dateFormat.date(from: entryDay)!)
        let pushHundred = 100.days.daysFrom(dateFormat.date(from: entryDay)!)
        let pushHalfYear = 6.months.daysFrom(dateFormat.date(from: entryDay)!)
        let pushCountDownHundred = 100.days.daysAgo(dateFormat.date(from: quitDay)!)
        let puchCountDownMonth = 1.months.daysAgo(dateFormat.date(from: quitDay)!)
        let title = "國軍倒數"
        
        //入伍破月
        let monthNotification = UILocalNotification()
        monthNotification.fireDate = pushMonth
        monthNotification.timeZone = TimeZone.current
        monthNotification.soundName = UILocalNotificationDefaultSoundName
        monthNotification.alertBody = "恭喜破月（入伍）啦！！"
        monthNotification.alertTitle = title
        UIApplication.shared.scheduleLocalNotification(monthNotification)
        
        //入伍破百
        let hundredNotification = UILocalNotification()
        hundredNotification.fireDate = pushHundred
        hundredNotification.timeZone = TimeZone.current
        hundredNotification.soundName = UILocalNotificationDefaultSoundName
        hundredNotification.alertBody = "恭喜破百（入伍）啦！！"
        hundredNotification.alertTitle = title
        UIApplication.shared.scheduleLocalNotification(hundredNotification)
        
        //入伍半年
        let halfYearNotification = UILocalNotification()
        halfYearNotification.fireDate = pushHalfYear
        halfYearNotification.timeZone = TimeZone.current
        halfYearNotification.soundName = UILocalNotificationDefaultSoundName
        halfYearNotification.alertBody = "恭喜入伍半年啦！！要升一兵，還有加薪\"500\"塊囉！"
        halfYearNotification.alertTitle = title
        UIApplication.shared.scheduleLocalNotification(halfYearNotification)
        
        //退伍破百
        let countDownHundredNotification = UILocalNotification()
        countDownHundredNotification.fireDate = pushCountDownHundred
        countDownHundredNotification.timeZone = TimeZone.current
        countDownHundredNotification.soundName = UILocalNotificationDefaultSoundName
        countDownHundredNotification.alertBody = "恭喜破百啦！！"
        countDownHundredNotification.alertTitle = title
        UIApplication.shared.scheduleLocalNotification(countDownHundredNotification)
        
        //退伍破月
        let countDownMonthNotification = UILocalNotification()
        countDownMonthNotification.fireDate = puchCountDownMonth
        countDownMonthNotification.timeZone = TimeZone.current
        countDownMonthNotification.soundName = UILocalNotificationDefaultSoundName
        countDownMonthNotification.alertBody = "恭喜破月啦！！再撐一下！"
        countDownMonthNotification.alertTitle = title
        UIApplication.shared.scheduleLocalNotification(countDownMonthNotification)
        
        //退伍日
        let endDay = UILocalNotification()
        endDay.fireDate = dateFormat.date(from: quitDay)
        endDay.timeZone = TimeZone.current
        endDay.soundName = UILocalNotificationDefaultSoundName
        endDay.alertBody = "恭喜終於登出啦！！"
        endDay.alertTitle = title
        UIApplication.shared.scheduleLocalNotification(endDay)
        
        //儲存後回到首頁
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "CountDown") as! ViewController
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
}
