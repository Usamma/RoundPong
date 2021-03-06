//
//  GameScene.swift
//  RoundOng Extension
//
//  Created by Michal Lučanský on 16.5.17.
//  Copyright © 2017 Michal Lučanský. All rights reserved.
//
import SpriteKit
import WatchKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var ball = Ball()
    private var player = PlayerPaddle()
    private var playerPosition = CGPoint()
    private var path = UIBezierPath()
    private var playerPath = UIBezierPath()
    private var circle = CircleBorder()
    static var angle : CGFloat = 0.1
    static var gameStatus = true
    private  var gameOver1 = LabelCreator(text: "", position: CGPoint(x: 0, y: 0), fontSize: 32, name: "GameOverLabel")
    private var tap = LabelCreator(text: "Tap Twice to Continue...", position: CGPoint(x: 0, y: -90), fontSize: 23, name: "TapLabel")
    private var gameOverLabel = SKLabelNode()
    private var tapLab = SKLabelNode()
    private var score = 0
    private var playerNode = SKShapeNode()
    private var ballNode = SKSpriteNode()
    
    
    override func sceneDidLoad() {
        
        gameOverLabel = gameOver1.createLabel()
        tapLab = tap.createLabel()
        

        self.scene?.isPaused = true
        GameScene.gameStatus = true
        gameInit()
        self.physicsWorld.contactDelegate = self
        
        
        
        }
        
    private func gameInit(){
    
        if GameScene.gameStatus{
            print("idem")
    gameOverLabel.removeFromParent()
    tapLab.removeFromParent()
        }
        
   
        
    // Y position of the player paddle and radius of the circular border 
        
    let positionYRadius = CGFloat((self.frame.height - 90) / 2)
    
    
   
       
    // creating Player Node
    playerPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: positionYRadius - 5  , startAngle: CGFloat(0.5) , endAngle: CGFloat(1), clockwise: true)
    playerNode = player.playerNode(path: playerPath )
    addChild(playerNode)
       
       
    
        
    // Creating path for the moving radius circle
        
    path =  UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: positionYRadius, startAngle: .pi * -2, endAngle: CGFloat(0), clockwise: true)
    addChild(circle.createCircle(path: path))
        
    // Add ball with move impulse
        
    ballNode = ball.ball()
    addChild(ballNode)
    ballNode.physicsBody?.applyImpulse(CGVector(dx: 12, dy: 12))
        
    }
    
    
    private func gameOver(){
        
        GameScene.angle = 0.1
        score = 0
        GameScene.gameStatus = false
        gameOverLabel.text = "Your score is \(score) !"
        addChild(gameOverLabel)
        addChild(tapLab)
        self.scene?.isPaused = true
        playerNode.removeFromParent()
        ballNode.removeFromParent()
        childNode(withName: "moveCircleRadius")?.removeFromParent()
        
        
    
    
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let node1 = contact.bodyA
        let node2 = contact.bodyB
        
        if node1.node?.name == "ball" && node2.node?.name == "player" || node1.node?.name == "player" && node2.node?.name == "ball"{
           
            moveControll()
            score += 1
            
            
        }
        if node1.node?.name == "ball" && node2.node?.name == "moveCircleRadius" || node1.node?.name == "moveCircleRadius" && node2.node?.name == "ball"{
        
            
            ballNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0))
            GameScene.gameStatus = false
            
            
        }
    }
    
   private  func randomFloat(from: CGFloat, to: CGFloat) -> CGFloat {
        let rand: CGFloat = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        return (rand) * (to - from) + from
    }
    
    private func randomDirection() -> CGFloat {
        let speedFactor: CGFloat = 15
        if randomFloat(from: 0, to: 15) >= 7 {
            return -speedFactor
        } else {
            return speedFactor
        }
    }
    
    
    private func moveControll(){
        let ball = ballNode
        var xSpeed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx)
        let ySpeed = sqrt(ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
        
        
       

        if xSpeed != ySpeed{
        xSpeed = ySpeed
        }
    
    }
  
    
  
    
    
        override func update(_ currentTime: TimeInterval) {
         

            
        if GameScene.gameStatus == true{
            
        player.calculatePosition(playerNode: playerNode, radius: 1, angle: GameScene.angle)
            
        }
        
       else if GameScene.gameStatus == false{
            gameOver()
           
        }
    }
    
    
}
