//
//  Program.swift
//  NXT_Programming
//
//  Created by Erick Chong on 10/18/17.
//  Copyright © 2017 LA's BEST. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class ProgramManager: NSObject {
    static let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    private var name: String;
    private var program: String;
    
    init(name: String, program: String) {
        self.name = name
        self.program = program
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getProgram() -> String {
        return self.program
    }
    
    class func convertDictionaryToArrayWith(dictionary: NSMutableDictionary) -> Array<ProgramManager> {
        var resultArray: Array<ProgramManager> = []
        for (key, value) in dictionary {
            let program = ProgramManager(name: key as! String, program: value as! String)
            resultArray.append(program)
        }
        return resultArray
    }
    
    // If programNumber is < 0, the program doesn't already exist in the plist
    class func saveProgramWith(originalPrograms: NSMutableDictionary, programJSON: String, programNumber:String) {
        if let documents = directories.first {
            if let urlDocuments = URL(string: documents) {
                let urlPrograms = urlDocuments.appendingPathComponent("nxtprograms.plist")
                //print("Path: \(urlPrograms.path)")
                
                // Write
                //let programs = ["e", "r", "k"] as NSArray
                //let programs = originalPrograms as NSDictionary
                
                if programNumber == "-1" {
                    
                }
                originalPrograms[programNumber] = programJSON
                originalPrograms.write(toFile: urlPrograms.path, atomically: true)
            }
        }
    }
    
    class func saveProgramsWith(programName: String, programJSON: String) {
    }
    
    class func loadProgramWith(programNumber: String) {
        if let documents = directories.first {
            if let urlDocuments = URL(string: documents) {
                let urlPrograms = urlDocuments.appendingPathComponent("nxtprograms.plist")
                
                // Load
                let loadedPrograms = NSMutableDictionary(contentsOfFile: urlPrograms.path)
                
                if let newPrograms = loadedPrograms {
                    print(newPrograms)
                }
                
                print("Program requested: \(loadedPrograms![programNumber] ?? "-1")")
            }
        }
    }
    
    class func loadAllPrograms() -> NSMutableDictionary {
        if let documents = directories.first {
            if let urlDocuments = URL(string: documents) {
                let urlPrograms = urlDocuments.appendingPathComponent("nxtprograms.plist")
                
                // Load
                let loadedPrograms = NSMutableDictionary(contentsOfFile: urlPrograms.path)
                print ("Path:  \(urlPrograms.path)")
                
                if let newPrograms = loadedPrograms {
                    print(newPrograms)
                    return newPrograms
                }
                
                //print("Program requested: \(loadedPrograms![programNumber])")
            }
        }
        return [:] as NSMutableDictionary
    }

    
}
