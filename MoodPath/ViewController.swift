//
//  ViewController.swift
//  MoodPath
//
//  Created by Wiem Ben Rim on 4/15/16.
//  Copyright © 2016 Wiem Ben Rim. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
 
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        readFile();
        
        
       
        
    }
    
       
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
        
        
        
        var questions = Dictionary<String, [String]>()
        
        
        
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
                                questions[question] = [image, "\(status)"]
                            
                            }
                            
                        }
                    }
                    
                }
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
        
        //print(questions) // ["Bloxus test", "Manila Test"]

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}