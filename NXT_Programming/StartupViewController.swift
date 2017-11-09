//
//  StartupViewController.swift
//  NXT_Programming
//
//  Created by Erick Chong on 10/26/17.
//  Copyright © 2017 LA's BEST. All rights reserved.
//

protocol StartupDelegate {
    func openProgram()
}

import UIKit

class StartupViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    @IBOutlet weak var newBarButton: UIBarButtonItem!
    @IBOutlet weak var openBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var programsArray: Array<Program> = ProgramManager.loadAllPrograms()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.allowsMultipleSelection = true
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NavigationController {
            //print("test")
            let barButton = sender as! UIBarButtonItem
            let barButtonTitle: String = barButton.title!
            if barButtonTitle == "New" {
                destination.isNewProgram = true
                destination.programName = ""
                destination.programJSON = ""
            } else {
                let program: Program = self.programsArray[self.collectionView.indexPathsForSelectedItems![0].row]
                destination.isNewProgram = false
                destination.programName = program.name
                destination.programJSON = program.json
                destination.realmID = program.id
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.programsArray.count == 0 {
            self.newBarButton.isEnabled = true
            self.openBarButton.isEnabled = false
            self.deleteBarButton.isEnabled = false
        }
        return self.programsArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgramCell", for: indexPath) as! ProgramCell
        cell.programLabel.text = programsArray[indexPath.row].name;
        
        if cell.isSelected {
            cell.backgroundColor = UIColor(red:30/255.0, green:144/255.0, blue:255/255.0, alpha:0.5)
        } else {
            cell.backgroundColor = UIColor.clear
            self.newBarButton.isEnabled = true
            self.openBarButton.isEnabled = false
            self.deleteBarButton.isEnabled = false
        }
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor(red:30/255.0, green:144/255.0, blue:255/255.0, alpha:0.5)
        let indexPaths = collectionView.indexPathsForSelectedItems!.count
        
        if indexPaths == 1 {
            self.newBarButton.isEnabled = false
            self.openBarButton.isEnabled = true
            self.deleteBarButton.isEnabled = true
        } else if indexPaths > 1 {
            self.openBarButton.isEnabled = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.clear
        let indexPaths = collectionView.indexPathsForSelectedItems!.count
        
        if indexPaths == 1 {
            self.newBarButton.isEnabled = false
            self.openBarButton.isEnabled = true
            self.deleteBarButton.isEnabled = true
        } else if indexPaths > 1 {
            self.openBarButton.isEnabled = false
        } else {
            self.newBarButton.isEnabled = true
            self.openBarButton.isEnabled = false
            self.deleteBarButton.isEnabled = false
        }
    }
    
    @IBAction func deleteBarButtonDidPress(_ sender: UIBarButtonItem) {
        let indexPaths = collectionView.indexPathsForSelectedItems!
        
        for indexPath in indexPaths {
            let program = self.programsArray[indexPath.row]
            ProgramManager.deleteProgramWith(name: program.name, json: program.json, id: program.id)
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        
        // Update collectionView
        self.programsArray = ProgramManager.loadAllPrograms()
        collectionView.reloadData()
    }
    
    @IBAction func testRealmButtonDidPress(_ sender: UIButton) {
        //let programDate = self.programsArray[self.programsArray.count - 1].date
        // Return true if successfully saved, false otherwise (false when program with name already exists
        var result = ProgramManager.saveNewProgramWith(programName: "testName1", programJSON: "testJSON")
        result = ProgramManager.saveNewProgramWith(programName: "testName2", programJSON: "testJSON")
        result = ProgramManager.saveNewProgramWith(programName: "testName3", programJSON: "testJSON")
        result = ProgramManager.saveNewProgramWith(programName: "testName4", programJSON: "testJSON")
        result = ProgramManager.saveNewProgramWith(programName: "testName5", programJSON: "testJSON")
        result = ProgramManager.saveNewProgramWith(programName: "testName6", programJSON: "testJSON")
        result = ProgramManager.saveNewProgramWith(programName: "testName7", programJSON: "testJSON")
        //let result = ProgramManager.updateProgramWith(programName: "testName1", programJSON: "testJSON3", date: programDate)
        if result {
            print("Successfully saved to Realm")
        } else {
            print("Object with the name already exists")
        }
        
        // Update collectionView
        self.programsArray = ProgramManager.loadAllPrograms()
        collectionView.reloadData()
    }
    
    @IBAction func clearRealmObjectsButtonDidPress(_ sender: UIButton) {
        ProgramManager.clearAllPrograms()
        self.programsArray = ProgramManager.loadAllPrograms()
        collectionView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
