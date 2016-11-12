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
    @IBOutlet var daysLabel: UILabel!
    
    //初始NSUserDefaults
    let userDefault = UserDefaults.standard
    let calendar: Calendar! = Calendar(identifier: Calendar.Identifier.gregorian)
    let dateFormat: DateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.navigationItem.hidesBackButton = true
        if let entryString = userDefault.string(forKey: "entryDay"), let quitString = userDefault.string(forKey: "quitDay"){
            //取出userdefaults裡的日期
            dateFormat.dateFormat = "yyyy-MM-dd"

            let entryDay = dateFormat.date(from: entryString)
            let quitDay = dateFormat.date(from: quitString)
            
            
            
            //計算日期相減及比例
            let nowDays = calendar.dateComponents([.day], from: entryDay!, to: Date())
            let durationDays = calendar.dateComponents([.day], from: entryDay!, to:quitDay!)
            let surplusDays = calendar.dateComponents([.day], from: Date(), to: quitDay!)
            let percentage = Float(nowDays.day!)/Float(durationDays.day!)
            
            //小數點設定
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 1
            formatter.minimumFractionDigits = 1
            
            let percentageNum = ((percentage * 100) > 100) ? 100 : (percentage * 100)
            self.percentLabel.text = formatter.string(from: percentageNum as NSNumber)!+"%"
            
            let dayNum = (surplusDays.day! < 0) ? 0 : surplusDays.day!
            self.daysLabel.text = String(describing: dayNum)
            
            //加入circle chart
            addCircleView(self.circleChartView, duration: 0.5, fromValue: 0.0, toValue: CGFloat(percentage))
        }

        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "DateSelect") as! DateSelectViewController
        
        //如果userdefault裡面沒有日期資料則跳出設定視窗
        if( (userDefault.string(forKey: "entryDay") == nil && userDefault.string(forKey: "quitDay") == nil) || (userDefault.string(forKey: "entryDay") == "" && userDefault.string(forKey: "quitDay") == "") ){
            self.navigationController?.pushViewController(resultViewController, animated: true)
        }

    }
    
    func addCircleView(_ myView: UIView, duration: TimeInterval, fromValue: CGFloat, toValue: CGFloat){

        //設定circlechart 的長寬
        let circleWidth = CGFloat(250)
        let circleHeight = circleWidth
        
        //畫出新的CircleView
        let circleView = CircleView(frame: CGRect(x: 0,y: 0,width: circleWidth,height: circleHeight))
        
        //設定circlechart線條顏色
        circleView.setStrokeColor(UIColor(red: 96.0/255.0, green: 160.0/255.0, blue: 96.0/255.0, alpha: 1).cgColor)
        
        myView.addSubview(circleView)
        
        //初始圓圈從0度(上）開始畫
        circleView.transform = CGAffineTransform(rotationAngle: -1.56)
        
        //繪圖動畫
        circleView.animateCircleTo(duration, fromValue: fromValue, toValue: toValue)
        
    }
    
    func unwindToCamera(_ segue:UIStoryboardSegue) {
    }

}

