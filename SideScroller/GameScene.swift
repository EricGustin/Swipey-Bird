//
//  GameScene.swift
//  SideScroller
//
//  Created by Eric Gustin on 7/21/20.
//  Copyright © 2020 Eric Gustin. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  
  private var background = [SKSpriteNode]()
  private var player: SKSpriteNode!
  
  override func didMove(to view: SKView) {
    setUpNodes()
  }
  
  override func update(_ currentTime: TimeInterval) {
    moveGround()
    moveBackground()
  }
  
  private func setUpNodes() {
    createBackground()
    createGround()
    createPlayer()
  }
  
  private func createBackground() {
    //  Set up background
    for i in 0..<2 {
      background.append(SKSpriteNode(imageNamed: "background@4x"))
      background[i].name = "Background"
      let scale = (self.scene?.size.height)! / background[i].frame.height
      background[i].setScale(scale)
      background[i].anchorPoint = CGPoint(x: 0.5, y: 0.5)
      background[i].zPosition = -2
      background[i].position = CGPoint(x: CGFloat(i)*background[i].frame.width, y: 0)
      self.addChild(background[i])
    }
  }
  
  private func createGround() {
    //  Set up ground
    for i in 0..<2 {
      let groundImage = SKSpriteNode(imageNamed: "ground@4x")
      groundImage.name = "Ground"
      groundImage.size = CGSize(width: (self.scene?.size.width)!, height: 250)
      groundImage.anchorPoint = CGPoint(x: 0.5, y: 0.5)
      groundImage.zPosition = -1
      groundImage.position = CGPoint(x: CGFloat(i)*groundImage.size.width, y: -self.frame.size.height/2)
      
      self.addChild(groundImage)
    }
  }
  
  private func createPlayer() {
    player = SKSpriteNode(imageNamed: "player@4x")
    player.name = "Player"
    player.zPosition = 0
    player.setScale(CGFloat(0.25))
    player.position = CGPoint(x: -(scene?.frame.width)!/12, y: 0)
    let transform = SKTransformNode()
    transform.addChild(player)
    
    scene?.addChild(transform)
    transform.yRotation = 5*CGFloat.pi/12
  }
  
  private func moveGround() {
    self.enumerateChildNodes(withName: "Ground") { (node, error) in
      node.position.x -= 2
      if node.position.x < -(self.scene?.size.width)! {
        node.position.x += ((self.scene?.size.width)!)*2
      }
    }
  }
  
  private func moveBackground() {
    self.enumerateChildNodes(withName: "Background") { (node, error) in
      node.position.x -= 0.1
      if node.position.x < -node.frame.width {
        node.position.x += (node.frame.width*2)
      }
    }
  }
  
  func touchDown(atPoint pos : CGPoint) {
  }
  
  func touchMoved(toPoint pos : CGPoint) {
  }
  
  func touchUp(atPoint pos : CGPoint) {
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
  }
}
