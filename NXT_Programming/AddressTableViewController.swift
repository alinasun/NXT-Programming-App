//
//  AddressTableViewController.swift
//  NXT_Programming
//
//  Created by Erick Chong on 11/2/17.
//  Copyright © 2017 LA's BEST. All rights reserved.
//

import UIKit
import SocketIO

protocol AddressDelegate {
    // Index is the index of the chosen macAddress in the macAddressArray
    func updateMacAddressWith(index: Int)
    func storeMacAddressesWith(macAddressArray: Array<String>)
    func initializeTableView()
}

protocol ServerDelegate {
    func updateServerStatusWhere(connected: Bool)
}

class AddressTableViewController: UITableViewController, PopoverDelegate, TableDelegate {
    var macAddressArray: Array<String> = []
    let socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "http://robocode-server.herokuapp.com")!)
    var serverDelegate: ServerDelegate?
    var addressDelegate: AddressDelegate?
    
    // boolean variables to keep track of server status
    var connected = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        self.addListeners()
        self.addressDelegate?.initializeTableView()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addListeners() {
        socket.on(clientEvent: .connect) { data, ack in
            self.connected = true;
            self.serverDelegate?.updateServerStatusWhere(connected: self.connected)
            print("Connected!")
            /*
            self.connectToServerButton.isEnabled = false
            self.disconnectFromServerButton.isEnabled = true
            self.getMacAddressesButton.isEnabled = true
            self.serverStatusLabel.text = "Connected"
            self.serverStatusLabel.textColor = UIColor.green
            */
            
            //self.addAlert(title: "Connected", message: "Your session ID: " + self.socket.sid!)
        }
        
        socket.on(clientEvent: .reconnect) { data, ack in
            self.connected = false;
            /*
            self.connectToServerButton.isEnabled = false
            self.disconnectFromServerButton.isEnabled = true
            self.serverStatusLabel.text = "Connecting"
            self.serverStatusLabel.textColor = UIColor(red: 255/255.0, green: 204/255.0, blue: 0/255.0, alpha: 1)
            */
            
            //self.addAlert(title: "Connection Failed", message: "Attempting to connect to the server")
        }
        
        socket.on("available nxts") { data, ack in
            //print("Interpreting data from server")
            //print(data[0])
            
            let addressData = data[0] as! NSDictionary
            let addressArray = addressData["addresses"] as! Array<String>
            self.macAddressArray = addressArray
            self.addressDelegate?.storeMacAddressesWith(macAddressArray: addressArray) // Store data
            self.addressDelegate?.updateMacAddressWith(index: -1) // Update the selected index (which is none)
            self.tableView.reloadData()
            
            
            // Print results, mainly for testing purposes here
            /*
            for i in 0..<self.macAddressArray.count {
                print(self.macAddressArray[i])
            }
            */
        }
        
        socket.on("busy") { data, ack in
            print("The server is currently busy. Please try again in a few seconds")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.macAddressArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath)
        cell.textLabel?.text = self.macAddressArray[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.blue
        cell.accessoryType = .none
        return cell
    }
    
    /*
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.backgroundColor = UIColor.gray
        }
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.backgroundColor = UIColor.clear
        }
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.reloadData() // Temporary solution only
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.setSelected(true, animated: true)
            cell.accessoryType = .checkmark
        }
        self.addressDelegate?.updateMacAddressWith(index: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
        self.addressDelegate?.updateMacAddressWith(index: -1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PopoverViewController {
            destination.delegate = self
            self.serverDelegate = destination
        }
    }
    
    // PopoverDelegate functions
    
    func sendMacAddresses(macAddresses: Array<String>) {
        self.socket.emit("get available nxts")
        /*
        self.macAddressArray = macAddresses
        self.addressDelegate?.storeMacAddressesWith(macAddressArray: macAddresses)
        self.addressDelegate?.updateMacAddressWith(index: -1)
        self.tableView.reloadData()
        */
        print("Updated tableView")
    }
    
    func connectToServer() {
        print("Connecting to server")
        socket.connect()
        //self.serverDelegate?.updateServerStatusWhere(connected: true)
        
    }
    
    func disconnectFromServer() {
        print("Disconnecting from server")
        socket.disconnect()
        self.connected = false
        self.serverDelegate?.updateServerStatusWhere(connected: self.connected)
    }
    
    func initializePopover() {
        self.serverDelegate?.updateServerStatusWhere(connected: self.connected)
    }
    
    // TableDelegate functions
    
    func initializeTable(selectedIndex: Int, macAddressArray: Array<String>) {
        self.macAddressArray = macAddressArray
        self.tableView.reloadData()
        if selectedIndex > -1 {
            if let cell = tableView.cellForRow(at: IndexPath(item: selectedIndex, section: 0)) {
                cell.setSelected(true, animated: true)
                cell.accessoryType = .checkmark
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
