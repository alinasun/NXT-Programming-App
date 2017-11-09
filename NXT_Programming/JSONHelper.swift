//
//  JSONHelper.swift
//  NXT_Programming
//
//  Created by Erick Chong on 11/2/17.
//  Copyright © 2017 LA's BEST. All rights reserved.
//

import UIKit

// This function will only return the array of "commands" that is parsed from a json string
class JSONHelper: NSObject {
    // String must be in JSON format
    class func parseJSONWith(json: String) -> Array<Dictionary<String, Any>> {
        var result: Array<Dictionary<String, Any>> = []
        if let data = json.data(using: .utf8) {
            if let json = try? JSON(data: data) {
                // Iterate through each json index
                for (index, _) in json {
                    //print(index);
                    // If we are on "commands" array
                    if index == "commands" {
                        // Iterate through the "commands" array (which contains dictionaries)
                        for (_, object) in json["commands"] {
                            //print(index);
                            var dictionary: Dictionary<String, Any> = [:]
                            // Iterate through the dictionaries
                            for (key, value) in object {
                                //print("Key: \(key)")
                                //print("Value: \(value)")
                                
                                // If value is an integer, store it as an integer. Otherwise, store as a string
                                if self.stringIsInt(value: value.stringValue) {
                                    dictionary[key] = value.intValue
                                } else if self.stringIsBool(value: value.stringValue) {
                                    dictionary[key] = value.boolValue
                                } else {
                                    dictionary[key] = value.stringValue
                                }
                            }
                            // Add the resulting dictionary to the array
                            result.append(dictionary)
                        }
                    }
                }
            }
        }
        return result
    }
    
    class func iterateArrayOfDictionariesWith(array: Array<Dictionary<String, Any>>) {
        var index = 0
        for dictionary in array {
            print("Index: \(index)")
            for (key, value) in dictionary {
                print("Key: \(key)")
                print("Value: \(value)")
            }
            print("\n")
            index += 1
        }
    }
    
    private class func stringIsInt(value: String) -> Bool {
        return Int(value) != nil
    }
    
    private class func stringIsBool(value: String) -> Bool {
        return Bool(value) != nil
    }
    
}
