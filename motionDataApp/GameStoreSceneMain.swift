//
//  GameStoreScene.swift
//  Move
//
//  Created by Connor Holowachuk on 2014-07-28.
//  Copyright (c) 2014 Connor Holowachuk. All rights reserved.
//

//0xFFD05F

import SpriteKit
import GameKit
import CoreMotion
import AVFoundation

class GameStoreSceneMain: SKScene {
    
    var gamesHeadLabel = SKLabelNode(fontNamed: standardTextFont)
    var backArrow = SKSpriteNode(imageNamed: "backArrowImage")
    var backBubbleTexture = SKTexture()
    
    var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
    var headingCapsule = SKSpriteNode(imageNamed: "titleCapsule")
    
    var maximumPosition = CGFloat(0)
    
    override func didMoveToView(view: SKView!){
        
        maximumPosition = self.frame.width * (3 / 2)
        let minimumPosition = 0 - self.frame.width / 2
        
        let moveToMidXAction = SKAction.moveToX(self.frame.width / 2, duration: 0.44)
        let moveBackArrowAction = SKAction.moveToX(self.frame.height / 12, duration: 0.44)
        
        backgroundImage.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
        backgroundImage.setScale(0.5)
        backgroundImage.zPosition = -4
        self.addChild(backgroundImage)
        
        let headingPosition = self.frame.height * (5 / 6)
        
        headingCapsule.setScale(0.5)
        headingCapsule.position = CGPointMake(self.frame.width / 2, headingPosition)
        self.addChild(headingCapsule)
        
        gamesHeadLabel.position = CGPointMake(maximumPosition, headingPosition - 10)
        gamesHeadLabel.fontColor = deepBlueColour
        gamesHeadLabel.fontSize = 24
        gamesHeadLabel.text = "GAMES"
        self.addChild(gamesHeadLabel)
        gamesHeadLabel.runAction(moveToMidXAction)
        
        backArrow.position = CGPointMake(maximumPosition, self.frame.height / 12)
        backArrow.setScale(0.5)
        self.addChild(backArrow)
        backArrow.runAction(moveBackArrowAction)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.backArrow{
                
                let moveOutAction = SKAction.moveToX(maximumPosition, duration: 0.44)
                self.backArrow.runAction(moveOutAction)
                self.gamesHeadLabel.runAction(moveOutAction)
                
                buttonPressedSoundPlayer1.play()
                delay(0.44){
                    previousScene = Scene_LeaderBoard
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