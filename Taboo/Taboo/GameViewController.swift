//
//  GameViewController.swift
//  Taboo
//
//  Created by Naga Sarath Thodime on 7/30/15.
//  Copyright (c) 2015 priyadarshini Ragupathy. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController
{
    
    //Declare Game scene class, which does most of our game logic
    var scene: GameScene!;
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true;
    }
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        //downcaste the UI view to SKview
        
        
        var skview: SKView = view as! SKView;
        
        skview.showsFPS = true;
        
        //pass size to position objects
        
        scene = GameScene(size: skview.bounds.size);
        scene!.scaleMode = SKSceneScaleMode.AspectFill;
        
        //get contents of the scene. and present it to the user
        skview.presentScene(scene!);
        
        
    }

}

 