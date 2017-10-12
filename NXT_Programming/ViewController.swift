//
//  ViewController.swift
//  LA's BEST Robotics App
//
//  Created by Erick Chong on 09/20/17.
//  Copyright © 2017 LA's BEST. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var connectButton: UIBarButtonItem!
    @IBOutlet weak var disconnectButton: UIBarButtonItem!
    @IBOutlet weak var sendJSONButton: UIButton!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var getMacAddressesButton: UIButton!
    @IBOutlet weak var macAddressTableView: UITableView!
    
    let socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "http://robocode-server.herokuapp.com")!)
    //let socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "http://localhost:3000")!)
    var clientArray: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addListeners()
        self.disconnectButton.isEnabled = false
        self.sendJSONButton.isEnabled = false
        self.getMacAddressesButton.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    func addListeners() {
        socket.on(clientEvent: .connect) { data, ack in
            self.connectButton.isEnabled = false
            self.disconnectButton.isEnabled = true
            self.getMacAddressesButton.isEnabled = true

            self.addAlert(title: "Connected", message: "Your session ID: " + self.socket.sid!)
        }
        
        socket.on(clientEvent: .reconnect) { data, ack in
            self.idLabel.text = nil
            self.connectButton.isEnabled = false
            self.disconnectButton.isEnabled = false
            self.getMacAddressesButton.isEnabled = true
            self.sendJSONButton.isEnabled = true
            
            
            self.addAlert(title: "Connection Failed", message: "Attempting to connect to the server")
        }
        
        socket.on("chat message") { data, ack in
            let stringData = data[0] as! String
            self.addAlert(title: "Server Message", message: stringData)
        }
        
        socket.on("available nxts") { data, ack in
            //print("Interpreting data from server")
            print(data[0])
            
            let addressData = data[0] as! NSDictionary
            let addressArray = addressData["addresses"] as! Array<String>
            self.clientArray = addressArray

            for i in 0..<self.clientArray.count {
                print(self.clientArray[i])
            }
            self.macAddressTableView.reloadData()
        }
    }
    
    
    @IBAction func connectButtonDidPress(_ sender: UIBarButtonItem) {
        self.socket.connect()
    }
    
    @IBAction func sendJSONButton(_ sender: UIButton) {
        // let json = JSON(["type": "Medium Motor", "power": 50, "rotations": 5, "brake": false])
        // let json = JSON(["type": "Large Motor", "power": 50, "rotations": 5, "brake": false])
        // let json = JSON(["type": "Move Steering", "steering": 0, "power": 50, "rotations": 5, "brake": false])
        // let json = JSON(["type": "Move Tank", "powerLeft": 50, "powerRight": 50, "rotations": 5, "brake": false])
        // let json = JSON(["type": "sound", "freq": 100, "duration": 475])
        
        let address: String = self.idLabel.text!
        
        let json: JSON =  ["commands":[["type":"sound", "freq":440, "duration":1000], ["type":"motor_medium", "revolutions":4, "duration":50]], "address":address]
        let jsonString = json.description //json.rawString([.castNilToNSNull: true])!
        //self.socket.emit("jsonCommand", jsonString, self.idLabel.text as String!)
        self.socket.emit("run code", jsonString)
    }
    
    @IBAction func disconnectButtonDidPress(_ sender: UIBarButtonItem) {
        self.socket.disconnect()
        self.idLabel.text = nil
        self.connectButton.isEnabled = true
        self.disconnectButton.isEnabled = false
        self.sendJSONButton.isEnabled = false
        self.getMacAddressesButton.isEnabled = false
        self.addAlert(title: "Disconnected", message: "You have disconnected from the server")
    }
    
    @IBAction func getMacAddressesButtonDidPress(_ sender: UIButton) {
        //self.socket.emit("getPiDevices")
        //macAddressTableView.reloadData()
        self.socket.emit("get available nxts")
    }
    
    @IBAction func playSoundButtonDidPress(_ sender: UIButton) {
        var request = URLRequest(url: URL(string: "https://robocode-server.herokuapp.com/test")!)
        request.httpMethod = "GET"
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a cell
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = clientArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        self.idLabel.text = clientArray[indexPath.row]
        self.sendJSONButton.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
        self.idLabel.text = nil
    }
    /*
    func parseAddresses(addressList: String) {
        var parseAddress = false
        var address = ""
        for i in addressList.characters.indices {
            if addressList[i] == "\"" && !parseAddress
            {
                parseAddress = true
            }
            else if addressList[i] != "\"" && parseAddress
            {
                address.append(addressList[i])
            }
            else if addressList[i] == "\"" && parseAddress
            {
                self.clientArray.append(address)
                parseAddress = false
            }
        }
    }
 */
    
    
}

