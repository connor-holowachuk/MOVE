//
//  WarningScene.swift
//  Move
//
//  Created by Connor Holowachuk on 2014-07-30.
//  Copyright (c) 2014 Connor Holowachuk. All rights reserved.
//

import SpriteKit
import GameKit
import CoreMotion
import AVFoundation

class WarningScene: SKScene {
    
    var warningHeading = SKLabelNode(fontNamed: standardTextBoldFont)
    var textLine1 = SKLabelNode(fontNamed: standardTextFont)
    var textLine2 = SKLabelNode(fontNamed: standardTextFont)
    var textLine3 = SKLabelNode(fontNamed: standardTextFont)
    var textLine4 = SKLabelNode(fontNamed: standardTextFont)
    var textLine5 = SKLabelNode(fontNamed: standardTextFont)
    
    var continueButtonLabel = SKLabelNode(fontNamed: bubbleTextFont)
    var whiteBubble = SKSpriteNode()

    override func didMoveToView(view: SKView!){
        
        self.backgroundColor = blueColour
        
        warningHeading.position = CGPointMake(self.frame.width / 2, self.frame.height * (5 / 6))
        warningHeading.fontSize = CGFloat(28)
        warningHeading.setScale(0)
        warningHeading.fontColor = darkGreyColour
        warningHeading.text = "HEY, YOU!"
        self.addChild(warningHeading)
        warningHeading.runAction(scaleUpActionLabels)
        
        var linesOfText: [SKLabelNode] = [textLine1, textLine2, textLine3, textLine4, textLine5]
        var textPerLine: [String] = ["BE CAREFUL OUT THERE! WE", "DONT WANT YOU GETTING HURT,", "ESPECIALLY WHEN YOU'RE HAVING", "FUN! KEEP YOUR HEAD UP,", "WATCH YOUR STEP AND BE SAFE!"]
        
        for thisNumber in 0...4{
            linesOfText[thisNumber].position = CGPointMake(self.frame.width / 2, (self.frame.height * (5 / 6)) - 16 - CGFloat(22 * (thisNumber + 2)))
            linesOfText[thisNumber].fontSize = CGFloat(16)
            linesOfText[thisNumber].setScale(0)
            linesOfText[thisNumber].fontColor = whiteColour
            linesOfText[thisNumber].text = textPerLine[thisNumber]
            self.addChild(linesOfText[thisNumber])
            linesOfText[thisNumber].runAction(scaleUpActionLabels)
        }
        
        var whiteBubbleTexture = SKTexture(imageNamed: "whiteBubbleImage")
        whiteBubbleTexture.filteringMode = SKTextureFilteringMode.Nearest
        whiteBubble = SKSpriteNode(texture: whiteBubbleTexture)
        whiteBubble.setScale(0)
        whiteBubble.position = CGPointMake(self.frame.width / 2, self.frame.height / 3)
        self.addChild(whiteBubble)
        whiteBubble.runAction(scaleUpActionBubble)
        
        continueButtonLabel.position = CGPointMake(self.frame.width / 2, (self.frame.height / 3) - 16)
        continueButtonLabel.fontSize = CGFloat(32)
        continueButtonLabel.setScale(0)
        continueButtonLabel.fontColor = darkGreyColour
        continueButtonLabel.text = "GOT IT!"
        self.addChild(continueButtonLabel)
        continueButtonLabel.runAction(scaleUpActionLabels)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.whiteBubble || self.nodeAtPoint(location) == self.continueButtonLabel{

                buttonPressedSoundPlayer1.play()
                
                previousScene = Scene_BeginingPlayScene
                
                let scaleDownAction = SKAction.scaleTo(CGFloat(0) , duration: 0.4)
                let scaleUpAction = SKAction.scaleTo(CGFloat(4) , duration: 0.4)
                self.whiteBubble.runAction(scaleDownAction)
                self.continueButtonLabel.runAction(scaleDownAction)
                self.warningHeading.runAction(scaleDownAction)
                self.textLine1.runAction(scaleDownAction)
                self.textLine2.runAction(scaleDownAction)
                self.textLine3.runAction(scaleDownAction)
                self.textLine4.runAction(scaleDownAction)
                self.textLine5.runAction(scaleDownAction)
                delay(1){
                    let scene = MainMenuScene(size: self.scene.size)
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

