//
//  FileSaveHelper.swift
//  MoodPath
//
//  Created by Wiem Ben Rim on 4/16/16.
//  Copyright © 2016 Wiem Ben Rim. All rights reserved.
//

import Foundation

class FileSaveHelper{
            //1
        // MARK:- Error Types
        private enum FileErrors:ErrorType {
            case JsonNotSerialized
            case FileNotSaved
            
        }
        
        //2
        // MARK:- File Extension Types
        enum FileExension:String {
            case TXT = ".txt"
            case JPG = ".jpg"
            case JSON = ".json"
        }
        
        //3
        // MARK:- Private Properties
        private let directory:NSSearchPathDirectory
        private let directoryPath: String
        private let fileManager = NSFileManager.defaultManager()
        private let fileName:String
        private let filePath:String
        private let fullyQualifiedPath:String
        private let subDirectory:String
        var fileExists:Bool {
            get {
                return fileManager.fileExistsAtPath(fullyQualifiedPath)
            }
        }
        
        var directoryExists:Bool {
            get {
                var isDir = ObjCBool(true)
                return fileManager.fileExistsAtPath(filePath, isDirectory: &isDir )
            }
        }
        
        //2
        init(fileName: String, fileExtension:FileExension, subDirectory:String, directory:NSSearchPathDirectory){
            self.fileName = fileName + fileExtension.rawValue
            self.subDirectory = "/\(subDirectory)"
            self.directory = directory
            //3
            self.directoryPath = NSSearchPathForDirectoriesInDomains(directory, .UserDomainMask, true)[0]
            self.filePath = directoryPath + self.subDirectory
            self.fullyQualifiedPath = "\(filePath)/\(self.fileName)"
            //4
            print(self.directoryPath)
        }
    func saveFile(dataForJson dataForJson:AnyObject) throws{
        do {
            //2
            let jsonData = try convertObjectToData(dataForJson)
            if !fileManager.createFileAtPath(fullyQualifiedPath, contents: jsonData, attributes: nil){
                throw FileErrors.FileNotSaved
            }
        } catch {
            //3
            print(error)
            throw FileErrors.FileNotSaved
        }
        
    }
    
    //4
    private func convertObjectToData(data:AnyObject) throws -> NSData {
        
        do {
            //5
            let newData = try NSJSONSerialization.dataWithJSONObject(data, options: .PrettyPrinted)
            return newData
        }
            //6
        catch {
            print("Error writing data: \(error)")
        }
        throw FileErrors.JsonNotSerialized
    }
    
    
    }
