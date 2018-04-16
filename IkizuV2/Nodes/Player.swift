//
//  Player.swift
//  IkizuV2
//
//  Created by Robin kamo on 2018-04-12.
//  Copyright © 2018 Robin kamo. All rights reserved.
//

import SceneKit
import Foundation


enum PlayerAnimationType {
    case walk, attack1, dead
}

class Player:SCNNode{
    
    //nodes
    private var deaHolderNode = SCNNode()
    private var characterNode: SCNNode!
     var aim: SCNNode!
 
    //animations
    private var walkAnimation = CAAnimation()
    private var attack1Animation = CAAnimation()
    private var deadAnimation = CAAnimation()
    
    //movement
    private var previousUpdateTime = TimeInterval(0.0)
    private var isWalking:Bool = false

    
    
    var isAttacking = false
    var attackTimer:Timer?
    var attackFrameCounter = 0
    
    var directionAngel:Float = 0.0 {
        didSet {
            if directionAngel != oldValue {
                runAction(SCNAction.rotateTo(x: 0.0, y: CGFloat(directionAngel), z: 0.0, duration: 0.1, usesShortestUnitArc: true))
            }
        }
    }
    
    
    override init() {
        super.init()
        setupModel()
        loadAnimations()
        setupModel()
        setupAim()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAim(){
        let geometry = SCNBox(width: 100, height: 100, length: 50, chamferRadius: 0.5)
        aim = SCNNode(geometry: geometry)
        aim.position =  SCNVector3Make(position.x, position.y + 400 , directionAngel + 2000)
        self.addChildNode(aim)
        
    }
    
    
    //Scene
    func setupModel(){
        
        //load dae childs
        let playerURL = Bundle.main.url(forResource: "art.scnassets/Scenes/Hero/idle", withExtension: "dae")
        let playerScene = try! SCNScene(url: playerURL!, options: nil)
        
        for child in playerScene.rootNode.childNodes {
            
            deaHolderNode.addChildNode(child)
        }
        addChildNode(deaHolderNode)
        
        //set mesh name
        characterNode = deaHolderNode.childNode(withName: "Bip01", recursively: true)!
        
    }
    //Animations
    func loadAnimations(){
        
        loadAnimation(animationType: .walk, isSceneNamed: "art.scnassets/Scenes/Hero/walk", withIdentifier: "WalkID")
        
        loadAnimation(animationType: .attack1, isSceneNamed: "art.scnassets/Scenes/Hero/attack", withIdentifier: "attackID")

        loadAnimation(animationType: .dead, isSceneNamed: "art.scnassets/Scenes/Hero/die", withIdentifier: "DeathID")

    }
    
    
    
    
    
    
    func loadAnimation(animationType:PlayerAnimationType, isSceneNamed scene:String, withIdentifier identifier: String){
        
        let sceneURL = Bundle.main.url(forResource: scene, withExtension: "dae")!
        let sceneSoure = SCNSceneSource(url: sceneURL, options: nil)!
        
        let animationObject:CAAnimation = sceneSoure.entryWithIdentifier(identifier, withClass: CAAnimation.self)!
        
        animationObject.delegate = self
        animationObject.fadeInDuration = 0.2
        animationObject.fadeOutDuration = 0.2
        animationObject.usesSceneTimeBase = false
        animationObject.repeatCount = 0
        
        
        switch animationType {
        case .walk:
            animationObject.repeatCount = Float.greatestFiniteMagnitude
            walkAnimation = animationObject
      
        case .dead:
            animationObject.isRemovedOnCompletion = false
            deadAnimation = animationObject
            
        case .attack1:
            animationObject.setValue("attack1", forKey: "animationId")
            attack1Animation = animationObject
        }
        
    }
    
    func walkInDirection(_ direction:float3, time:TimeInterval, scene: SCNScene){
        
        if previousUpdateTime == 0.0 {
            previousUpdateTime = time
        }
        
        let deltaTime = Float(min(time-previousUpdateTime, 1.0/60.0))
        let characterSpeed = deltaTime * 10
        previousUpdateTime = time
        
        if direction.x != 0.0 && direction.z != 0.0 {
            //movving char
            let pos = float3(position)
            position = SCNVector3(pos+direction * characterSpeed)
            
            //udating the angle
            directionAngel = SCNFloat(atan2f(direction.x, direction.z))
            
            
            
            isWalking = true
            
        } else {
            isWalking = false
        }
        
        
    }

}


extension Player: CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //
    }
}

