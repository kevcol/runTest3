//
//  GameScene.swift
//  runTest3
//
//  Created by kevcol on 10/3/15.
//  Copyright (c) 2015 kevcol inc. All rights reserved.
//

import SpriteKit

enum BodyType:UInt32 {
    
    case player = 1
    case troll = 2
    case villain = 4
    case projectile = 8
    case vote = 16
    case moolah = 32
    case spinToken = 64
    case invisiGround = 128
    case potHole = 256
    
    
}


class GameScene: SKScene {

    
    /*  controls
    var layerHUD = LayerHUD() */
    
    // invisi-ground
    let invisiGround: SKSpriteNode
    
    // sky
    var backgroundNode:SKSpriteNode
    
    // buildings
    let buildingsNode:SKSpriteNode
    let buildingsNodeNext:SKSpriteNode
    
    // bushes
    let bushesNode:SKSpriteNode
    let bushesNodeNext:SKSpriteNode
    
    // street
    let streetNode:SKSpriteNode
    let streetNodeNext:SKSpriteNode
    
    // obstacles
    var trollNode:SKSpriteNode
    var potHoleNode:SKSpriteNode
    
    // time of last frame
    var lastFrameTime: NSTimeInterval = 0
    
    // time since last frame
    var deltaTime: NSTimeInterval = 0
    
    // add the Player
    let thePlayer:Player
    let startingPosition:CGPoint = CGPoint(x: 200, y: 800)
    
    
    override init(size: CGSize) {
        //let aspectHeight = 0.56221*size.width;

        
        
        // Prepare big background - sky and street
        backgroundNode = SKSpriteNode(imageNamed: "background1")
        backgroundNode.zPosition = -100
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        // Prepare the building sprites
        buildingsNode = SKSpriteNode(imageNamed: "background4")
        buildingsNode.zPosition = -90
        buildingsNode.position = CGPoint(x: size.width / 2, y: (backgroundNode.size.height / 2) + 200)
        
        buildingsNodeNext = buildingsNode.copy() as! SKSpriteNode
        buildingsNodeNext.zPosition = -90
        buildingsNodeNext.position = CGPoint(x: buildingsNode.position.x + buildingsNode.size.width, y: buildingsNode.position.y)
        
        // Prepare the bushes sprites
        bushesNode = SKSpriteNode(imageNamed: "background3")
        
        bushesNode.zPosition = -80
        bushesNode.position = CGPoint(x: size.width / 2, y: (backgroundNode.size.height / 2) + 87)
        
        bushesNodeNext = bushesNode.copy() as! SKSpriteNode
        bushesNodeNext.zPosition = -80
        bushesNodeNext.position = CGPoint(x: bushesNode.position.x + bushesNode.size.width, y: bushesNode.position.y)

        // Prepare the street sprites
        streetNode = SKSpriteNode(imageNamed: "background2")
        streetNode.zPosition = -70
        streetNode.position = CGPoint(x: size.width / 2, y: (backgroundNode.size.height / 2) - 87)
        
        streetNodeNext = streetNode.copy() as! SKSpriteNode
        streetNodeNext.zPosition = -70
        streetNodeNext.position = CGPoint(x: streetNode.position.x + streetNode.size.width, y: streetNode.position.y)
        
        // Put in a floor so Player stays in the frame
        invisiGround = SKSpriteNode(color: SKColor.clearColor(),
            size:CGSize(width: backgroundNode.size.width, height: 10))
        invisiGround.position = CGPoint(x: size.width / 2, y: (backgroundNode.size.height / 2) - 310)
        invisiGround.zPosition = 0
        // REFACTOR: CHANGE PHYSICS BODY TO EDGE FROM POINT -- MORE PERFORMANT
        invisiGround.physicsBody = SKPhysicsBody(rectangleOfSize: invisiGround.size)
        invisiGround.physicsBody?.dynamic = false
        
        
        // Prepare static obstacles
        // IN REAL GAME, NEED TO RANDOMIZE PLACEMENT
        trollNode = SKSpriteNode(imageNamed: "troll_eyes")
        trollNode.position = CGPoint(x: 0, y: -170 )
        trollNode.zPosition = 10
        //trollNode.physicsBody = SKPhysicsBody(rectangleOfSize:trollNode.size)
        //trollNode.physicsBody?.dynamic = false
        
        potHoleNode = SKSpriteNode(texture: SKTexture(imageNamed: "potHole"))
        potHoleNode.position = CGPoint(x: streetNode.size.width / 2.5, y:-220)
        potHoleNode.zPosition = 10
        //potHoleNode.physicsBody = SKPhysicsBody(rectangleOfSize:potHoleNode.size)
        //potHoleNode.physicsBody?.dynamic = false
        
        // Prepare the player
        // IN REAL GAME, WOULD HAVE SELECTION SCREEN FIRST, TO PICK CANDIDATE
        thePlayer = Player(imageNamed: "hillary_runs_1")
        thePlayer.position = startingPosition
        thePlayer.zPosition = 50
        
        
        super.init(size: size)
        
        // Add the sprites to the scene
        self.addChild(backgroundNode)
        self.addChild(buildingsNode)
        self.addChild(buildingsNodeNext)
        self.addChild(bushesNode)
        self.addChild(bushesNodeNext)
        self.addChild(streetNode)
        self.addChild(streetNodeNext)
        self.addChild(thePlayer)
        self.addChild(invisiGround)
    
        
        
        streetNode.addChild(trollNode)
        streetNodeNext.addChild(potHoleNode)
        
        
        
        //thePlayer.startRun()
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    // Move a pair of sprites leftward based on a speed value;
    // when either of the sprites goes off-screen, move it to the
    // right so that it appears to be seamless movement
    
    func moveSprite(sprite: SKSpriteNode, nextSprite: SKSpriteNode, speed: Float) -> Void {
        
        var newPosition = CGPointZero
        
        // For both the sprite and its duplicate:
        for spriteToMove in [sprite, nextSprite] {
            
            // Shift the sprite leftward based on the speed
            newPosition = spriteToMove.position
            newPosition.x -= CGFloat(speed * Float(deltaTime))
            spriteToMove.position = newPosition
            
            // If this sprite is now offscreen (i.e., its rightmost edge is
            // farther left than the scene's leftmost edge):
            if spriteToMove.frame.maxX < self.frame.minX {
                
                // Shift it over so that it's now to the immediate right
                // of the other sprite.
                // This means that the two sprites are effectively
                // leap-frogging each other as they both move.
                spriteToMove.position = CGPoint(x: spriteToMove.position.x + spriteToMove.size.width * 2, y: spriteToMove.position.y)
            }
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        // First, update the delta time values:
        // If we don't have a last frame time value, this is the first frame,
        // so delta time will be zero.
        if lastFrameTime <= 0 {
            lastFrameTime = currentTime
        }
        
        // Update delta time
        deltaTime = currentTime - lastFrameTime
        
        // Set last frame time to current time
        lastFrameTime = currentTime
        
        // Next, move each of the four pairs of sprites.
        // Objects that should appear move slower than foreground objects.
        self.moveSprite(buildingsNode, nextSprite:buildingsNodeNext, speed:50.0)
        self.moveSprite(bushesNode, nextSprite:bushesNodeNext, speed:100.0)
        self.moveSprite(streetNode, nextSprite:streetNodeNext, speed:150.0)
    }
    
    
}
