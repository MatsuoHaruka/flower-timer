//
//  ViewController.swift
//  ex7
//
//  Created by HARUKA on 7/29/15.
//  Copyright (c) 2015 HARUKA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var myImageView: UIImageView!

    @IBOutlet weak var myLabel: UILabel!
    
    @IBAction func myButton(sender: UIButton) {
        
       //タイマーが動いてないとき
        if timer.valid == false{
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
            
            sender.setTitle("諦める", forState: UIControlState.Normal)
            self.myImageView.image = UIImage(named: "flower.png")
            self.myLabel.text = "30:00"
            
            startTime = NSDate()
            
            defaults.setObject(startTime, forKey:"startTime")
            defaults.synchronize()
            println(startTime)
        
        //タイマーが動いてるとき
        }else{
            timer.invalidate()
            sender.setTitle("始める", forState: UIControlState.Normal)
            self.myImageView.image = UIImage(named: "flower2.png")
            second = 0
        }
        
    }
  
    
    
    var second = 0
    var timer : NSTimer!
    let defaults = NSUserDefaults.standardUserDefaults()
    var startTime : NSDate!
    var time : NSDate!
    var now = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
            
//            startTime = defaults.objectForKey("startTime") as! NSDate
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
        var time = 1800 - second
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
        
        if time == 0 {
            self.myImageView.image = UIImage(named: "chou.jpg")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

