//
//  CalibrateInstructionsScene.swift
//  Move
//
//  Created by Connor Holowachuk on 2014-07-21.
//  Copyright (c) 2014 Connor Holowachuk. All rights reserved.
//

//0x66FF70

import SpriteKit
import CoreMotion
import AVFoundation

class CalibrateInstuctionsScene: SKScene{
    
    var nextSceneIsCalibration = true
    
    var headingCapsule = SKSpriteNode(imageNamed: "titleCapsule")
    
    var instructionHeading = SKLabelNode(fontNamed: standardTextBoldFont)
    var instructionTextLine1 = SKLabelNode(fontNamed: standardTextFont)
    var instructionTextLine2 = SKLabelNode(fontNamed: standardTextFont)
    var instructionTextLine3 = SKLabelNode(fontNamed: standardTextFont)
    
    var setPhoneDownImage = SKSpriteNode(imageNamed: "setPhoneDownImage")

    var beginCalibrationLabel = SKLabelNode(fontNamed: bubbleTextFont)
    var beginBubble = SKSpriteNode(imageNamed: "deepBlueCircleImage")
    var backArrow = SKSpriteNode(imageNamed: "backArrowImage")
    
    var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
    
    override func didMoveToView(view: SKView!){
        
        let shiftRightButtonsAction = SKAction.moveToX(self.frame.width / 6 + 22, duration: 0.44)
        let shiftLeftLabelsAction = SKAction.moveToX(self.frame.width / 2, duration: 0.44)
        
        backgroundImage.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
        backgroundImage.setScale(0.5)
        backgroundImage.zPosition = -4
        self.addChild(backgroundImage)
        
        var headingPosition = CGFloat(self.frame.height * (5 / 6))
        
        headingCapsule.setScale(0.5)
        var thisHeadingPosition = CGFloat(0)
        if previousScene == Scene_MainMenu{
            thisHeadingPosition = self.frame.width / 2
        }else{
            thisHeadingPosition = 0 - self.frame.width / 2
        }
        headingCapsule.position = CGPointMake(thisHeadingPosition, headingPosition)
        self.addChild(headingCapsule)
        headingCapsule.runAction(shiftLeftLabelsAction)
        
        instructionHeading.position = CGPointMake(self.frame.width / 2, headingPosition - 10)
        instructionHeading.fontColor = deepBlueColour
        instructionHeading.fontSize = 24
        instructionHeading.fontName = standardTextFont
        instructionHeading.text = "CALIBRATION"
        self.addChild(instructionHeading)
        
        instructionTextLine1.text = "please set your device down"
        instructionTextLine2.text = "and do not move until"
        instructionTextLine3.text = "calibration is complete"
        
        var thisLineOfText: [SKLabelNode] = [instructionTextLine1, instructionTextLine2, instructionTextLine3]
        
        for thisNumber in 0...2{
            thisLineOfText[thisNumber].fontSize = CGFloat(18.0)
            thisLineOfText[thisNumber].position = CGPointMake(self.frame.width / 2, headingPosition - 54 - CGFloat(24 * (thisNumber + 1)))
            thisLineOfText[thisNumber].fontColor = deepBlueColour
            self.addChild(thisLineOfText[thisNumber])
        }
        
        setPhoneDownImage.setScale(0.5)
        setPhoneDownImage.position = CGPointMake(0 - self.setPhoneDownImage.size.width / 2, self.frame.height / 2 - 24)
        self.addChild(setPhoneDownImage)
        setPhoneDownImage.runAction(shiftLeftLabelsAction)
        
        beginBubble.setScale(0.5)
        beginBubble.position = CGPointMake(self.frame.size.width + beginBubble.size.width / 2, self.frame.height / 3 - 54)
        self.addChild(beginBubble)
        
        beginCalibrationLabel.position = CGPointMake(self.beginBubble.position.x, self.beginBubble.position.y - 10)
        beginCalibrationLabel.fontSize = CGFloat(22)
        beginCalibrationLabel.fontName = standardTextFont
        beginCalibrationLabel.fontColor = whiteColour
        beginCalibrationLabel.text = "BEGIN"
        self.addChild(beginCalibrationLabel)
        
        beginBubble.runAction(shiftLeftLabelsAction)
        beginCalibrationLabel.runAction(shiftLeftLabelsAction)

        let moveArrowAction = SKAction.moveToX(self.frame.height / 12, duration: 0.44)
        
        backArrow.setScale(0.5)
        backArrow.position = CGPointMake(0 - backArrow.size.width / 2, self.frame.height / 12)
        self.addChild(backArrow)
        backArrow.runAction(moveArrowAction)
        
        //shift in the nodes
        
        var allOfTheLabelNodes: [SKLabelNode] = [instructionHeading, instructionTextLine1, instructionTextLine2, instructionTextLine3]

        for thisNumber in 0...3{
            allOfTheLabelNodes[thisNumber].position = CGPointMake(self.frame.width * (5 / 3),allOfTheLabelNodes[thisNumber].position.y)
        }
        for thisNumber in 0...3{
            allOfTheLabelNodes[thisNumber].runAction(shiftLeftLabelsAction)
        }
        
        previousScene = Scene_CalibrationInstructions

    }
    
    func scaleOutNodes(){
        
        buttonPressedSoundPlayer1.stop()
        buttonPressedSoundPlayer1.play()
        var thisXPosition: CGFloat = 0
        if nextSceneIsCalibration == true{
            thisXPosition = 0 - self.frame.width / 2
        }else{
            thisXPosition = self.frame.width * (3 / 2)
        }
        let moveOutAction = SKAction.moveToX(thisXPosition, duration: 0.44)

        var allOfTheLabelNodes: [SKLabelNode] = [instructionHeading, instructionTextLine1, instructionTextLine2, instructionTextLine3, beginCalibrationLabel]
        beginBubble.runAction(moveOutAction)
        for thisNumber in 0...3{
            allOfTheLabelNodes[thisNumber].runAction(moveOutAction)
        }
        backArrow.runAction(moveOutAction)
        setPhoneDownImage.runAction(moveOutAction)
        beginCalibrationLabel.runAction(moveOutAction)
        if nextSceneIsCalibration == true{
            headingCapsule.runAction(moveOutAction)
        }
    }
    
    func switchToNextScene(){
        
        let scene = CalibrateScene(size: self.scene!.size)
        let skView = self.view as SKView?
        skView!.ignoresSiblingOrder = true
        scene.scaleMode = SKSceneScaleMode.AspectFill
        scene.size = skView!.bounds.size
        self.scene!.view!.presentScene(scene)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.beginBubble || self.nodeAtPoint(location) == self.beginCalibrationLabel{
                nextSceneIsCalibration = true
                scaleOutNodes()
                
                delay(0.744){
                    self.switchToNextScene()
                }
            }else if self.nodeAtPoint(location) == self.backArrow{
                nextSceneIsCalibration = false
                scaleOutNodes()
                
                delay(0.4){
                    
                    previousScene = Scene_CalibrationInstructions
                    
                    let scene: SKScene = MainMenuScene(size: self.scene.size)
                    let skView = self.view as SKView
                    skView.ignoresSiblingOrder = true
                    self.scene.scaleMode = SKSceneScaleMode.AspectFill
                    self.scene.size = skView.bounds.size
                    self.scene.view.presentScene(scene)
                }
            }
        }
    }
}

//                dispatch_after(1, dispatch_get_main_queue(), thisFunction())
