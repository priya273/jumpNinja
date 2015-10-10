//
//  GameScene.swift
//  jumpNinja
//
//  Created by Naga Sarath Thodime on 7/18/15.
//  Copyright (c) 2015 priyadarshini Ragupathy. All rights reserved.
//
import CoreMotion
import SpriteKit

class GameScene: SKScene , SKPhysicsContactDelegate
{
    //Sknodes are the decendents of SKnode. renders, visual elements,
    var backgroundNode: SKSpriteNode?;
    
    var foregroundNode: SKSpriteNode?;
    
    var playerNode: SKSpriteNode?;
    
    //Variables for accelerometer
    //constant motion manager
    //x asix
    
    ///Declare a bit mask category
    //The bit mask should be unsigned int,coz the collision bit mask is 32 bit
    //These constant variable for the class
    let CollisionCategoryPlayer: UInt32 = 0x1 << 1;
    let CollisionCategoryPowerUpOrb: UInt32 = 0x1 << 2;
    let CollisionCategoryBrick: UInt32 = 0x1 << 3;
    let CollisionCategoryBlackHole: UInt32 = 0x1 << 4;

    let powerUP: String = "POWER_UP";
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
    }
    
    //Adding scrolling of scene
    override func update(currentTime: NSTimeInterval)
    {
        if(playerNode!.position.y >= 180.0)
        {
            backgroundNode!.position = CGPointMake( backgroundNode!.position.x, -((playerNode!.position.y - 180.0) / 8));
            
            
            //foregroundNode!.position = CGPointMake(foregroundNode!.position.x, -(playerNode!.position.y - 200.0));
            
            foregroundNode!.position = CGPointMake(foregroundNode!.position.x, -((playerNode!.position.y - 180.0) / 4));
            
        }
        
        if(playerNode!.position.x >= 150)
        {
           //backgroundNode!.position = CGPointMake((backgroundNode!.position.x
            //- (playerNode!.position.x - 150.0) / 8), backgroundNode!.position.y);
            
            foregroundNode!.position = CGPointMake(-(playerNode!.position.x - 150.0) / 8 ,foregroundNode!.position.y);
        }
    }
    
    var touchImpulseCount = 1;
    let coreMotionManager = CMMotionManager();
    var xAxisAcceleration: CGFloat = 0.0;

    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
       if(!playerNode!.physicsBody!.dynamic)
       {
          playerNode!.physicsBody!.dynamic = true;
       // self.coreMotionManager.deviceMotionUpdateInterval = 0.3;
        //self.coreMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue(), withHandler: {
          //      (data: CMAccelerometerData!, error: NSError!) in
            //    if let constvar = error
              //  {
                //    println("There was an error");
                //}
                //else {
                  //  self.xAxisAcceleration = CGFloat(data!.acceleration.x);
                //}
                
        //})
       }
       else if(touchImpulseCount != 0)
       {
        
        playerNode!.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: 100.0));
        
       }
        /*
       if(touchImpulseCount > 0 )
        {
            playerNode!.physicsBody!.applyImpulse(CGVector(dx: -50.0, dy: 100.0));
            touchImpulseCount--;
        }*/
    
    }
   /*
    override func didSimulatePhysics()
    {
        //self.playerNode!.physicsBody!.velocity =
          //  CGVectorMake(self.xAxisAcceleration * 380.0,  self.playerNode!.physicsBody!.velocity.dy);
        
        
        
        if(playerNode!.position.x < (-(playerNode!.size.width / 2))
        {
            self.playerNode!.position = CGPointMake(size.width - playerNode!.size.width / 2, playerNode!.position.y);
        },
        else if (self.playerNode!.position.x > self.size.width)
        {
        
            self.playerNode!.position = CGPointMake( playerNode!.size.width / 2, playerNode!.position.y);
        }
        
    }
    */
    //Two method protocoal 
    //func didBeginContact()
    //func didContactEnd()
    //WE are interested in when a contact begins
    
    func didBeginContact(contact: SKPhysicsContact)
    {
        //println("There is a contact!");
        var nodeA = contact.bodyA!.node!;
        
        if(nodeA.name == "POWER_UP_ORB")
        {
            nodeA.removeFromParent();
        }
        else if (nodeA.name == "BRICK_ORB")
        {
            playerNode!.physicsBody!.applyImpulse(CGVector(dx: 20.0, dy: 200.0))
        }
        else if(nodeA.name == "BLACK_HOLE")
        {
            //playerNode = SKSpriteNode(imageNamed: "sadbear");
           //  playerNode!.position = CGPoint(x: 100.0, y: 0.0);
            println("The player hit the black hole.");
            playerNode!.physicsBody!.contactTestBitMask = 0;
            touchImpulseCount = 0;
            
            var colorizeAction = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 1);
            playerNode!.runAction(colorizeAction);
            
   
        }
        
    }
    
    override init(size: CGSize)
    {
        super.init(size: size);
        
        self.backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0);
       
        ///Choose a
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0);
        
        //Tell the physical world to send alert when a contact is made
        //Next to tell which object should receive the contact notification
        //TO do this  , we need to use a special object called bit mask
        self.physicsWorld.contactDelegate = self;
    
        self.userInteractionEnabled = true;
        
        
        //----------------------BACKGROUND NODE---------------

        backgroundNode = SKSpriteNode(imageNamed: "background");
        
        backgroundNode!.anchorPoint = CGPoint(x: 0.5, y: 0.0);
        
        backgroundNode!.position = CGPoint(x: size.width / 2.0, y: 0.0);
        
        self.addChild(backgroundNode!);
        
        
        //----------------------FOREGROUND NODE------------
        //we need to add different layers to the gamescene to scroll to different screen
        
        foregroundNode = SKSpriteNode();
        
        self.addChild(foregroundNode!);
        
        addBlackHolestoForeGround();

        //----------------------Brick ONE---------------
        initializeBricks();
        
        //----------------------Coin ORB---------------
        initializePowerOrbs();
        
        initializePlayer();

        
    }
    
    func initializeBricks()
    {
        var orbNodePosition: CGPoint = CGPoint(x: 0.0, y: 600.0);
        let sizeOftheORb :CGSize = CGSize(width: 30.0, height: 20.0);
        
        
        for(var x: Int = 1; x <= 4; x++)
        {
            
            var orbNode1: SKSpriteNode?;
            
            orbNode1 = SKSpriteNode(imageNamed: "brick");
            
            orbNode1!.name = "BRICK_ORB";
            
            orbNode1!.physicsBody = SKPhysicsBody(rectangleOfSize: sizeOftheORb);
            orbNode1!.physicsBody!.dynamic = false;
            
            orbNode1!.anchorPoint = CGPoint(x: 0.5, y: 0.5);
            
            orbNodePosition.x += 70.0;
            orbNodePosition.y -= 120.0;
            orbNode1!.position = orbNodePosition;
            
            //self.addChild(orbNode1!);
            
            foregroundNode!.addChild(orbNode1!);
        }
        
    }
    
    func addBlackHolestoForeGround()
    {
        
        let textureAtlas = SKTextureAtlas(named: "sprites.atlas");
        
        let frame0 = textureAtlas.textureNamed("blackhole0");
        let frame1 = textureAtlas.textureNamed("Blackhole1");
        let frame2 = textureAtlas.textureNamed("Blackhole2");
        let frame3 = textureAtlas.textureNamed("Blackhole3");
        
        let blackholeTexture = [frame0, frame1, frame2, frame3];
       
        let animationAction = SKAction.animateWithTextures(blackholeTexture,  timePerFrame: 2.0);
        
        let rotateAction = SKAction.repeatActionForever(animationAction);
        
        
        //TO MOVE LEFT TO RIGHT
        let moveLeftAction = SKAction.moveToX(10.0, duration: 4.0);
        
        let moveRightAction = SKAction.moveToX(size.width, duration: 4.0);
        
        let movingLTRsequence = SKAction.sequence([moveLeftAction, moveRightAction]);
        
        let moveAction = SKAction.repeatActionForever(movingLTRsequence);
        
        
        
        var blackHoleNode: SKSpriteNode?
        
        blackHoleNode = SKSpriteNode(imageNamed: "newpic");
        
        blackHoleNode!.position = CGPointMake(300.0, size.height - 50.0);
        
        
        blackHoleNode!.physicsBody = SKPhysicsBody(circleOfRadius: blackHoleNode!.size.width / 2);
        
        blackHoleNode!.physicsBody!.dynamic = false;
        
        blackHoleNode!.name = "BLACK_HOLE";
        
        blackHoleNode!.physicsBody!.categoryBitMask = self.CollisionCategoryBlackHole;
        
        blackHoleNode!.physicsBody!.collisionBitMask = 0;
        
        blackHoleNode!.runAction(moveAction);
        
        blackHoleNode!.runAction(animationAction);
        
        foregroundNode!.addChild(blackHoleNode!);

    }
    
    func initializePlayer()
    {
        // -------------------------PLAYER --------------
        playerNode = SKSpriteNode(imageNamed: "bear");
        
        playerNode!.physicsBody = SKPhysicsBody(circleOfRadius: playerNode!.size.width / 2.0);
        
        playerNode!.physicsBody!.dynamic = false;
        
        //To allow friction to the body when it falls from the sky , it reduces speed due to friction
        playerNode!.physicsBody!.linearDamping = 1.0;
        
        playerNode!.physicsBody!.allowsRotation = true;
        
        playerNode!.anchorPoint = CGPoint(x: 0.0, y: 0.5);
        
        playerNode!.position = CGPoint(x: 100.0, y: 550.0);
        
        //We are defining the player category bit mask
        playerNode!.physicsBody!.categoryBitMask = CollisionCategoryPlayer;
        
        //We want to Sprite kit to notify the object which the players category gets in contact with
        playerNode!.physicsBody!.contactTestBitMask = CollisionCategoryPowerUpOrb | CollisionCategoryBlackHole | CollisionCategoryBrick;
        
        //Tells the Sprite kit not to handle collision for the player object
        
        playerNode!.physicsBody!.collisionBitMask = 0;
        
        
        //self.addChild(playerNode!);
        
        foregroundNode?.addChild(playerNode!);

    }
    
    func initializePowerOrbs()
    {
        
        var coinNodePosition: CGPoint = CGPoint(x: 350.0, y: 500);
        
        for(var i: Int = 1; i <= 4; i++)
        {
            
            var coinOrbNode: SKSpriteNode?;
            
            coinOrbNode = SKSpriteNode(imageNamed: "coin");
            
            
            coinOrbNode!.physicsBody = SKPhysicsBody(circleOfRadius: coinOrbNode!.size.height / 2);
            
            coinOrbNode!.physicsBody!.dynamic = false;
            
            
            
            coinOrbNode!.physicsBody!.categoryBitMask = CollisionCategoryPowerUpOrb;
            
            //We are not setting the contactTest bit mask Since, when the player object gets in contact
            //With your object, Sprite Kit will send a notification to this object
            //This is where the did begin contact method is invoked.
            
            coinOrbNode!.physicsBody!.collisionBitMask = 0;
            
            coinNodePosition.y -= 100;
            
            coinOrbNode!.position = coinNodePosition;
            
            coinOrbNode!.name = "POWER_UP_ORB";
            
            //self.addChild(coinOrbNode!);
            foregroundNode!.addChild(coinOrbNode!);
        }
        
        
    }
}
