//
//  GameViewController.swift
//  IkizuV2
//
//  Created by Robin kamo on 2018-04-11.
//  Copyright © 2018 Robin kamo. All rights reserved.
//


import SceneKit
import SpriteKit

enum GameState{
    case loading, playing
}

class GameViewController: UIViewController {
    //Scene
    var gameView:GameView { return view as! GameView}
    var mainScene:SCNScene!
    var currentBallNode: SCNNode?


    //general
    var gameState:GameState = .loading
    
    //nodes
     var player:Player?
     var cameraStick:SCNNode!
     var cameraXHolder:SCNNode!
     var cameraYHolder:SCNNode!
    //player2Nodes
    var bro:Player?
    
    //movement
     var controllerStoredDirection = float2(0.0)
     var padTouch:UITouch?
     var cameraTouch:UITouch?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupPlayer()
        setupBro()
        setupCamera()
        gameState = .playing
        
        mainScene.fogColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        mainScene.fogStartDistance = 10
        mainScene.fogEndDistance = 100
        mainScene.fogDensityExponent = 0.1
    }
    
    
    //MARK:- SCENE
    func setupScene(){
      //  gameView.allowsCameraControl = true
        gameView.antialiasingMode = .multisampling4X
        gameView.delegate = self
        mainScene = SCNScene(named: "art.scnassets/Scenes/Stage1.scn")
        gameView.scene = mainScene
        gameView.isPlaying = true
    
        
    }
    
    //MARK:- WALLS
    
    
    
    //MARK:- CAMERA
     func setupCamera(){
        cameraStick = mainScene.rootNode.childNode(withName: "CameraStick", recursively: true)!
        
        cameraXHolder = mainScene.rootNode.childNode(withName: "xHolder", recursively: true)!
        
        cameraYHolder = mainScene.rootNode.childNode(withName: "yHolder", recursively: true)!
        
    }
    
     func panCamera (_ direction:float2){
        var directionToPan = direction
        directionToPan *= float2(1.0, -1.0)
        
        let panReducer = Float(0.005)
        
        let currX = cameraXHolder.rotation
        let xRotationValue = currX.w - directionToPan.x * panReducer
        
        let currY = cameraYHolder.rotation
        var yRotationValue = currY.w + directionToPan.y * panReducer
        
        if yRotationValue < -0.94 { yRotationValue = -0.94 }
        if yRotationValue > 0.66 { yRotationValue = 0.66 }
        
        cameraXHolder.rotation = SCNVector4Make(0, 1, 0, xRotationValue)
        cameraYHolder.rotation = SCNVector4Make(1, 0, 0, yRotationValue)
    }
    
    //MARK:- PLAYER
     func setupPlayer(){
        
        player = Player()
        player!.scale = SCNVector3Make(0.0046, 0.0046, 0.0046)
        player!.position = SCNVector3Make(0.0, 0.0, 0.0)
        player!.rotation = SCNVector4Make(0, 1, 0, Float.pi)
        
        mainScene.rootNode.addChildNode(player!)
        
    }
    
    //MARK:- BRO
    func setupBro(){
        bro = Player()
        bro!.scale = SCNVector3Make(0.0046, 0.0046, 0.0046)
        bro!.position = SCNVector3Make(5, 0, 5)
        bro!.rotation = SCNVector4Make(0, 1, 0, Float.pi)
        
        mainScene.rootNode.addChildNode(bro!)
    }
    
    //MARK:- TOUCHES + MOVEMENT
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            if gameView.virtualDPadBounds().contains(touch.location(in: gameView)) {
                
                if padTouch == nil {
                    
                    padTouch = touch
                    controllerStoredDirection = float2(0.0)
                }
                
            } else if gameView.virtualAttackButtonBounds().contains(touch.location(in: gameView)) {
                print("mainAttack")
                mainAttack()
                cameraAim()
                
                
            } else if cameraTouch == nil {
                
                cameraTouch = touches.first
            }
            
            if padTouch != nil { break }
        }
        }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if let touch = padTouch {
            
            let displacement = float2(touch.location(in: view)) - float2(touch.previousLocation(in: view))
            
            let vMix = mix(controllerStoredDirection, displacement, t: 0.1)
            let vClamp = clamp(vMix, min: -1.0, max: 1.0)
            
            controllerStoredDirection = vClamp
            
        } else if let touch = cameraTouch {
            
            let displacement = float2(touch.location(in: view)) - float2(touch.previousLocation(in: view))
            
            panCamera(displacement)
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: gameView)
            if gameView.virtualAttackButtonBounds().contains(location) {
                print("bror")
            } else {
                padTouch = nil
                controllerStoredDirection = float2(0.0)
                cameraTouch = nil
            }
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        padTouch = nil
        cameraTouch = nil

        controllerStoredDirection = float2(0.0)
    }
    
    //MARK:- GAME LOOP FUNCTIONS
    func characterDirection() -> float3{
        var direction = float3(x: controllerStoredDirection.x, y: 0.0, z: controllerStoredDirection.y)
        
        if let pov = gameView.pointOfView{
            let p1 = pov.presentation.convertPosition(SCNVector3(direction), to: nil)
            let p0 = pov.presentation.convertPosition(SCNVector3Zero, to: nil)
            
            direction = float3(x: Float(p1.x-p0.x), y: 0.0, z: Float(p1.z-p0.z))
            
            if direction.x != 0.0 || direction.z != 0.0 {
                direction = normalize(direction)
                
            }
        }
        return direction
    }
    
    func updateFollowers(){
        cameraStick.position = SCNVector3Make(player!.position.x, 0.0, player!.position.z)
    }
    
    
    //MARK:- Combat
    func cameraAim(){
        
    }
    
    
    
    
    //TODO 3d asset
    func mainAttack(){
        let ballScene = SCNScene(named: "art.scnassets/Scenes/Hero/Ball.scn")!
        let ballNode = ballScene.rootNode.childNode(withName: "sphere", recursively: true)!
        ballNode.name = "ball"
        let ballPhysicsBody = SCNPhysicsBody(
            type: .dynamic,
            shape: SCNPhysicsShape(geometry: SCNSphere(radius: 0.35))
        )
        ballPhysicsBody.mass = 3
        ballPhysicsBody.friction = 2
        ballPhysicsBody.contactTestBitMask = 1
        ballNode.physicsBody = ballPhysicsBody
        ballNode.position = SCNVector3(x: player!.position.x, y: player!.position.y, z: player!.position.z)
        
        currentBallNode = ballNode
        ballNode.physicsBody?.applyForce(SCNVector3(characterDirection() * 50), asImpulse: true)
        
        mainScene.rootNode.addChildNode(ballNode)
        
        print("nice la")
    }

}

extension GameViewController:SCNSceneRendererDelegate{
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if gameState != .playing {return}
        
        let scene = gameView.scene!
        let direction = characterDirection()
        player?.walkInDirection(direction, time: time, scene: scene)
        
        updateFollowers()
    }

}










