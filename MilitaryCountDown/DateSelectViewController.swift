//
//  DateSelectViewController.swift
//  MilitaryCountDown
//
//  Created by Yang Tun-Kai on 2015/12/22.
//  Copyright © 2015年 Yang Tun-Kai. All rights reserved.
//

import UIKit

class DateSelectViewController: UIViewController {

    
    @IBOutlet var entryDate: UITextField!
    @IBOutlet var decreaseDays: UITextField!
    @IBOutlet var quitDate: UITextField!
    
    let datePicker:UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.decreaseDays.keyboardType = UIKeyboardType.NumberPad
        // Do any additional setup after loading the view.
    }
    
    func dateSelect(sender:UIDatePicker){
        let dateformat = NSDateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        self.entryDate.text = dateformat.stringFromDate(sender.date)
        self.entryDate.resignFirstResponder()
        
       // print("3 days: \(sender.date()+(3.days))")
    }
    
    func quitSelect(sender:UIDatePicker){

        let dateformat = NSDateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        self.quitDate.text = dateformat.stringFromDate(sender.date)
        self.quitDate.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func quitDaysTextField(sender: UITextField) {
        
        self.datePicker.datePickerMode = UIDatePickerMode.Date
        sender.inputView = self.datePicker
        
        self.datePicker.addTarget(self, action: "quitSelect:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func dateTextField(sender: UITextField) {
        
        self.datePicker.datePickerMode = UIDatePickerMode.Date
        sender.inputView = self.datePicker
        self.datePicker.addTarget(self, action: Selector("dateSelect:"), forControlEvents: UIControlEvents.ValueChanged)
    }

}
