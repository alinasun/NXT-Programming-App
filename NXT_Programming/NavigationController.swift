//
//  NavigationController.swift
//  NXT_Programming
//
//  Created by Erick Chong on 11/9/17.
//  Copyright © 2017 LA's BEST. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    var isNewProgram: Bool = true
    var programName: String = ""
    var programJSON: String = ""
    var realmID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let destination = self.viewControllers.first {
            let vc = destination as! ViewController /* REPLACE ViewController WITH THE CORRECT CLASS */
            
            if !isNewProgram {
                vc.isNewProgram = self.isNewProgram
                vc.programName = self.programName
                vc.programJSON = self.programJSON
                vc.realmID = self.realmID
            } else {
                vc.isNewProgram = self.isNewProgram
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) /* CHANGE VIEWCONTROLLER TO WHATEVER THE TYPE OF THE VIEWCONTROLLER YOU ARE MOVING TO IS */ {
        print("In prepare for segue function")
        if let destination = segue.destination as? ViewController {
            print("In the if statement")
            if !isNewProgram {
                destination.isNewProgram = self.isNewProgram
                destination.programName = self.programName
                destination.programJSON = self.programJSON
                destination.realmID = self.realmID
            } else {
                print("This is a new program, so don't update anything")
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
