//
//  Question.swift
//  Moodpath
//
//  Created by Wiem Ben Rim on 4/17/16.
//  Copyright © 2016 Wiem Ben Rim. All rights reserved.
//

import Foundation
import UIKit

class Question{
    var image: UIImage
    var question: String
    var status: Int;
    var answered: Int;
    
    init(question: String,image: UIImage, status: Int, answered: Int){
        self.image = image;
        self.question = question;
        self.status = status;
        self.answered = answered;
        
    }
    
    convenience init(question: String,image: UIImage, status: Int){
        self.init(question: question,image: image,status: status, answered: 0);
    }
}
