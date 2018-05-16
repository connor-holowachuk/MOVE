//
//  BeginingPlayScreen.swift
//  Move
//
//  Created by Connor Holowachuk on 2014-07-23.
//  Copyright (c) 2014 Connor Holowachuk. All rights reserved.
//

import SpriteKit
import CoreMotion
import AVFoundation

class BeginingPlayScreen: SKScene {
    
    var calibrateButtonLabel = SKLabelNode(fontNamed: bubbleTextFont)
    var greenBubble = SKSpriteNode()
    var blueBubble = SKSpriteNode()
    var redBubble = SKSpriteNode()
    var yellowBubble = SKSpriteNode()
    var purpleBubble = SKSpriteNode()
    
    var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")
    
    override func didMoveToView(view: SKView!){

        
        println("GameScene")
        
        //setup the scene
        backgroundImage.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
        backgroundImage.setScale(0.5)
        backgroundImage.zPosition = -4
        self.addChild(backgroundImage)
        
        //setup the calibrate button
        var blueBubbleTexture = SKTexture(imageNamed: "blueBubbleImage")
        blueBubbleTexture.filteringMode = SKTextureFilteringMode.Nearest
        blueBubble = SKSpriteNode(texture: blueBubbleTexture)
        blueBubble.setScale(0.24)
        blueBubble.position = CGPointMake(-86.784, self.frame.height / 2)
        
        calibrateButtonLabel.position = CGPointMake(-86.784, self.frame.height / 2 - 14)
        calibrateButtonLabel.fontColor = whiteColour
        calibrateButtonLabel.text = "PLAY"
        self.addChild(calibrateButtonLabel)
        
        //setup the bubbles
        var bubbleNodes: [SKSpriteNode] = [self.greenBubble, self.redBubble, self.yellowBubble, self.purpleBubble]
        
        var greenBubbleTexture = SKTexture(imageNamed: "greenBubbleImage")
        var redBubbleTexture = SKTexture(imageNamed: "redBubbleImage")
        var yellowBubbleTexture = SKTexture(imageNamed: "yellowBubbleImage")
        var purpleBubbleTexture = SKTexture(imageNamed: "purpleBubbleImage")
        
        var bubbleTextures: [SKTexture] = [greenBubbleTexture, redBubbleTexture, yellowBubbleTexture, purpleBubbleTexture]
        
        var maxNumberOfBubbles = randomNumberOfBubblesGenerator()
        
        for thisNumber in 0...maxNumberOfBubbles{
            
            var indexNumber = self.randomBubbleColorPicker()
            
            bubbleTextures[indexNumber].filteringMode = SKTextureFilteringMode.Nearest
            bubbleNodes[indexNumber] = SKSpriteNode(texture: bubbleTextures[indexNumber])
            bubbleNodes[indexNumber].setScale(self.randomNodeSize())
            
            var bubbleSize = bubbleNodes[indexNumber].size.width
            
            bubbleNodes[indexNumber].position = CGPointMake(self.randomXPosGenerator(bubbleSize), self.randomYPosGenerator(bubbleSize))
            println(bubbleNodes[indexNumber].position)
            bubbleNodes[indexNumber].zPosition = CGFloat(0)
            
            bubbleNodes[indexNumber].physicsBody = SKPhysicsBody(circleOfRadius: bubbleSize / 2)
            bubbleNodes[indexNumber].physicsBody.dynamic = true
            bubbleNodes[indexNumber].physicsBody.allowsRotation = true
            bubbleNodes[indexNumber].physicsBody.affectedByGravity = false
            bubbleNodes[indexNumber].physicsBody.restitution = CGFloat(1.0)
            bubbleNodes[indexNumber].physicsBody.friction = CGFloat(0.0)
            bubbleNodes[indexNumber].physicsBody.usesPreciseCollisionDetection = true
            bubbleNodes[indexNumber].physicsBody.linearDamping = CGFloat(0.0)
            bubbleNodes[indexNumber].physicsBody.angularDamping = CGFloat(0.0)
            bubbleNodes[indexNumber].physicsBody.mass = CGFloat(bubbleSize / 44)
            bubbleNodes[indexNumber].physicsBody.charge = CGFloat(4)
            
            bubbleNodes[indexNumber].setScale(0)
            self.addChild(bubbleNodes[indexNumber])
            let thisScaleUpAction = SKAction.scaleTo(bubbleSize / 744, duration: 0.744)
            bubbleNodes[indexNumber].runAction(thisScaleUpAction)
            bubbleNodes[indexNumber].physicsBody.applyImpulse(CGVectorMake(0, self.randomImpulseGenerator()))
            
            println("indexNumber: \(indexNumber), size: \(bubbleSize)")
        }
        
        self.addChild(blueBubble)
        
        let moveGreenBubbleAction = SKAction.moveToX(self.frame.width / 2, duration: 0.744)
        
        self.blueBubble.runAction(moveGreenBubbleAction)
        self.calibrateButtonLabel.runAction(moveGreenBubbleAction)
        
        
    }
    
    //generate random number of bubbles
    func randomNumberOfBubblesGenerator() -> Int{
        let randomNumber = arc4random_uniform(1)
        let totalBubbles = randomNumber + 4
        return Int(totalBubbles)
    }
    
    //generate random bubble colour
    func randomBubbleColorPicker() -> Int{
        let randomNumber = arc4random_uniform(4)
        return Int(randomNumber)
    }
    
    //generate random bubble size
    func randomNodeSize() -> CGFloat{
        let nodeSize = Double(arc4random_uniform(84) + 23)
        let scaledNodeSize = Double(nodeSize / 444)
        return CGFloat(scaledNodeSize)
    }
    
    //generate random bubble position
    func randomXPosGenerator(sizeOfBubble: CGFloat) -> CGFloat{
        var randomXPos = arc4random_uniform(UInt32(self.frame.size.width - (sizeOfBubble)))
        var newRandomXPos = (sizeOfBubble / 2) + CGFloat(randomXPos)
        return newRandomXPos
    }
    
    func randomYPosGenerator(sizeOfBubble: CGFloat) -> CGFloat{
        var randomYPos = arc4random_uniform(UInt32(self.frame.size.height - (2 * sizeOfBubble)))
        var newRandomYPos = (sizeOfBubble / 2) + CGFloat(randomYPos)
        return newRandomYPos
    }
    
    func randomImpulseGenerator() -> CGFloat{
        var randomImpulse = Int(arc4random_uniform(UInt32(1444)))
        var scaledImpulse = CGFloat(randomImpulse - 722)
        return scaledImpulse
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    func switchToNextScene(){
        let scene = WarningScene(size: self.scene.size)
        let skView = self.view as SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = SKSceneScaleMode.AspectFill
        scene.size = skView.bounds.size
        self.scene.view.presentScene(scene)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.blueBubble || self.nodeAtPoint(location) == self.calibrateButtonLabel{
                
                buttonPressedSoundPlayer1.play()
                
                previousScene = Scene_BeginingPlayScene
                
                self.calibrateButtonLabel.runAction(scaleDownAction)
                self.blueBubble.runAction(scaleUpAction)
                delay(1){
                    self.switchToNextScene()
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}
