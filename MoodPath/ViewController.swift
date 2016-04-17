//
//  ViewController.swift
//  MoodPath
//
//  Created by Wiem Ben Rim on 4/15/16.
//  Copyright © 2016 Wiem Ben Rim. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    //My variables
    var timer = NSTimer()
    var mandatoryLeft = true; //Checks if there are any mandatory blocks left
    var blocks : [Bool] = [] //array indexed by the number of blocks, the values refer to whether the block is complete or not
    var  i = 0; //This keeps track of the next index
    var answered: [Bool] = []   //array to keep track of answered questions
    var seconds = 0
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    var questions = [Question]()
   
    @IBOutlet weak var noButton: UIButton!
    var activated = true;
    @IBOutlet weak var yesButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimer()
        readFile();
        if(answered.isEmpty){
            for k in 1...questions.count{
                answered.append(false)
                if (k % 3 == 0){
                    blocks.append(false)
                }
                
            }
        }
        if let date: NSDate = NSUserDefaults.standardUserDefaults().valueForKey("timeStamp") as? NSDate{
            if let  answers = NSUserDefaults.standardUserDefaults().valueForKey("answered") as? [Bool]{
                if let  secs = NSUserDefaults.standardUserDefaults().valueForKey("seconds") as? Int{
            //If there are already stored answers before
                    answered = answers;
                    for index in 0...answered.count-1{
                        if answered[index] == true{
                            print(answers)
                            i = index + 1
                        }
                    }
                    for blockIndex in 0...(answered.count-1)/3{
                        if(answered[blockIndex+2] == false){
                            print("shit")
                        }
                    }
                    
            //If currentDate is after the set date
                    print("date: \(date)" +  "and current date:" + "\(NSDate())")
                    print("Seconds: \(secs)");
                    seconds = secs  + Int((date.timeIntervalSinceNow))
                    print("Seconds 2: \(seconds)");
                    if (seconds <= 0){
                        if (i < questions.count){
                            i = getNextBlock()
                            seconds = 300
                        }
                    }
                    print (i)
                    
                    if (true){
                        activated = false;
                        questionImage.image = UIImage(named: "icon");
                        questionLabel.text = "";
                        yesButton.removeFromSuperview()
                        noButton.removeFromSuperview()
                        
                    }
                }
            }
        }
         print("\(i) is \(activated)")
        initQuestions()
 }
    
    
    //This fuction simply fetches the current question and outputs it for the user
    func initQuestions(){
        if (questions.count > i){
            let q = questions[i]
            questionLabel.text = q.question;
            questionImage.image = q.image;
            i++
        }
        else{
            i = 0
        }
    }
    
    /*This function getNextBlock() gives back the next Mandatory block 
    if there are any otherwise it returns the next optional block number*/
    func getNextBlock() -> Int{
        seconds = 300
        var nextBlock: Int = 0
        var counter = 0
        if (mandatoryLeft){
            while (questions[counter].status != 0 && questions[counter].answered == 0 ){
                counter++;
            }
            if (counter == questions.count){
                mandatoryLeft = false;
            }
            nextBlock = ((counter+1) % 3)
            return nextBlock
        }
        else{
            while(questions[counter].answered != 0){
                counter++
            }
            nextBlock = ((counter+1) % 3)
            return nextBlock
        }
       
    }
    
    /*This function saves the current date in NSUserDefaults so we can fetch it and compare 
    the time difference when the user opens the application again*/
    func saver(){
        let currentDate = NSDate()
        NSUserDefaults.standardUserDefaults().setValue(currentDate, forKey: "timeStamp")
        
    }
 
    /*This function changes the value of the content mapped to a certain question number 
    to indicate whether it was answered or not*/
    func updateAnswered(questionNumber: Int){
        if (answered.count > questionNumber){
            answered[questionNumber] = true;
            questions[questionNumber].answered = 1
      }
        NSUserDefaults.standardUserDefaults().setValue(answered, forKey: "answered")
    }
    
    
    /*Once the user clicks on answer:
        -the content of the answers array is updated
        -The labels on the UIViewController are updated 
        -the counter of the next question advances
        -If the latter indicates the start of a new block then present the timerViewController, 
            give it the number of seconds left and reset the seconds in this ViewController, then save the currentTime
    */
    @IBAction func answer(sender: AnyObject) {
        print("\(i-1) is \(activated)")
        updateAnswered(i-1)
        print(answered)
        if (i<questions.count){
             let q = questions[i]
           // print(q.question);
            q.answered = 1
            questionLabel.text = q.question;
            questionImage.image = q.image;
            i++;
            if ((i-1) % 3 == 0 && i != 1){
                if (seconds >= 0){
                    //If the there is still time left, they need to wait for the counter to become 0
                    //In order to move to the next block
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("timer") as! TimerViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                    activated = false;
                    vc.seconds = seconds;
                    seconds = 300
                }
            }
        }
        print("\(i) : \(answered)")
    }
   
    
    

    @IBOutlet weak var questionImage: UIImageView!
   
    func setupTimer()  {
        seconds = 300
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
    }
    
     func subtractTime() {
        seconds--
        let sec = seconds%60;
        let min = seconds / 60
        timerLabel.text = "Ready in : \(min) and \(sec)"
        if(seconds == 0)  {
            timer.invalidate()
            activated = true;
            self.view.addSubview(yesButton)
            //self.view.addSubview(noButton)
            print("NextBlock: : \(getNextBlock())")
        }
        NSUserDefaults.standardUserDefaults().setValue(seconds, forKey: "seconds")
        saver()
    }

   
   
    
    
    /*The first try/catch part of this method is essentially moving the file from the current directory to the Documnets directory
    to allow access to it. 
    The second part is parsing through it and filling the array of questions */
    func readFile(){
        
        //Moving the JSON file from the main Bundle to the Documents directory
        let bundlePath = NSBundle.mainBundle().pathForResource("questions", ofType: ".json")
        let destPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        let fileManager = NSFileManager.defaultManager()
        let fullDestPath = NSURL(fileURLWithPath: destPath).URLByAppendingPathComponent("questions.json")
        let fullDestPathString = fullDestPath.path
    
        
        do{
            try fileManager.copyItemAtPath(bundlePath!, toPath: fullDestPathString!)
        }catch{
            print("\n")
            print(error)
        }
        do {
     
            let data = NSData(contentsOfFile: fullDestPath.path!)!
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
    }
    
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}