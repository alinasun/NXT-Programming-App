//
//  ClientController.swift
//  NXT_Programming
//
//  Created by Erick Chong on 9/21/17.
//  Copyright © 2017 LA's BEST. All rights reserved.
//

import UIKit

class ClientController: NSObject {
    override init() {
        super.init()
    }
    
    func oldSendDataToServerWith(jsonData: String) {
        var request = URLRequest(url: URL(string: "http://localhost:5000/test/")!)
        request.httpMethod = "POST"
        
        request.httpBody = jsonData.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in guard let data = data, error == nil else {
            print("error: \(error as Optional)")
            return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response: \(response as Optional)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("response: \(responseString as Optional)")
        }
        task.resume()
    }
    
    func sendDataToServerWith(jsonData: String) {
        var request = URLRequest(url: URL(string: "https://robocode-server.herokuapp.com/upload")!)
        request.httpMethod = "POST"
        
        request.httpBody = jsonData.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in guard let data = data, error == nil else {
            print("error: \(error as Optional)")
            return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response: \(response as Optional)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("response: \(responseString as Optional)")
        }
        task.resume()
    }
}
