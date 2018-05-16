//
//  GameScene.swift
//  motionDataApp
//
//  Created by Connor Holowachuk on 2014-07-16.
//  Copyright (c) 2014 Connor Holowachuk. All rights reserved.
//

import SpriteKit
import GameKit
import CoreMotion
import AVFoundation

class GameScene: SKScene {
    
    var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
    var welcomeLabel = SKLabelNode(fontNamed: standardTextFont)
    var subHeadingLabel = SKLabelNode(fontNamed: standardTextFont)
    
    override func didMoveToView(view: SKView!){
        
        backgroundImage.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
        backgroundImage.setScale(0.5)
        backgroundImage.zPosition = -4
        self.addChild(backgroundImage)
        
        buttonPressedSoundPlayer1 = AVAudioPlayer(contentsOfURL: buttonPressedSoundPlayer1URL, error: nil)
        buttonPressedSoundPlayer1.numberOfLoops = 0
        buttonPressedSoundPlayer1.prepareToPlay()
        
        self.backgroundColor = whiteColour
        
        var headingPosition = CGFloat(self.frame.height / 2)

        welcomeLabel.position = CGPointMake(self.frame.width / 2, headingPosition + 10)
        welcomeLabel.fontColor = deepBlueColour
        welcomeLabel.fontSize = CGFloat(24)
        welcomeLabel.text = "WELCOME TO MOVE"
        self.addChild(welcomeLabel)
        
        subHeadingLabel.position = CGPointMake(self.frame.width / 2, headingPosition - 20)
        subHeadingLabel.fontColor = darkGreyColour
        subHeadingLabel.fontSize = CGFloat(16)
        subHeadingLabel.text = "BY WiMP GAMES"
        self.addChild(subHeadingLabel)
        delay(2){
            self.delay(1){
                self.switchToNextScene()
            }
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    func switchToNextScene(){
        
        previousScene = Scene_BeginingPlayScene
        
        let scene = MainMenuScene(size: self.scene.size)
        let skView = self.view as SKView
        let thisTransition = SKTransition.crossFadeWithDuration(0.4)
        skView.ignoresSiblingOrder = true
        scene.scaleMode = SKSceneScaleMode.AspectFill
        scene.size = skView.bounds.size
        self.scene.view.presentScene(scene, transition: thisTransition)
    }
}