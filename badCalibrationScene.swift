//
//  badCalibrationScene.swift
//  Move
//
//  Created by Connor Holowachuk on 2014-07-19.
//  Copyright (c) 2014 Connor Holowachuk. All rights reserved.
//

import SpriteKit
import CoreMotion

class badCalibrationScene: SKScene{
    
    var sayingHeading = SKLabelNode(fontNamed: standardTextFont)
    var badCalibrationSaying = SKLabelNode(fontNamed: standardTextFont)
    var textLine2 = SKLabelNode(fontNamed: standardTextFont)
    var textLine3 = SKLabelNode(fontNamed: standardTextFont)
    var reTryCalibrationLabel = SKLabelNode(fontNamed: standardTextFont)
    var blueBubble = SKSpriteNode(imageNamed: "deepBlueCircleImage")
    var XImage = SKSpriteNode(imageNamed: "XImage")
    
    let scaleUpAction = SKAction.scaleTo(4, duration: 0.744)
    let scaleDownAction = SKAction.scaleTo(CGFloat(0) , duration: 0.44)
    
    var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
    
    override func didMoveToView(view: SKView!) {
        
        let moveInAction = SKAction.moveToX(self.frame.width / 2, duration: 0.44)
        
        backgroundImage.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
        backgroundImage.setScale(0.5)
        backgroundImage.zPosition = -4
        self.addChild(backgroundImage)

        var headingPosition = CGFloat(self.frame.height * (2 / 3))
        
        textLine2.text = "it looks like you're moving too much."
        textLine3.text = "you will need to recalibrate."
        
        var thisLineOfText: [SKLabelNode] = [textLine2, textLine3]
        var randomSaying: [String] = ["slow it down, pontiac...", "calm it down there...", "take it easy now...", "don't mean to be picky, but..."]
        
        badCalibrationSaying.position = CGPointMake(0 - self.frame.width / 2, headingPosition + 44)
        badCalibrationSaying.fontSize = CGFloat(18)
        badCalibrationSaying.fontColor = deepBlueColour
        badCalibrationSaying.text = randomSaying[randomSayingGenerator()]
        self.addChild(badCalibrationSaying)
        
        for thisNumber in 0...1{
            thisLineOfText[thisNumber].fontSize = CGFloat(18)
            thisLineOfText[thisNumber].position = CGPointMake(0 - self.frame.width / 2, badCalibrationSaying.position.y - CGFloat(20 * (thisNumber + 1)))
            thisLineOfText[thisNumber].fontColor = deepBlueColour
            self.addChild(thisLineOfText[thisNumber])
            thisLineOfText[thisNumber].runAction(moveInAction)
        }
        
        XImage.position = CGPointMake(0 - self.frame.width / 2, self.frame.height / 2 - 12)
        XImage.setScale(0.5)
        self.addChild(XImage)
        
        blueBubble.setScale(0.5)
        blueBubble.position = CGPointMake(0 - self.frame.width / 2, self.frame.height / 3 - 74)
        self.addChild(blueBubble)
        
        reTryCalibrationLabel.position = CGPointMake(0 - self.frame.width / 2, self.blueBubble.position.y - 10)
        reTryCalibrationLabel.fontSize = CGFloat(20)
        reTryCalibrationLabel.fontColor = whiteColour
        reTryCalibrationLabel.text = "try again"
        self.addChild(reTryCalibrationLabel)
        
        XImage.runAction(moveInAction)
        blueBubble.runAction(moveInAction)
        reTryCalibrationLabel.runAction(moveInAction)
        badCalibrationSaying.runAction(moveInAction)
    }
    
    func randomSayingGenerator() -> Int{
        var randomNumber = arc4random_uniform(3)
        return Int(randomNumber + 1)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.blueBubble || self.nodeAtPoint(location) == self.reTryCalibrationLabel{
                
                buttonPressedSoundPlayer1.play()

                let moveOutAction = SKAction.moveToX(self.frame.width * (3 / 2), duration: 0.44)
                
                blueBubble.runAction(moveOutAction)
                sayingHeading.runAction(moveOutAction)
                badCalibrationSaying.runAction(moveOutAction)
                textLine2.runAction(moveOutAction)
                textLine3.runAction(moveOutAction)
                reTryCalibrationLabel.runAction(moveOutAction)
                XImage.runAction(moveOutAction)
                delay(1){
                    var pauseOutgoingscene = false
                    let scene = CalibrateInstuctionsScene(size: self.scene.size)
                    let skView = self.view as SKView
                    skView.ignoresSiblingOrder = true
                    scene.scaleMode = SKSceneScaleMode.AspectFill
                    scene.size = skView.bounds.size
                    self.scene.view.presentScene(scene)
                }
            }
            
        }
    }
    
}
