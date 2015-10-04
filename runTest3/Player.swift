//
//  Player.swift
//  runTest3
//
//  Created by kevcol on 10/3/15.
//  Copyright © 2015 kevcol inc. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    // Controls
    var playerIndex = 0
    
    var jumpPressedDown = false
    var spinPressedDown = false
    
    
    //State
    var health = 1.0

    var groundY:CGFloat = 0.0
    var previousY:CGFloat = 0.0
    
    var isRunning:Bool = true
    var isJumping:Bool = false
    var isSpinning:Bool = false
    
    // Animations
    var runAction:SKAction?
    var jumpAction:SKAction?
    var spinAction:SKAction?
    
    var jumpAmount:CGFloat = 0
    var maxJump:CGFloat = 20
    
    var minSpeed:CGFloat = 6
    
    var spinTime:NSTimeInterval = 5
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init (imageNamed:String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color:SKColor.clearColor(), size: imageTexture.size() )
        
       let hillSize:CGSize = CGSize(width: 60, height: 250)
        let body:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: hillSize)
        body.dynamic = true
        body.affectedByGravity = true
        body.allowsRotation = false
        body.restitution = 0.0
        body.categoryBitMask = BodyType.player.rawValue
        body.contactTestBitMask = BodyType.troll.rawValue | BodyType.potHole.rawValue | BodyType.villain.rawValue | BodyType.projectile.rawValue  | BodyType.vote.rawValue | BodyType.moolah.rawValue | BodyType.spinToken.rawValue | BodyType.invisiGround.rawValue
        body.collisionBitMask = BodyType.invisiGround.rawValue | BodyType.potHole.rawValue
        body.friction = 0.9 //0 is like glass, 1 is like sandpaper to walk on
        self.physicsBody = body 
        
        setUpRun()
        setUpJump()
        setUpSpin()
        startRun()
        
    }
    
    
    func setUpRun() {
        
        let atlas = SKTextureAtlas (named: "Hillary")
        var array = [String]()
        
        //or setup an array with exactly the sequential frames start from 1
        for var i=1; i <= 25; i++ {
            
            let nameString = String(format: "hillary_runs_%i", i)
            array.append(nameString)
        }
        
        //create another array this time with SKTexture as the type (textures being the .png images)
        var atlasTextures:[SKTexture] = []
        
        for (var i = 0; i < array.count; i++ ) {
            
            let texture:SKTexture = atlas.textureNamed( array[i] )
            atlasTextures.insert(texture, atIndex:i)
            
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1.0/60, resize: true , restore:false )
        runAction =  SKAction.repeatActionForever(atlasAnimation)
        
    }
    
    
    func setUpJump() {
        
        let atlas = SKTextureAtlas (named: "Hillary")
        
        var array = [String]()
        
        // or setup an array with exactly the sequential frames start from 1
        for var i = 1; i <= 25; i++ {
            let nameString = String(format: "hillary_jumps_%i", i)
            array.append(nameString)
        }
        
        // create another array, this time with SKTexture as the type (.png's)
        var atlasTextures:[SKTexture] = []
        
        for (var i = 0; i < array.count; i++) {
            
            let texture:SKTexture = atlas.textureNamed(array[i])
            atlasTextures.insert(texture, atIndex: i)
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1.0/60, resize: true, restore: false)
        jumpAction = SKAction.repeatActionForever(atlasAnimation)
        
    }
    
    func setUpSpin() {
        
        let atlas = SKTextureAtlas (named: "Hillary")
        
        var array = [String]()
        
        //or set up an array with exactly the sequential frames, start from 1
        for var i = 1; i <= 15; i++ {
            
            let nameString = String(format: "hillary_spin_%i", i)
            array.append(nameString)
        
        }
        
        // create another array, this time with SKTexture as the type (.png's)
        var atlasTextures:[SKTexture] = []
        
        for (var i = 0; i < array.count; i++) {
            
            let texture:SKTexture = atlas.textureNamed(array[i])
            atlasTextures.insert(texture, atIndex: i)
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1.0/60, resize: true, restore: false)
        spinAction = SKAction.repeatActionForever(atlasAnimation)

    }
    
    func startRun(){
        
        isSpinning = false
        isRunning = true
        isJumping = false
        
        // self.removeActionForKey("jumpKey")
        // self.removeActionForKey("spinKey")
        self.runAction(runAction! , withKey:"runKey")
        
    }

    
    func startJump() {
        
        isSpinning = false
        isRunning = false
        isJumping = true
        
        // self.removeActionForKey("runKey")
        // self.removeActionForKey("spinKey")
        self.runAction(runAction! , withKey:"jumpKey")
        
    }
    
    func startSpin() {
        
        isSpinning = true
        isRunning = false
        isJumping = false
        
        // self.removeActionForKey("runKey")
        // self.removeActionForKey("jumpKey")
        self.runAction(runAction! , withKey:"spinKey")

        
    }
    
    
}