//
//  CalibrateQuestionsScene.swift
//  Move
//
//  Created by Connor Holowachuk on 2014-08-01.
//  Copyright (c) 2014 Connor Holowachuk. All rights reserved.
//

import SpriteKit
import CoreMotion
import AVFoundation

class CalibrateQuestionsScene: SKScene{

    var instructionHeading = SKLabelNode(fontNamed: standardTextBoldFont)
    var backBubble = SKSpriteNode()
    var backBubbleTexture = SKTexture()
    
    override func didMoveToView(view: SKView!) {
        
        previousScene = Scene_CalibrationInstructionQuestions
        
        self.backgroundColor = whiteColour
        
        var headingPosition = CGFloat(self.frame.height * (5 / 6))
        
        instructionHeading.position = CGPointMake(self.frame.width / 2, headingPosition)
        instructionHeading.fontColor = darkGreyColour
        instructionHeading.fontSize = 26
        instructionHeading.text = "ABOUT CALIBRATION"
        self.addChild(instructionHeading)
        
        backBubbleTexture = SKTexture(imageNamed: "backBubbleImage")
        backBubbleTexture.filteringMode = SKTextureFilteringMode.Nearest
        backBubble = SKSpriteNode(texture: backBubbleTexture)
        backBubble.setScale(0)
        backBubble.position = CGPointMake(self.frame.height / 12, self.frame.height / 12)
        self.addChild(backBubble)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.backBubble{
                let scene: SKScene = CalibrateInstuctionsScene(size: self.scene.size)
                let skView = self.view as SKView
                skView.ignoresSiblingOrder = true
                self.scene.scaleMode = SKSceneScaleMode.AspectFill
                self.scene.size = skView.bounds.size
                self.scene.view.presentScene(scene)
            }
        }
    }
}

