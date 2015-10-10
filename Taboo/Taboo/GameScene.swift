//
//  GameScene.swift
//  Taboo
//
//  Created by Naga Sarath Thodime on 7/30/15.
//  Copyright (c) 2015 priyadarshini Ragupathy. All rights reserved.
//

import SpriteKit

class GameScene: SKScene
{
    //Sknodes are the decendents of SKnode. renders, visual elements,
    var backgroundNode: SKSpriteNode?;
    
    var foregroundNode: SKSpriteNode?;
    
    var playerNode: SKSpriteNode?;
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
    }
    
    override init(size: CGSize)
    {
        super.init(size: size);
        
        self.backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0);
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0);
        
        //Tell the physical world to send alert when a contact is made
        //Next to tell which object should receive the contact notification
        //TO do this  , we need to use a special object called bit mask
        
        //self.userInteractionEnabled = true;
        
        println(size.width);
        println(size.height);
        //----------------------BACKGROUND NODE---------------
        
        backgroundNode = SKSpriteNode(imageNamed: "background");
        
        backgroundNode!.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        
        backgroundNode!.position = CGPoint(x: 100, y: 190);
        
        self.addChild(backgroundNode!);
        
        
        //----------------------FOREGROUND NODE------------
        //we need to add different layers to the gamescene to scroll to different screen
        
        foregroundNode = SKSpriteNode();
        
        self.addChild(foregroundNode!);
        
        
        var gameTitle: SKSpriteNode?;
        
        gameTitle = SKSpriteNode(imageNamed: "game");
        
        
        gameTitle!.physicsBody = SKPhysicsBody(circleOfRadius: gameTitle!.size.height / 2);
        
        gameTitle!.physicsBody!.dynamic = false;
        gameTitle!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gameTitle!.position = CGPoint(x: size.width / 2, y: 550 )
    
    
        foregroundNode!.addChild(gameTitle!);
        
        /*
        var one: SKSpriteNode?;
        
        one = SKSpriteNode(imageNamed: "game");
        one!.physicsBody = SKPhysicsBody(circleOfRadius: gameTitle!.size.height / 2);
        one!.physicsBody!.dynamic = false;
        one!.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        one!.position = CGPoint(x: size.width / 2, y: 550 );
        foregroundNode!.addChild(one!);

        
        
        var two: SKSpriteNode?;
        
        two = SKSpriteNode(imageNamed: "game");
        
        
        two!.physicsBody = SKPhysicsBody(circleOfRadius: gameTitle!.size.height / 2);
        
        two!.physicsBody!.dynamic = false;
        two!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        two!.position = CGPoint(x: size.width / 2, y: 550 )
        
        
        foregroundNode!.addChild(two!);
        
        var three: SKSpriteNode?;
        
        three = SKSpriteNode(imageNamed: "game");

        three!.physicsBody = SKPhysicsBody(circleOfRadius: gameTitle!.size.height / 2);
        
        three!.physicsBody!.dynamic = false;
        three!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        three!.position = CGPoint(x: size.width / 2, y: 550 )
    
        foregroundNode!.addChild(three!);
        

    */
    }


}
