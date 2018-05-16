//
//  MainMenuScene.swift
//  Move
//
//  Created by Connor Holowachuk on 2014-07-27.
//  Copyright (c) 2014 Connor Holowachuk. All rights reserved.
//

import SpriteKit
import CoreMotion
import AVFoundation

class MainMenuScene: SKScene{
    
    var mainMenuLabel = SKLabelNode(fontNamed: standardTextFont)
    
    var headingCapsule = SKSpriteNode(imageNamed: "titleCapsule")
    
    var playGameLabel = SKLabelNode(fontNamed: standardTextFont)
    var settingsLabel = SKLabelNode(fontNamed: standardTextFont)
    var leaderBoardLabel = SKLabelNode(fontNamed: standardTextFont)
    var gamesLabel = SKLabelNode(fontNamed: standardTextFont)
    
    var playButton = SKSpriteNode(imageNamed: "playButtonImage")
    var settingsButton = SKSpriteNode(imageNamed: "settingsButtonImage")
    var scoresButton = SKSpriteNode(imageNamed: "scoresButtonImage")
    var gamesButton = SKSpriteNode(imageNamed: "gamesButtonImage")
    
    var blankNodeA = SKSpriteNode()
    var blankNodeB = SKSpriteNode()
    var blankNodeC = SKSpriteNode()
    var blankNodeD = SKSpriteNode()
    
    var blankNodeTexture = SKTexture()
    
    var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
    
    override func didMoveToView(view: SKView!){
        
        let shiftRightButtonsAction = SKAction.moveToX(self.frame.width / 6 + 22, duration: 0.44)
        let shiftLeftLabelsAction = SKAction.moveToX(self.frame.width / 2 + 36, duration: 0.44)
        
        backgroundImage.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
        backgroundImage.setScale(0.5)
        backgroundImage.zPosition = -4
        self.addChild(backgroundImage)
        
        headingCapsule.setScale(0)
        headingCapsule.position = CGPointMake(self.frame.width / 2, self.frame.height * (5 / 6))
        self.addChild(headingCapsule)
        if previousScene == Scene_BeginingPlayScene{
            headingCapsule.setScale(0)
            headingCapsule.runAction(scaleUpActionMedBubble)
        }else{
            headingCapsule.setScale(0.5)
        }
        
        mainMenuLabel.position = CGPointMake(self.headingCapsule.position.x, self.headingCapsule.position.y - 10)
        mainMenuLabel.fontSize = CGFloat(24)
        mainMenuLabel.fontColor = deepBlueColour
        mainMenuLabel.text = "MAIN MENU"
        mainMenuLabel.zPosition = CGFloat(-1)
        self.addChild(mainMenuLabel)
        if previousScene == Scene_BeginingPlayScene{
            mainMenuLabel.setScale(0)
            mainMenuLabel.runAction(scaleUpActionLabels)
        }else{
            mainMenuLabel.position = CGPointMake(0 - self.frame.width / 2, self.headingCapsule.position.y - 10)
            let shiftTextToMidX = SKAction.moveToX(self.frame.width / 2, duration: 0.44)
            mainMenuLabel.setScale(1)
            mainMenuLabel.runAction(shiftTextToMidX)
        }
        
        var labels: [SKLabelNode] = [playGameLabel, gamesLabel, leaderBoardLabel, settingsLabel]
        var gameBubbles: [SKSpriteNode] = [playButton, gamesButton, scoresButton, settingsButton]
        
        var labelText: [String] = ["play", "games", "score", "settings"]
        
        for thisNumber in 0...3{
            var thisYPosition = self.frame.height * (10 / 12) - (CGFloat(thisNumber) * (self.frame.height / CGFloat(7.44))) - (self.frame.height / CGFloat(6))
            
            gameBubbles[thisNumber].setScale(0.5)
            gameBubbles[thisNumber].zPosition = CGFloat(4 - thisNumber)
            gameBubbles[thisNumber].position = CGPointMake(0 - (gameBubbles[thisNumber].size.width / 2), thisYPosition - 32)
            self.addChild(gameBubbles[thisNumber])
            gameBubbles[thisNumber].runAction(shiftRightButtonsAction)
            
            labels[thisNumber].position = CGPointMake(self.frame.width * (4 / 3), gameBubbles[thisNumber].position.y - 8)
            labels[thisNumber].fontSize = CGFloat(20)
            labels[thisNumber].fontColor = deepBlueColour
            labels[thisNumber].text = labelText[thisNumber]
            labels[thisNumber].zPosition = CGFloat(-1)
            labels[thisNumber].setScale(1)
            self.addChild(labels[thisNumber])
            labels[thisNumber].runAction(shiftLeftLabelsAction)
        }
        
        println("mainMenuLabel position is: \(mainMenuLabel)")
        
        blankNodeTexture = SKTexture(imageNamed: "blankNodeImage")
        blankNodeTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        blankNodeA = SKSpriteNode(texture: blankNodeTexture)
        blankNodeA.xScale = (self.frame.width / 10)
        blankNodeA.yScale = ((self.frame.height / 6) / 10)
        blankNodeA.position = CGPointMake(self.frame.width / 2, self.frame.height * (8 / 12))
        self.addChild(blankNodeA)
        
        blankNodeB = SKSpriteNode(texture: blankNodeTexture)
        blankNodeB.xScale = (self.frame.width / 10)
        blankNodeB.yScale = ((self.frame.height / 6) / 10)
        blankNodeB.position = CGPointMake(self.frame.width / 2, self.frame.height * (6 / 12))
        self.addChild(blankNodeB)
        
        blankNodeC = SKSpriteNode(texture: blankNodeTexture)
        blankNodeC.xScale = (self.frame.width / 10)
        blankNodeC.yScale = ((self.frame.height / 6) / 10)
        blankNodeC.position = CGPointMake(self.frame.width / 2, self.frame.height * (4 / 12))
        self.addChild(blankNodeC)
        
        blankNodeD = SKSpriteNode(texture: blankNodeTexture)
        blankNodeD.xScale = (self.frame.width / 10)
        blankNodeD.yScale = ((self.frame.height / 6) / 10)
        blankNodeD.position = CGPointMake(self.frame.width / 2, self.frame.height * (2 / 12))
        self.addChild(blankNodeD)
        
        previousScene = Scene_MainMenu
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    func switchToNextScene(thisScene: SKScene){
        
        let moveOutLeftAction = SKAction.moveToX(0 - playButton.size.width, duration: 0.4)
        let moveOutRightAction = SKAction.moveToX(self.frame.size.width * (4 / 3), duration: 0.4)
        
        var labels: [SKLabelNode] = [playGameLabel, gamesLabel, leaderBoardLabel, settingsLabel]
        var gameBubbles: [SKSpriteNode] = [playButton, gamesButton, scoresButton, settingsButton]
        
        for thisNumber in 0...3{
            labels[thisNumber].runAction(moveOutRightAction)
            gameBubbles[thisNumber].runAction(moveOutLeftAction)
        }
        
        self.mainMenuLabel.runAction(moveOutLeftAction)
        
        buttonPressedSoundPlayer1.play()

        delay(0.8){
            let skView = self.view as SKView
            skView.ignoresSiblingOrder = true
            self.scene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene.size = skView.bounds.size
            self.scene.view.presentScene(thisScene)
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.blankNodeA{
                println("lets get this partay started!!!")
                var thisScene: SKScene = CalibrateInstuctionsScene(size: self.scene.size)
                switchToNextScene(thisScene)
                
            }else if self.nodeAtPoint(location) == self.blankNodeB{
                println("settin's")
                var thisScene: SKScene = GameStoreSceneMain(size: self.scene.size)
                switchToNextScene(thisScene)
                
            }else if self.nodeAtPoint(location) == self.blankNodeC{
                println("who da best?")
                var thisScene: SKScene = LeaderBoardSceneMain(size: self.scene.size)
                switchToNextScene(thisScene)
                
            }else if self.nodeAtPoint(location) == self.blankNodeD{
                println("shoppppin timeee!!!")
                var thisScene: SKScene = SettingsSceneMain(size: self.scene.size)
                switchToNextScene(thisScene)
            }
        }
    }
    
}