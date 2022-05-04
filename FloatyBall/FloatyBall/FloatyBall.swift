//
//  FloatyBall.swift
//  FloatyBall
//
//  Created by Joel Hollingsworth on 4/14/22.
//

import SpriteKit

class FloatyBall: SKShapeNode {
    
    init(circleOfRadius: CGFloat) {
        super.init()
        
        let diameter = circleOfRadius * 2.0
        self.path = CGPath(ellipseIn:
                CGRect(origin: CGPoint.zero,
                       size: CGSize(width: diameter, height: diameter)), transform: nil)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: circleOfRadius, center: CGPoint(x: circleOfRadius, y: circleOfRadius))
        self.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsBody?.collisionBitMask = 0b0000
        self.physicsBody?.contactTestBitMask = 0b0001
        self.name = "ball"
        
        self.fillColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVelZero(){
        self.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
    }
    
    func changeSize(newRad: CGFloat){
        let newDia = newRad * 2.0
        self.path = CGPath(ellipseIn:
                CGRect(origin: CGPoint.zero,
                       size: CGSize(width: newDia, height: newDia)), transform: nil)
        self.physicsBody = SKPhysicsBody(circleOfRadius: newRad, center: CGPoint(x: newRad, y: newRad))
    }
    
    func update(screen: CGRect, radius: Double) {
        
            let diameter = radius * 2
            //teleport from right side
            if self.position.x + diameter > screen.maxX{
                let action = SKAction.moveTo(x: screen.maxX - diameter, duration: 0)
                self.run(action)
            }
            
            //teleport from left side
            if self.position.x < screen.minX{
                let action = SKAction.moveTo(x: screen.minX, duration: 0)
                self.run(action)
            }
            
            //teleport from top
            if self.position.y + diameter > screen.maxY{
                let action = SKAction.moveTo(y: screen.maxY - diameter, duration: 0)
                self.run(action)
            }
            
            //teleport from bottom
            if self.position.y < screen.minY{
                let action = SKAction.moveTo(y: screen.minY, duration: 0)
                self.run(action)
            }
        }
    
    
}
