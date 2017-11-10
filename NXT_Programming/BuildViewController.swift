//
//  BuildViewController.swift
//  NXT_Programming
//
//  Created by Alina Sun on 10/26/17.
//  Copyright © 2017 LA's BEST. All rights reserved.
//

import UIKit
import SocketIO

class BrickObject{
    var type: String!
    init(typeObj: String){
        type = typeObj;
    }
}

class MotorObject : BrickObject {
    var speed: Int = 0
    var rotations: Int = 0
    var brake: Bool = true
    
    init(ty: String) {
        super.init(typeObj: ty)
    }
    
    func setSpeed(newSpeed: Int){ speed = newSpeed }
    func setRotations(newRot: Int){ rotations = newRot }
    func setBrake(newBrake: Bool){ brake = newBrake }
    func getSpeed()->Int{ return speed }
    func getRotations()->Int{ return rotations }
    func getBrake()->Bool{ return brake }
}

class DisplayObject : BrickObject{
    var clear: Bool = true
    var xLoc: Int = 0
    var yLoc: Int = 0
    
    init(ty: String) {
        super.init(typeObj: ty)
    }
    
    func setClear(newClear: Bool){ clear = newClear }
    func setX(x: Int){ xLoc = x }
    func setY(y: Int){ yLoc = y }
    func getClear()->Bool{ return clear }
    func getXLoc()->Int{ return xLoc }
    func getYLoc()->Int{ return yLoc }
}

class SoundObject : BrickObject {
    var volume: Int = 0
    var typeSound: String = ""
    
    init(ty: String) {
        super.init(typeObj: ty)
    }
    
    func setVolume(newVol: Int){volume = newVol}
    func setTypeSound(newType: String){typeSound = newType}
    func getVolume()->Int{return volume}
    func getTypeSound()->String{return typeSound}
}

class WaitObject : BrickObject{
    var time: Int = 0
    
    init(ty: String){
        super.init(typeObj: ty)
    }
    
    func setTime(newTime: Int){time = newTime}
    func getTime()->Int{return time}
}

class BuildViewController: UIViewController {
    
    @IBOutlet weak var mediumMotorButtonUI: UIButton!
    @IBOutlet weak var largeMotorButtonUI: UIButton!
    @IBOutlet weak var moveSteeringButtonUI: UIButton!
    @IBOutlet weak var moveTankButtonUI: UIButton!
    @IBOutlet weak var soundButtonUI: UIButton!
    @IBOutlet weak var idLabel: UILabel!
    
    /**************************/
    //things for old UI basic buttons
    
    let startButton = UIButton()
    var startPoint = CGPoint()
    var nextPoint = CGPoint()
    
    var sendJSON = UIButton();
    var customizeBrick = UIButton();
    
    var tabOne = UIButton();
    var tabTwo = UIButton();
    
    var medMotorView = UIView()
    var largeMotorView = UIView()
    var displayView = UIView()
    var soundView = UIView()
    var waitView = UIView()
    var viewSequence = [UIView]()
    
    var speedInputView = UIView()
    
    let speedMM = UILabel()
    let rotationMM = UILabel()
    let brakeMM = UILabel()
    var objectSequence = [BrickObject]()
    
    var address = ""
    
    
    let socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "http://robocode-server.herokuapp.com")!)
    //let address: String = self.idLabel.text!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadBuildPage()
        createStartButton()
        medMotorView = createMedMotor()
        largeMotorView = createLargeMotor()
        displayView = createDisplay()
        soundView = createSound()
        waitView = createWait()
        createTabs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * functions to do UI buttons (replacing, creating, dragging and
     *
     */
    
    func createTabButton(type: String, _x: Int, _y: Int) -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: _x, y: _y, width: 96, height: 40)
        button.setTitle(type, for: UIControlState())
        button.backgroundColor = UIColor.red
        button.layer.borderWidth = 1.2
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.tag = 1
        self.view.addSubview(button)
        return button
    }
    
    func createStartButton(){
        startButton.frame = CGRect(x: 20, y: 370, width: 125, height: 100)
        startButton.setTitle("start", for: UIControlState())
        startButton.addTarget(self, action: #selector(dragStart(control:event:)), for: UIControlEvents.touchDragExit)
        startButton.layer.borderColor = UIColor.yellow.cgColor
        startButton.backgroundColor = UIColor.blue
        startButton.layer.borderWidth = 1.2
        startButton.layer.cornerRadius = 5
        startButton.layer.masksToBounds = true
        startButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        startButton.tag = 1
        startPoint = startButton.frame.origin
        self.view.addSubview(startButton)
        nextPoint = startPoint
        startButton.addTarget(self, action: #selector(test), for: UIControlEvents.touchUpInside)
    }
    
    func dragStart(control: UIControl, event: UIEvent) {
        print("in drag")
        if let center = event.allTouches?.first?.location(in: self.view) {
            control.center = center
        }
        startPoint = startButton.frame.origin
    }
    
    func createMedMotor()->UIView{
        let tempView = UIView()
        tempView.backgroundColor = UIColor.yellow
        tempView.frame = CGRect(x: 25, y: 100, width: 120, height: 160)
        
        let speedButton = UIButton()
        speedButton.frame = CGRect(x: 0, y: 80, width: 35, height: 40)
        speedButton.setTitle("speed", for: UIControlState())
        speedButton.backgroundColor = UIColor.red
        speedButton.layer.borderWidth = 1.2
        speedButton.layer.cornerRadius = 5
        speedButton.layer.masksToBounds = true
        speedButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        let rotationButton = UIButton();
        rotationButton.frame = CGRect(x: 40, y: 80, width: 35, height: 40)
        rotationButton.setTitle("rotation", for: UIControlState())
        rotationButton.backgroundColor = UIColor.red
        rotationButton.layer.borderWidth = 1.2
        rotationButton.layer.cornerRadius = 5
        rotationButton.layer.masksToBounds = true
        rotationButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        let brakeButton = UIButton();
        brakeButton.frame = CGRect(x: 80, y: 80, width: 35, height: 40)
        brakeButton.setTitle("brake", for: UIControlState())
        brakeButton.backgroundColor = UIColor.red
        brakeButton.layer.borderWidth = 1.2
        brakeButton.layer.cornerRadius = 5
        brakeButton.layer.masksToBounds = true
        brakeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        let name = UILabel()
        name.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        name.text = "Medium Motor"
        
        //var speed = UILabel()
        speedMM.frame = CGRect(x: 0, y: 40, width: 35, height: 30)
        speedMM.text = "50"
        
        //var rotation = UILabel()
        rotationMM.frame = CGRect(x: 40, y: 40, width: 35, height: 30)
        rotationMM.text = "1"
        
        //var brake = UILabel()
        brakeMM.frame = CGRect(x: 80, y: 40, width: 35, height: 30)
        brakeMM.text = "Yes"
        
        var panGesture = UIPanGestureRecognizer()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedViewMM(_:)))
        tempView.isUserInteractionEnabled = true
        tempView.addGestureRecognizer(panGesture)
        
        speedButton.addTarget(self, action: #selector(testAlertInput), for: UIControlEvents.touchUpInside)
        speedButton.tag = 1
        rotationButton.addTarget(self, action: #selector(testAlert1), for: UIControlEvents.touchUpInside)
        brakeButton.addTarget(self, action: #selector(testAlert3), for: UIControlEvents.touchUpInside)
        
        tempView.addSubview(name)
        tempView.addSubview(speedMM)
        tempView.addSubview(rotationMM)
        tempView.addSubview(brakeMM)
        tempView.addSubview(speedButton)
        tempView.addSubview(rotationButton)
        tempView.addSubview(brakeButton)
        self.view.addSubview(tempView)
        
        return tempView
    }
    
    func createLargeMotor()-> UIView{
        let tempView = UIView()
        tempView.backgroundColor = UIColor.yellow
        tempView.frame = CGRect(x: 300, y: 100, width: 120, height: 160)
        
        let speedButton = UIButton();
        speedButton.frame = CGRect(x: 0, y: 80, width: 35, height: 40)
        speedButton.setTitle("speed", for: UIControlState())
        speedButton.backgroundColor = UIColor.red
        speedButton.layer.borderWidth = 1.2
        speedButton.layer.cornerRadius = 5
        speedButton.layer.masksToBounds = true
        speedButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        let rotationButton = UIButton();
        rotationButton.frame = CGRect(x: 40, y: 80, width: 35, height: 40)
        rotationButton.setTitle("rotation", for: UIControlState())
        rotationButton.backgroundColor = UIColor.red
        rotationButton.layer.borderWidth = 1.2
        rotationButton.layer.cornerRadius = 5
        rotationButton.layer.masksToBounds = true
        rotationButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        let brakeButton = UIButton();
        brakeButton.frame = CGRect(x: 80, y: 80, width: 35, height: 40)
        brakeButton.setTitle("brake", for: UIControlState())
        brakeButton.backgroundColor = UIColor.red
        brakeButton.layer.borderWidth = 1.2
        brakeButton.layer.cornerRadius = 5
        brakeButton.layer.masksToBounds = true
        brakeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        let name = UILabel()
        name.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        name.text = "Large Motor"
        
        let speed = UILabel()
        speed.frame = CGRect(x: 0, y: 40, width: 35, height: 30)
        speed.text = "50"
        
        let rotation = UILabel()
        rotation.frame = CGRect(x: 40, y: 40, width: 35, height: 30)
        rotation.text = "1"
        
        let brake = UILabel()
        brake.frame = CGRect(x: 80, y: 40, width: 35, height: 30)
        brake.text = "Yes"
        
        
        var panGesture = UIPanGestureRecognizer()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedViewLM(_:)))
        tempView.isUserInteractionEnabled = true
        tempView.addGestureRecognizer(panGesture)
        
        speedButton.addTarget(self, action: #selector(testAlert1), for: UIControlEvents.touchUpInside)
        rotationButton.addTarget(self, action: #selector(testAlert2), for: UIControlEvents.touchUpInside)
        brakeButton.addTarget(self, action: #selector(testAlert3), for: UIControlEvents.touchUpInside)
        
        tempView.addSubview(name)
        tempView.addSubview(speed)
        tempView.addSubview(rotation)
        tempView.addSubview(brake)
        tempView.addSubview(speedButton)
        tempView.addSubview(rotationButton)
        tempView.addSubview(brakeButton)
        self.view.addSubview(tempView)
        
        return tempView
    }
    
    func createDisplay()->UIView{
        let tempView = UIView()
        tempView.backgroundColor = UIColor.yellow
        tempView.frame = CGRect(x: 500, y: 100, width: 120, height: 160)
        
        let clearScreenButton = UIButton();
        clearScreenButton.frame = CGRect(x: 0, y: 80, width: 35, height: 40)
        clearScreenButton.setTitle("speed", for: UIControlState())
        clearScreenButton.backgroundColor = UIColor.red
        clearScreenButton.layer.borderWidth = 1.2
        clearScreenButton.layer.cornerRadius = 5
        clearScreenButton.layer.masksToBounds = true
        clearScreenButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        let xButton = UIButton();
        xButton.frame = CGRect(x: 40, y: 80, width: 35, height: 40)
        xButton.setTitle("rotation", for: UIControlState())
        xButton.backgroundColor = UIColor.red
        xButton.layer.borderWidth = 1.2
        xButton.layer.cornerRadius = 5
        xButton.layer.masksToBounds = true
        xButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        let yButton = UIButton();
        yButton.frame = CGRect(x: 80, y: 80, width: 35, height: 40)
        yButton.setTitle("brake", for: UIControlState())
        yButton.backgroundColor = UIColor.red
        yButton.layer.borderWidth = 1.2
        yButton.layer.cornerRadius = 5
        yButton.layer.masksToBounds = true
        yButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        let name = UILabel()
        name.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        name.text = "Display"
        
        let clear = UILabel()
        clear.frame = CGRect(x: 0, y: 40, width: 35, height: 30)
        clear.text = "50"
        
        let xLoc = UILabel()
        xLoc.frame = CGRect(x: 40, y: 40, width: 35, height: 30)
        xLoc.text = "1"
        
        let yLoc = UILabel()
        yLoc.frame = CGRect(x: 80, y: 40, width: 35, height: 30)
        yLoc.text = "Yes"
        
        
        var panGesture = UIPanGestureRecognizer()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedViewD(_:)))
        tempView.isUserInteractionEnabled = true
        tempView.addGestureRecognizer(panGesture)
        
        clearScreenButton.addTarget(self, action: #selector(testAlert1), for: UIControlEvents.touchUpInside)
        xButton.addTarget(self, action: #selector(testAlert2), for: UIControlEvents.touchUpInside)
        yButton.addTarget(self, action: #selector(testAlert3), for: UIControlEvents.touchUpInside)
        
        tempView.addSubview(name)
        tempView.addSubview(clear)
        tempView.addSubview(xLoc)
        tempView.addSubview(yLoc)
        tempView.addSubview(clearScreenButton)
        tempView.addSubview(xButton)
        tempView.addSubview(yButton)
        self.view.addSubview(tempView)
        
        return tempView
    }
    
    func createSound()->UIView{
        let tempView = UIView()
        tempView.backgroundColor = UIColor.yellow
        tempView.frame = CGRect(x: 650, y: 100, width: 120, height: 160)
        
        let volumeButton = UIButton();
        volumeButton.frame = CGRect(x: 0, y: 80, width: 35, height: 40)
        volumeButton.setTitle("speed", for: UIControlState())
        volumeButton.backgroundColor = UIColor.red
        volumeButton.layer.borderWidth = 1.2
        volumeButton.layer.cornerRadius = 5
        volumeButton.layer.masksToBounds = true
        volumeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        let playTypeButton = UIButton();
        playTypeButton.frame = CGRect(x: 40, y: 80, width: 35, height: 40)
        playTypeButton.setTitle("rotation", for: UIControlState())
        playTypeButton.backgroundColor = UIColor.red
        playTypeButton.layer.borderWidth = 1.2
        playTypeButton.layer.cornerRadius = 5
        playTypeButton.layer.masksToBounds = true
        playTypeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        let name = UILabel()
        name.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        name.text = "Sound"
        
        let volume = UILabel()
        volume.frame = CGRect(x: 0, y: 40, width: 35, height: 30)
        volume.text = "50"
        
        let playType = UILabel()
        playType.frame = CGRect(x: 40, y: 40, width: 35, height: 30)
        playType.text = "1"
        
        var panGesture = UIPanGestureRecognizer()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedViewS(_:)))
        tempView.isUserInteractionEnabled = true
        tempView.addGestureRecognizer(panGesture)
        
        volumeButton.addTarget(self, action: #selector(testAlert1), for: UIControlEvents.touchUpInside)
        playTypeButton.addTarget(self, action: #selector(testAlert2), for: UIControlEvents.touchUpInside)
        
        tempView.addSubview(name)
        tempView.addSubview(volume)
        tempView.addSubview(playType)
        tempView.addSubview(volumeButton)
        tempView.addSubview(playTypeButton)
        self.view.addSubview(tempView)
        
        return tempView
    }
    
    func createWait()->UIView{
        let tempView = UIView()
        tempView.backgroundColor = UIColor.yellow
        tempView.frame = CGRect(x: 800, y: 100, width: 120, height: 160)
        
        let timeButton = UIButton();
        timeButton.frame = CGRect(x: 0, y: 80, width: 35, height: 40)
        timeButton.setTitle("Time", for: UIControlState())
        timeButton.backgroundColor = UIColor.red
        timeButton.layer.borderWidth = 1.2
        timeButton.layer.cornerRadius = 5
        timeButton.layer.masksToBounds = true
        timeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        let name = UILabel()
        name.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        name.text = "Wait"
        
        let time = UILabel()
        time.frame = CGRect(x: 0, y: 40, width: 35, height: 30)
        time.text = "50"
        
        var panGesture = UIPanGestureRecognizer()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedViewW(_:)))
        tempView.isUserInteractionEnabled = true
        tempView.addGestureRecognizer(panGesture)
        
        timeButton.addTarget(self, action: #selector(testAlert1), for: UIControlEvents.touchUpInside)
        
        tempView.addSubview(name)
        tempView.addSubview(time)
        tempView.addSubview(timeButton)
        self.view.addSubview(tempView)
        
        return tempView
    }
    
    func replaceView(type: String) -> UIView{
        if(type == "medMotorView"){
            medMotorView = createMedMotor()
            return medMotorView
        }else if(type == "largeMotorView"){
            largeMotorView = createLargeMotor()
            return largeMotorView
        }else if(type == "displayView"){
            displayView = createDisplay()
            return displayView
        }else if(type == "soundView"){
            soundView = createSound()
            return soundView
        }else{ //waitView
            waitView = createWait()
            return waitView
        }
    }
    
    func updateUIViewOrder(){
        var x = startPoint.x
        let y = startPoint.y
        for view in viewSequence{
            view.frame.origin = CGPoint(x: x, y: y)
            x = x + 128
        }
    }
    
    func draggedViewMM(_ sender:UIPanGestureRecognizer){
        
        let translation = sender.translation(in: self.view)
        
        medMotorView.center = CGPoint(x: medMotorView.center.x + translation.x, y: medMotorView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        let xLoc = medMotorView.center.x + translation.x
        let yLoc = medMotorView.center.y + translation.y
        
        var index = Int()
        index = viewSequence.count
        var toAppend = Bool()
        toAppend = false
        
        if(yLoc > 300 && yLoc < 440){
            //if dragged to end
            if(xLoc > (nextPoint.x + 128)){
                medMotorView.center = CGPoint(x: nextPoint.x + 128, y: nextPoint.y)
                nextPoint.x = nextPoint.x + 128
                toAppend = true
            }
                //if dragged to middle
            else if(xLoc > startPoint.x && xLoc < nextPoint.x){
                var beginXRange = startPoint.x
                var endXRange = startPoint.x + 128
                for i in  0..<viewSequence.count {
                    if(xLoc < endXRange && xLoc > beginXRange){
                        index = i
                    }else{
                        beginXRange += 128
                        endXRange += 128
                    }
                }
            }
        }
        if(sender.state == UIGestureRecognizerState.ended){
            //            if(validPlacement){
            let newMM = MotorObject(ty: "motor");
            newMM.setSpeed(newSpeed: 50)
            newMM.setBrake(newBrake: true)
            newMM.setRotations(newRot: 5)
            if(toAppend){
                objectSequence.append(newMM);
                viewSequence.append(medMotorView)
            }else{
                objectSequence.insert(newMM, at: index)
                viewSequence.insert(medMotorView, at: index)
            }
            updateUIViewOrder()
            //            }else{
            //                medMotorView.isHidden = true
            //            }
            
            medMotorView = replaceView(type: "medMotorView")
        }
    }
    
    func draggedViewLM(_ sender:UIPanGestureRecognizer){
        let translation = sender.translation(in: self.view)
        largeMotorView.center = CGPoint(x: largeMotorView.center.x + translation.x, y: largeMotorView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        let xLoc = largeMotorView.center.x + translation.x
        let yLoc = largeMotorView.center.y + translation.y
        
        var index = Int()
        index = viewSequence.count
        var toAppend = Bool()
        toAppend = false
        
        if(yLoc > 300 && yLoc < 440){
            //if dragged to end
            if(xLoc > (nextPoint.x + 128)){
                largeMotorView.center = CGPoint(x: nextPoint.x + 128, y: nextPoint.y)
                nextPoint.x = nextPoint.x + 128
                toAppend = true
            }
                //if dragged to middle
            else if(xLoc > startPoint.x && xLoc < nextPoint.x){
                var beginXRange = startPoint.x
                var endXRange = startPoint.x + 128
                for i in  0..<viewSequence.count {
                    if(xLoc < endXRange && xLoc > beginXRange){
                        index = i
                    }else{
                        beginXRange += 128
                        endXRange += 128
                    }
                }
            }
        }
        if(sender.state == UIGestureRecognizerState.ended){
            //            if(validPlacement){
            let newLM = MotorObject(ty: "motor");
            newLM.setSpeed(newSpeed: 50)
            newLM.setBrake(newBrake: true)
            newLM.setRotations(newRot: 5)
            if(toAppend){
                objectSequence.append(newLM);
                viewSequence.append(largeMotorView)
            }else{
                objectSequence.insert(newLM, at: index)
                viewSequence.insert(largeMotorView, at: index)
            }
            updateUIViewOrder()
            //            }else{
            //                largeMotorView.isHidden = true
            //            }
            
            largeMotorView = replaceView(type: "largeMotorView")
        }
    }
    
    func draggedViewD(_ sender:UIPanGestureRecognizer){
        let translation = sender.translation(in: self.view)
        displayView.center = CGPoint(x: displayView.center.x + translation.x, y: displayView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        let xLoc = displayView.center.x + translation.x
        let yLoc = displayView.center.y + translation.y
        
        var index = Int()
        index = viewSequence.count
        var toAppend = Bool()
        toAppend = false
        
        if(yLoc > 300 && yLoc < 440){
            //if dragged to end
            if(xLoc > (nextPoint.x + 128)){
                displayView.center = CGPoint(x: nextPoint.x + 128, y: nextPoint.y)
                nextPoint.x = nextPoint.x + 128
                toAppend = true
            }
                //if dragged to middle
            else if(xLoc > startPoint.x && xLoc < nextPoint.x){
                var beginXRange = startPoint.x
                var endXRange = startPoint.x + 128
                for i in  0..<viewSequence.count {
                    if(xLoc < endXRange && xLoc > beginXRange){
                        index = i
                    }else{
                        beginXRange += 128
                        endXRange += 128
                    }
                }
            }
        }
        if(sender.state == UIGestureRecognizerState.ended){
            //            if(validPlacement){
            let newD = DisplayObject(ty: "display");
            newD.setX(x: 10)
            newD.setY(y: 10)
            newD.setClear(newClear: true)
            if(toAppend){
                objectSequence.append(newD);
                viewSequence.append(displayView)
            }else{
                objectSequence.insert(newD, at: index)
                viewSequence.insert(displayView, at: index)
            }
            updateUIViewOrder()
            //            }else{
            //                displayView.isHidden = true
            //            }
            
            displayView = replaceView(type: "displayView")
        }
    }
    
    func draggedViewS(_ sender:UIPanGestureRecognizer){
        let translation = sender.translation(in: self.view)
        soundView.center = CGPoint(x: soundView.center.x + translation.x, y: soundView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        let xLoc = soundView.center.x + translation.x
        let yLoc = soundView.center.y + translation.y
        
        var index = Int()
        index = viewSequence.count
        var toAppend = Bool()
        toAppend = false
        
        if(yLoc > 300 && yLoc < 440){
            //if dragged to end
            if(xLoc > (nextPoint.x + 128)){
                soundView.center = CGPoint(x: nextPoint.x + 128, y: nextPoint.y)
                nextPoint.x = nextPoint.x + 128
                toAppend = true
            }
                //if dragged to middle
            else if(xLoc > startPoint.x && xLoc < nextPoint.x){
                var beginXRange = startPoint.x
                var endXRange = startPoint.x + 128
                for i in  0..<viewSequence.count {
                    if(xLoc < endXRange && xLoc > beginXRange){
                        index = i
                    }else{
                        beginXRange += 128
                        endXRange += 128
                    }
                }
            }
        }
        if(sender.state == UIGestureRecognizerState.ended){
            //            if(validPlacement){
            let newS = SoundObject(ty: "sound");
            newS.setTypeSound(newType: "playsound")
            newS.setVolume(newVol: 500)
            if(toAppend){
                objectSequence.append(newS);
                viewSequence.append(soundView)
            }else{
                objectSequence.insert(newS, at: index)
                viewSequence.insert(soundView, at: index)
            }
            updateUIViewOrder()
            //            }else{
            //                soundView.isHidden = true
            //            }
            soundView = replaceView(type: "soundView")
        }
    }
    
    func draggedViewW(_ sender:UIPanGestureRecognizer){
        let translation = sender.translation(in: self.view)
        waitView.center = CGPoint(x: waitView.center.x + translation.x, y: waitView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        let xLoc = waitView.center.x + translation.x
        let yLoc = waitView.center.y + translation.y
        
        var index = Int()
        index = viewSequence.count
        var toAppend = Bool()
        toAppend = false
        
        if(yLoc > 300 && yLoc < 440){
            //if dragged to end
            if(xLoc > (nextPoint.x + 128)){
                waitView.center = CGPoint(x: nextPoint.x + 128, y: nextPoint.y)
                nextPoint.x = nextPoint.x + 128
                toAppend = true
            }
                //if dragged to middle
            else if(xLoc > startPoint.x && xLoc < nextPoint.x){
                var beginXRange = startPoint.x
                var endXRange = startPoint.x + 128
                for i in  0..<viewSequence.count {
                    if(xLoc < endXRange && xLoc > beginXRange){
                        index = i
                        break
                    }else{
                        beginXRange += 128
                        endXRange += 128
                    }
                }
            }
        }
        if(sender.state == UIGestureRecognizerState.ended){
            print("in state ended wait")
            //if(validPlacement){
            let newW = WaitObject(ty: "wait");
            newW.setTime(newTime: 500);
            if(toAppend){
                objectSequence.append(newW);
                viewSequence.append(waitView)
                print("appending wait")
            }else{
                objectSequence.insert(newW, at: index)
                viewSequence.insert(waitView, at: index)
                print("inserting wait")
            }
            updateUIViewOrder()
            print("UI should attach")
            //}else{
            //waitView.isHidden = true
            //print("meh")
            //}
            waitView = replaceView(type: "waitView")
        }
    }
    
    func getContent(s: String)->String{
        var str = s
        let index = str.index(str.startIndex, offsetBy: 10);
        str =  str.substring(from: index)
        let index2 = str.index(str.startIndex, offsetBy: str.count - 2)
        str = str.substring(to: index2)
        return str
    }
    
    func testAlertInput(){
        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "default text"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(String(describing: textField?.text))");
            
            let x = String(describing: textField?.text);
            let ans = self.getContent(s: x)
            print("ans")
            print(ans)
            self.speedMM.text = ans
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func testAlert1(){
        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "default text"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(String(describing: textField?.text))");
            let x = String(describing: textField?.text);
            let ans = self.getContent(s: x)
            print("ans")
            print(ans)
            self.rotationMM.text = ans
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func testAlert2(){
        var alert = UIAlertController()
        alert = UIAlertController(title: "My Second Alert", message: "This is an alert type 2.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func testAlert3(){
        var alert = UIAlertController()
        alert = UIAlertController(title: "My Third Alert", message: "This is an alert type 3.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func printViewSequence(){
        for view in viewSequence{
            print(view)
        }
    }
    
    func test(action: UIAlertAction){
        print("printing objects" )
        for BrickObject in objectSequence {
            print(BrickObject)
        }
    }
    
    func loadSpeedInputView(){
        print("sup")
        let speedInputFrame = CGRect(x: 250, y: 250, width: 120, height: 160)
        speedInputView = UIView(frame: speedInputFrame)
        speedInputView.backgroundColor = UIColor.cyan
        speedInputView.isHidden = false
        
        let okayButtonFrame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let okayButton = UIButton(frame: okayButtonFrame )
        okayButton.backgroundColor = UIColor.green
        
        speedInputView.addSubview(okayButton)
        
        okayButton.addTarget(self, action: #selector(self.didPressButtonFromSpeedInputView), for: UIControlEvents.touchUpInside)
        self.view.addSubview(speedInputView)
        
    }
    
    
    func didPressButtonFromSpeedInputView(sender:UIButton) {
        // do whatever you want
        // make view disappears again, or remove from its superview
        print("quit the popup")
        speedInputView.isHidden = true
        
    }
    
    @IBAction func sendToServer(){
        //let address: String = self.idLabel.text!
        
        print("sending to server")
        
        var jsonArray = [JSON]()
        
        for BrickObject in objectSequence {
            print(BrickObject.type)
            if(BrickObject.type == "motor"){
                let json: JSON = ["type":"motor", "brake": true, "power": 100, "revolutions":5, "port":"A"]
                jsonArray.append(json)
            }else if(BrickObject.type == "display"){
                
            }else if(BrickObject.type == "sound"){
                let json: JSON = ["type":"playsound", "soundfile": "Woops"]
                jsonArray.append(json)
            }else if(BrickObject.type == "wait"){
                
            }
        }
        
        /*
         let json: JSON = ["type": "motor", "brake": true, "power": 100, "revolutions": 5, "port": "A"]
         jsonArray.append(json)
         
         let json1: JSON = ["type": "playsound", "freq": 500,"duration": 500,"soundfile": "filename"]
         jsonArray.append(json1)
         
         let json2: JSON = ["type": "touch", "port": 1,
         "condition": [ "touch": true, "notouch": false, "while": true, "if": ["type": "motor", "brake": true, "power": 100, "revolutions": 5, "port": "A"], "else": ["type": "playsound", "freq": 500,"duration": 500,"soundfile": "filename"]]]
         jsonArray.append(json2)
         */
        
        let jsonString: JSON = ["address" : "00:16:53:19:1E:AC", "commands" : jsonArray]
        let jsonFinal = jsonString.description
        self.socket.emit("run code", jsonFinal)
        
        print("SENDING THIS JSON: " )
        print(jsonString.description)
        
    }
    
    func createTabs(){
        tabOne = createTabButton(type: "General", _x: 20, _y: 600)
        tabTwo = createTabButton(type: "General 2", _x: 118, _y: 600)
        
        tabOne.addTarget(self, action: #selector(loadViewTabOne), for: UIControlEvents.allTouchEvents)
        tabTwo.addTarget(self, action: #selector(loadViewTabTwo), for: UIControlEvents.allTouchEvents)
    }
    
    func loadViewTabOne(){
        waitView.isHidden = true;
        
        medMotorView.isHidden = false;
        largeMotorView.isHidden = false;
        displayView.isHidden = false;
        soundView.isHidden = false;
    }
    
    func loadViewTabTwo(){
        medMotorView.isHidden = true;
        largeMotorView.isHidden = true;
        displayView.isHidden = true;
        soundView.isHidden = true;
        
        waitView.isHidden = false;
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


