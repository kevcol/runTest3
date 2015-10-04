//
//  LayerHUD.swift
//  runTest3
//
//  Created by kevcol on 10/4/15.
//  Copyright © 2015 kevcol inc. All rights reserved.
//


import SpriteKit

class LayerHUD: SKNode {
    
    //--Interface
    var spinCount:SKLabelNode!
    
    //--Buttons
    var jumpButton:SKLabelNode!
    var pauseButton:SKLabelNode!
    var spinButton:SKLabelNode!
    
    
    override init() {
        super.init()
        
        pauseButton = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        pauseButton.fontSize = 42
        pauseButton.position = CGPoint(x: 0.95, y:0.95 )
        pauseButton.fontColor = SKColor.whiteColor()
        pauseButton.alpha = 0.8
        pauseButton.horizontalAlignmentMode = .Right
        pauseButton.verticalAlignmentMode = .Top
        pauseButton.zPosition = 500
        pauseButton.text = "II"
        pauseButton.name = "pauseButton"
        addChild(pauseButton)
        
        jumpButton = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        jumpButton.fontSize = 54
        jumpButton.position = CGPoint(x:0.95, y: 0.05)
        jumpButton.fontColor = SKColor.whiteColor()
        jumpButton.alpha = 0.8
        jumpButton.horizontalAlignmentMode = .Right
        jumpButton.verticalAlignmentMode = .Bottom
        jumpButton.zPosition = 500
        jumpButton.text = "Jump"
        jumpButton.name = "jumpButton"
        addChild(jumpButton)
        
        spinButton = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        spinButton.fontSize = 54
        spinButton.position = CGPoint(x:0.05, y: 0.05)
        spinButton.fontColor = SKColor.whiteColor()
        spinButton.alpha = 0.8
        spinButton.horizontalAlignmentMode = .Left
        spinButton.verticalAlignmentMode = .Bottom
        spinButton.zPosition = 500
        spinButton.text = "Spin"
        spinButton.name = "spinButton"
        addChild(spinButton)
        
        spinButton = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        spinButton.fontSize = 32
        spinButton.position = CGPoint(x:0.5, y: 0.02)
        spinButton.fontColor = SKColor.whiteColor()
        spinButton.alpha = 0.8
        spinButton.horizontalAlignmentMode = .Center
        spinButton.verticalAlignmentMode = .Bottom
        spinButton.zPosition = 500
        spinButton.text = "Spins: 3"
        spinButton.name = "spinButton"
        addChild(spinButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(delta:CFTimeInterval) {
        
        spinButton.text = "Spins (TK): \((3))"
        
    }
    
}
