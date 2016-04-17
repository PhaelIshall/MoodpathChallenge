//
//  TimerViewController.swift
//  Moodpath
//
//  Created by Wiem Ben Rim on 4/17/16.
//  Copyright © 2016 Wiem Ben Rim. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var timer: UILabel! 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTimer()

        // Do any additional setup after loading the view.
    }
    
    var timeLeft = NSTimer()
    func setupTimer()  {
        if (seconds >= 0){
             timeLeft = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
        }
       
    }
    
    
    var seconds = 0;
    func subtractTime() {
        
        NSUserDefaults.standardUserDefaults().setValue(seconds, forKey: "seconds")
        
        if(seconds <= 0)  {
            timeLeft.invalidate()
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        seconds--
        let sec = seconds%60;
        let min = seconds / 60
        timer.text = "Unlocked in: \(min) minutes and \(sec) seconds"
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
