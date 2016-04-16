//
//  ViewController.swift
//  MoodPath
//
//  Created by Wiem Ben Rim on 4/15/16.
//  Copyright © 2016 Wiem Ben Rim. All rights reserved.
//

import UIKit


class Question{
    var image: UIImage
    var question: String
    var status: Int;
    init(question: String,image: UIImage, status: Int){
        self.image = image;
        self.question = question;
        self.status = status;
    }
}

class ViewController: UIViewController {
       override func viewDidLoad() {
        super.viewDidLoad()
        readFile();
//        setupGame()
       // saver();
        questionLabel.text = "vfghfed";
        //sleep(3)
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.showQuestions()
        }
        
    }
  
    
    
    func saver(){
        let currentDate = NSDate()
        NSUserDefaults.standardUserDefaults().setValue(currentDate, forKey: "date")
        
    }
    
    
    @IBAction func answer(sender: AnyObject) {
        //Assuming you have a method named enableButton on self
        //        let timer = NSTimer.scheduledTimerWithTimeInterval(86400, target: self, selector: "enableButton", userInfo: nil, repeats: false)
        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "timeStamp")
    }
    var seconds = 0
    //var timer = NSTimer()
    
    
    @IBOutlet weak var questionImage: UIImageView!

    func setupGame()  {
        seconds = 6000;
        
        
        timerLabel.text = "Time: \(seconds)"
      
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
    }
    
    
    @IBOutlet var timerLabel: UILabel!
   
    func subtractTime() {
        seconds--
        timerLabel.text = "Time: \(seconds)"
        
        if(seconds == 0)  {
            timer.invalidate()
        }
    }
    
    @IBOutlet weak var questionLabel: UILabel!
    
  
    func showQuestions(){
        
        for q in questions{
           
            print(q.question);
            questionLabel.text = q.question;
            questionImage.image = q.image;
            
        }
        
        
        
    }
    var timer: NSTimer!
    var countdown: Int = 0

    
    
    var questions = [Question]()

    
    func readFile(){
        
        //Moving the JSON file from the main Bundle to the Documents directory
        let bundlePath = NSBundle.mainBundle().pathForResource("questions", ofType: ".json")
        print(bundlePath, "\n") //prints the correct path
        let destPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        let fileManager = NSFileManager.defaultManager()
        let fullDestPath = NSURL(fileURLWithPath: destPath).URLByAppendingPathComponent("questions.json")
        let fullDestPathString = fullDestPath.path
        print(fileManager.fileExistsAtPath(bundlePath!)) // prints true
        
        do{
            try fileManager.copyItemAtPath(bundlePath!, toPath: fullDestPathString!)
        }catch{
            print("\n")
            print(error)
        }        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        
        
        //Reading from he JSON file
        do {
            
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            
            let path = NSURL(fileURLWithPath: paths).URLByAppendingPathComponent("questions.json")
            
            let data = NSData(contentsOfFile: path.path!)!
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            if let dictionary = json["questions"] as? [[String: AnyObject]] {
                for q in dictionary {
                    if let question = q["question"] as? String {
                        if let image = q["image"] as? String{
                           if let status = q["is_mandatory"] as? Int{
                            let temp = Question(question: question,image: UIImage(named: image)!,status: status);
                            questions.append(temp)
                            
                            }
                            
                        }
                    }
                    
                }
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
        
        print(questions) // ["Bloxus test", "Manila Test"]

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}