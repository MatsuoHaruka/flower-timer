//
//  ViewController.swift
//  ex7
//
//  Created by HARUKA on 7/29/15.
//  Copyright (c) 2015 HARUKA. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myPickerView: UIPickerView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myButton2: UIButton!
    @IBOutlet weak var myButton: UIButton!
    
    
    var second = 0
    var timer : NSTimer!
    let defaults = NSUserDefaults.standardUserDefaults()
    var startTime : NSDate!
    var time :Int!
    var settingTime = 60
    var now = String()
    var list = ["1:00","5:00","10:00","20:00","30:00","テスト"]
    var listTime = "1:00"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        
        self.myButton2.hidden = true
        
        myButton.addTarget(self, action: "touchUpButton:", forControlEvents:.TouchUpInside)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        timer.invalidate()
        let notificationCenter = NSNotificationCenter.defaultCenter()
//        アプリがアクティブになったとき
        notificationCenter.addObserver(
            self,
            selector: "enterForeground",
            name:"applicationWillEnterForeground",
            object: nil)
        
        notificationCenter.addObserver(
            self,
            selector: "enterBackGround",
            name: "applicationDidEnterBackground",
            object: nil)

    }
    
    func enterBackGround(){
        var stopTime = NSDate()
        defaults.setObject(stopTime, forKey: "stopTime")
        println("止まった時間")
        println(stopTime)
    }
    
    func enterForeground(){
        if timer.valid == true {
            let restartTime = NSDate()
            
            var stopTime = defaults.objectForKey("stopTime") as! NSDate
         
            var interval = restartTime.timeIntervalSinceDate(stopTime)
            println("間隔")
            println(interval)
            var intervalInt = Int(interval)
            
            second += intervalInt
            makeLabel()
            
        }
    }
    
    func update(){
        second++
        makeLabel()
    }
    
    func makeLabel(){
        
        time = settingTime - second
        var m = time / 60
        var s = time - 60*m
        
        var stringM : String = String(m)
        var stringS : String = String(s)
        if s >= 10{
            now = stringM + ":" + stringS
        }else{
            now = stringM + ":0" + stringS
        }
        self.myLabel.text = now
        
        //計り終わったら
        if time == 0 {
            self.myImageView.image = UIImage(named: "chou.jpg")
            timer.invalidate()
            second = 0
            self.myLabel.hidden = true//非表示
            self.myButton.hidden = true
            self.myButton2.hidden = false
            myButton2.addTarget(self, action: "touchUpButton2:", forControlEvents:.TouchUpInside)
            
            //サウンド
            var soundIdRing:SystemSoundID = 1009
            AudioServicesCreateSystemSoundID(nil, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
            }

    }
    
    //myButtonがタップされたら
    func touchUpButton(sender:UIButton) {
        
        //タイマーが動いてないとき
        if timer.valid == false{
            self.myLabel.text = listTime
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
            
            sender.setTitle("諦める", forState: UIControlState.Normal)
            self.myImageView.image = UIImage(named: "flower.png")
            
            startTime = NSDate()
            
            defaults.setObject(startTime, forKey:"startTime")
            defaults.synchronize()
            println(startTime)
            
            self.myLabel.hidden = false//表示
            self.myPickerView.hidden = true//非表示
            
            //タイマーが動いてるとき
        }else if timer.valid == true{
            timer.invalidate()
            sender.setTitle("始める", forState: UIControlState.Normal)
            self.myImageView.image = UIImage(named: "flower2.png")
            second = 0
            
            self.myLabel.hidden = true//非表示
            self.myPickerView.hidden = false//表示
        }
    }
    
    
    //myButton2がタップされたら
    func touchUpButton2(sender:UIButton) {
        self.myImageView.image = UIImage(named: "flower.png")
        self.myPickerView.hidden = false
        self.myButton2.hidden = true
        self.myButton.hidden = false
        self.myButton.setTitle("始める", forState: UIControlState.Normal)
    }

    
    //Picker
    func numberOfComponentsInPickerView(pickerview1: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerview1: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return list[row]
    }
    func pickerView(pickerview1: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if row == 0 {
            self.settingTime = 60
            self.listTime = "1:00"
        }else if row == 1 {
            self.settingTime = 300
            self.listTime = "5:00"
        }else if row == 2 {
            self.settingTime = 600
            self.listTime = "10:00"
        }else if row == 3 {
            self.settingTime = 1200
            self.listTime = "20:00"
        }else if row == 4 {
            self.settingTime = 1800
            self.listTime = "30:00"
        }else if row == 5 {
            self.settingTime = 15
            self.listTime = "0:15"
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

