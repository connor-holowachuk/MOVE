//
//  GameSelectScenePage1.swift
//  Move
//
//  Created by Connor Holowachuk on 2014-08-01.
//  Copyright (c) 2014 Connor Holowachuk. All rights reserved.
//

import SpriteKit
import CoreMotion
import AVFoundation

class GameSelectScenePage1: SKScene{
    
    var instructionHeading = SKLabelNode(fontNamed: standardTextBoldFont)
    var badCalibrationSaying = SKLabelNode()
    
    var headingCapsule = SKSpriteNode(imageNamed: "titleCapsule")
    
    var GAME_shootingRange = SKSpriteNode(imageNamed: "Game_shootingRangeImage")
    var GAME_sprints = SKSpriteNode(imageNamed: "Game_sprintsImage")
    
    var GAME_shootingRangeLabel = SKLabelNode(fontNamed: standardTextFont)
    var GAME_sprintsLabel = SKLabelNode(fontNamed: standardTextFont)
    
    var backArrow = SKSpriteNode(imageNamed: "backArrowImage")
    
    var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
    
    override func didMoveToView(view: SKView!) {
        
        let moveInActionCentre = SKAction.moveToX(self.frame.width / 2, duration: 0.44)
        let moveInActionButtonLeft = SKAction.moveToX(self.frame.width * 4 / 15, duration: 0.44)
        let moveInActionButtonRight = SKAction.moveToX(self.frame.width * 11 / 15, duration: 0.44)
        let moveArrowAction = SKAction.moveToX(self.frame.height / 12, duration: 0.44)
        
        let thisYPosition = self.frame.height * 9 / 15
        let startingXPosition = self.frame.width * 3 / 2
        
        backgroundImage.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
        backgroundImage.setScale(0.5)
        backgroundImage.zPosition = -4
        self.addChild(backgroundImage)
        let headingPosition = CGFloat(self.frame.height * 5 / 6)
        
        headingCapsule.setScale(0.5)
        headingCapsule.position = CGPointMake(startingXPosition, self.frame.height * 5 / 6)
        self.addChild(headingCapsule)
        
        instructionHeading.position = CGPointMake(startingXPosition, headingPosition - 10)
        instructionHeading.fontColor = deepBlueColour
        instructionHeading.fontSize = 24
        instructionHeading.text = "CHOOSE GAME"
        self.addChild(instructionHeading)
        
        headingCapsule.runAction(moveInActionCentre)
        instructionHeading.runAction(moveInActionCentre)
        
        GAME_shootingRange.setScale(0.5)
        GAME_shootingRange.position = CGPointMake(startingXPosition, thisYPosition)
        self.addChild(GAME_shootingRange)
        GAME_shootingRange.runAction(moveInActionButtonLeft)
        
        GAME_shootingRangeLabel.position = CGPointMake(startingXPosition, GAME_shootingRange.position.y - GAME_shootingRange.size.height / 2 - 16)
        GAME_shootingRangeLabel.fontSize = 14
        GAME_shootingRangeLabel.text = "shooting range"
        GAME_shootingRangeLabel.fontColor = deepBlueColour
        self.addChild(GAME_shootingRangeLabel)
        GAME_shootingRangeLabel.runAction(moveInActionButtonLeft)
        
        GAME_shootingRangeLabel.position = CGPointMake(startingXPosition, GAME_shootingRange.position.y - GAME_shootingRange.size.height / 2 - 16)
        GAME_sprintsLabel.fontSize = 14
        GAME_sprintsLabel.text = "sprints"
        GAME_sprintsLabel.fontColor = deepBlueColour
        self.addChild(GAME_sprintsLabel)
        GAME_sprintsLabel.runAction(moveInActionButtonRight)
        
        GAME_sprints.setScale(0.5)
        GAME_sprints.position = CGPointMake(startingXPosition, thisYPosition)
        self.addChild(GAME_sprints)
        GAME_sprints.runAction(moveInActionButtonRight)
        
        backArrow.setScale(0.5)
        backArrow.position = CGPointMake(startingXPosition, self.frame.height / 12)
        self.addChild(backArrow)
        backArrow.runAction(moveArrowAction)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.GAME_sprints{
                
            }
        }
    }
}


