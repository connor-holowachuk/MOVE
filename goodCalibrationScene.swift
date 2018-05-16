//
//  goodCalibrationScene.swift
//  Move
//
//  Created by Connor Holowachuk on 2014-07-19.
//  Copyright (c) 2014 Connor Holowachuk. All rights reserved.
//

import SpriteKit
import CoreMotion
import AVFoundation

class goodCalibrationScene: SKScene{
    
    var textLine1 = SKLabelNode(fontNamed: standardTextFont)
    var textLine2 = SKLabelNode(fontNamed: standardTextFont)
    var checkMark = SKSpriteNode(imageNamed: "checkMarkImage")
    
    var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
    
    override func didMoveToView(view: SKView!) {
        
        let shiftToCenterAction = SKAction.moveToX(self.frame.width / 2, duration: 0.44)
        
        backgroundImage.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
        backgroundImage.setScale(0.5)
        backgroundImage.zPosition = 0
        self.addChild(backgroundImage)
        
        textLine1.text = "CALIBRATION"
        textLine1.fontColor = deepBlueColour
        textLine1.fontSize = 24
        textLine1.position = CGPointMake(self.frame.width * (3 / 2), self.frame.height * (2 / 3))
        self.addChild(textLine1)
        
        textLine2.text = "COMPLETE!"
        textLine2.fontColor = deepBlueColour
        textLine2.fontSize = 24
        textLine2.position = CGPointMake(self.frame.width * (3 / 2), self.frame.height * (2 / 3) - 24)
        self.addChild(textLine2)
        
        checkMark.setScale(0.5)
        checkMark.position = CGPointMake(self.frame.width + checkMark.size.width / 2, self.frame.height / 3)
        checkMark.zPosition = 1
        self.addChild(checkMark)
        
        checkMark.runAction(shiftToCenterAction)
        textLine1.runAction(shiftToCenterAction)
        textLine2.runAction(shiftToCenterAction)
        
        delay(2.4){
            self.switchToNextScene()
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    func switchToNextScene(){
        let moveOutAction = SKAction.moveToX(0 - self.frame.width / 2, duration: 0.44)
        self.checkMark.runAction(moveOutAction)
        self.textLine1.runAction(moveOutAction)
        self.textLine2.runAction(moveOutAction)
        delay(0.744){
            let scene: SKScene = GameSelectScenePage1(size: self.scene.size)
            let skView = self.view as SKView
            skView.ignoresSiblingOrder = true
            self.scene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene.size = skView.bounds.size
            self.scene.view.presentScene(scene)
        }
    }
}
