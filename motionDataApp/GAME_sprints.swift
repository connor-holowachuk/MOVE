//
//  GAME_sprints.swift
//  Move
//
//  Created by Connor Holowachuk on 2014-08-11.
//  Copyright (c) 2014 Connor Holowachuk. All rights reserved.
//

import SpriteKit
import CoreMotion

class GAME_sprints: SKScene {
    
    var playerIcon = SKSpriteNode(imageNamed: "arrowButton")
    var xPosLabel = SKLabelNode(fontNamed: standardTextFont)
    var yPosLabel = SKLabelNode(fontNamed: standardTextFont)
    var zPosLabel = SKLabelNode(fontNamed: standardTextFont)

    override func didMoveToView(view: SKView!) {
        self.backgroundColor = whiteColour
        
        
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        
    }
}