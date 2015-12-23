//
//  DateSelectViewController.swift
//  MilitaryCountDown
//
//  Created by Yang Tun-Kai on 2015/12/22.
//  Copyright © 2015年 Yang Tun-Kai. All rights reserved.
//

import UIKit

class DateSelectViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet var entryDate: UITextField!
    @IBOutlet var decreaseDays: UITextField!
    @IBOutlet var quitDate: UITextField!
    @IBOutlet var sendButton: UIButton!
    
    let entryDatePicker:UIDatePicker = UIDatePicker()
    let quitDatePicker:UIDatePicker = UIDatePicker()
    let userCallendar = NSCalendar.currentCalendar()
    let dateFormat = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //按鈕外框
        self.sendButton.layer.cornerRadius = 20
        self.sendButton.layer.borderWidth = 1
        self.sendButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.decreaseDays.delegate = self
        self.decreaseDays.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        //建立按鈕在鍵盤上
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        //設定按鈕
        let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("endEditingNow") )
        let toolbarButtons = [item]
        
        //顯示按鈕
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        textField.inputAccessoryView = keyboardDoneButtonView
        
        return true
    }
    
    func textFieldDidChange(textField: UITextField) {
        
        //在折抵天數輸入後自動換算新的退伍日期
        self.dateFormat.dateFormat = "yyyy-MM-dd"
        let entryDate = self.dateFormat.dateFromString(self.entryDate.text!)
        var decreaseDays = self.decreaseDays.text
        if(decreaseDays == ""){
            decreaseDays = "0"
        }
        var quitDay = self.userCallendar.dateByAddingUnit(.Year, value: 1, toDate: entryDate!, options: [])
        quitDay = self.userCallendar.dateByAddingUnit(.Day, value: -Int(decreaseDays!)!, toDate: quitDay!, options: [])
        self.quitDate.text = self.dateFormat.stringFromDate(quitDay!)

    }
    
    func endEditingNow(){
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    func dateSelect(sender:UIDatePicker){
        
        //入伍日期及退伍日期用的date picker
        self.dateFormat.dateFormat = "yyyy-MM-dd"
        if (sender == self.entryDatePicker){//入伍日期
            self.entryDate.text = dateFormat.stringFromDate(sender.date)
            self.entryDate.resignFirstResponder()
        }else{//退伍日期（如果折抵算錯可自行更改
            self.quitDate.text = dateFormat.stringFromDate(sender.date)
            self.quitDate.resignFirstResponder()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func quitDaysTextField(sender: UITextField) {
        //退伍日期按鈕事件 開啟date picker
        self.quitDatePicker.datePickerMode = UIDatePickerMode.Date
        sender.inputView = self.quitDatePicker
        
        self.quitDatePicker.addTarget(self, action: "dateSelect:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func dateTextField(sender: UITextField) {
        //入伍日期按鈕事件 開啟datepicker
        self.entryDatePicker.datePickerMode = UIDatePickerMode.Date
        sender.inputView = self.entryDatePicker
        self.entryDatePicker.addTarget(self, action: Selector("dateSelect:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    

    @IBAction func saveDateButton(sender: AnyObject) {
        
        //將入伍日期及退伍日期存入NSUserDefaults
        let userDefault = NSUserDefaults.standardUserDefaults()
        self.dateFormat.dateFormat = "yyyy-MM-dd"
        let entryDay = self.entryDate.text!
        let quitDay = self.quitDate.text!
        userDefault.setObject(entryDay as NSString, forKey: "entryDay")
        userDefault.setObject(quitDay as NSString, forKey: "quitDay")
        userDefault.synchronize()
    }
}
