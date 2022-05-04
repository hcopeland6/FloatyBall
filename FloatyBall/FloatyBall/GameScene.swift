//
//  GameScene.swift
//  Ships
//
//  Created by Joel Hollingsworth on 4/4/21.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Game Controller Sprites
    private var up    = SKSpriteNode(imageNamed: "arrow")
    private var down  = SKSpriteNode(imageNamed: "arrow")
    private var left  = SKSpriteNode(imageNamed: "arrow")
    private var right = SKSpriteNode(imageNamed: "arrow")
    
    var scoreLabel = SKLabelNode(text: "Score: 0")
    
    var gameView: GameView? = nil
    
    var diffVelocity = 0.0
    
    var goodTime = 0.0
    var badTime = 0.0
    var gameOverTime = 0.0
    
    let ball = FloatyBall(circleOfRadius: 10)
    private var ballRadius = 10.0
    private var ballSpeed = 100.0
    var maxSize = CGFloat(25.0)
    var gameOver = false
    
    var score = 0
    
    private enum Directions {
        case up
        case down
        case left
        case right
        case still
    }
    
    var difficulty = ""
    
    private var rememberedTouches = [UITouch:Directions]()
    
    /*
     * didMove() is called when the scene is placed into
     * the view. Initialize and setup the game here.
     */
    override func didMove(to view: SKView) {
        // enable the FPS label
        view.showsFPS = true
        
        scoreLabel.position = CGPoint(x: frame.midX , y: frame.maxY - 50)
        addChild(scoreLabel)
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        physicsBody?.friction = 0
        
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(ball)
        
        setDifficultyVals(diff: difficulty)

        
        // Game Controller
        up.position = CGPoint(x: frame.midX, y: 300)
        up.scale(to: CGSize(width: 110, height: 110))
        up.zRotation = 3.0 * CGFloat.pi / 2.0
        up.zPosition = 3
        up.name = "up"
        addChild(up)
        
        down.position = CGPoint(x: frame.midX, y: 100)
        down.scale(to: CGSize(width: 110, height: 110))
        down.zRotation = CGFloat.pi / 2.0
        down.zPosition = 3
        down.name = "down"
        addChild(down)
        
        left.position = CGPoint(x: frame.midX - 100, y: 200)
        left.scale(to: CGSize(width: 110, height: 110))
        left.zRotation = 0.0
        left.zPosition = 3
        left.name = "left"
        addChild(left)
        
        right.position = CGPoint(x: frame.midX + 100, y: 200)
        right.scale(to: CGSize(width: 110, height: 110))
        right.zRotation = CGFloat.pi
        right.zPosition = 3
        right.name = "right"
        addChild(right)
    }
    
    func setDifficultyVals(diff: String){
        if(diff == "easy") {
            //print("difficulty is easy")
            diffVelocity = 75.0
            maxSize = CGFloat(20.0)
            ballSpeed = 125.0
        } else if (diff == "normal") {
            //print("difficulty is normal")
            diffVelocity = 100.0
            maxSize = CGFloat(25.0)
            ballSpeed = 100.0
        } else if (diff == "hard"){
            //print("difficulty is hard")
            diffVelocity = 125.0
            maxSize = CGFloat(30.0)
            ballSpeed = 75.0
            ballRadius = 5.0
            ball.changeSize(newRad: ballRadius)
        } else {
            //print("no difficulty, shutting down")
            gameView?.endScene()
            return
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let touchPosition = touch.location(in: self)
            let touchNode = atPoint(touchPosition)
            
            if touchNode.name == "up" {
                //print("starting up")
                rememberedTouches[touch] = .up
            } else if touchNode.name == "down" {
                //print("starting down")
                rememberedTouches[touch] = .down
            } else if touchNode.name == "left" {
                //print("starting left")
                rememberedTouches[touch] = .left
            } else if touchNode.name == "right" {
                //print("starting right")
                rememberedTouches[touch] = .right
            }
        
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let touchPosition = touch.location(in: self)
            let touchNode = atPoint(touchPosition)
            
            if touchNode.name == "up" {
                //print("ended up")
                rememberedTouches.removeValue(forKey: touch)
                ball.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
            } else if touchNode.name == "down" {
                //print("ended down")
                rememberedTouches.removeValue(forKey: touch)
                ball.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
            } else if touchNode.name == "left" {
                //print("ended left")
                rememberedTouches.removeValue(forKey: touch)
                ball.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
            } else if touchNode.name == "right" {
                //print("ended right")
                rememberedTouches.removeValue(forKey: touch)
                ball.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
            }
        
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let touchPosition = touch.location(in: self)
            let touchNode = atPoint(touchPosition)
            
            if touchNode.name == "up" {
                //print("moving up")
            } else if touchNode.name == "down" {
                //print("moving down")
            } else if touchNode.name == "left" {
                //print("moving left")
            } else if touchNode.name == "right" {
                //print("moving right")
            } else {
                //print("no longer touching anything")
                rememberedTouches[touch] = .still
                //rememberedTouches.removeValue(forKey: touch)
                ball.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
            }
        
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA.name == "ball" && nodeB.name == "goodCircle" {
            ballRadius += 5
            ball.changeSize(newRad: ballRadius)
            nodeB.removeFromParent()
        } else if nodeA.name == "goodCircle" && nodeB.name == "ball" {
            ballRadius += 5
            ball.changeSize(newRad: ballRadius)
            nodeA.removeFromParent()
        }
        
        if nodeA.name == "ball" && nodeB.name == "badSquare" {
            if(ballRadius - 5 == 0){
                gameOver = true
                nodeB.removeFromParent()
            } else {
                ballRadius -= 5
                ball.changeSize(newRad: ballRadius)
                nodeB.removeFromParent()
            }
        } else if nodeA.name == "badSquare" && nodeB.name == "ball" {
            if(ballRadius - 5 == 0){
                gameOver = true
                nodeA.removeFromParent()
            } else {
                ballRadius -= 5
                ball.changeSize(newRad: ballRadius)
                nodeA.removeFromParent()
            }
        }
    }
    
    func makeGoodCir(){
        let randRad = CGFloat.random(in: 10...35)
        let randEdge = Int.random(in:0...3)
        let velocity = CGFloat(Double((score * 5)) + diffVelocity)
        let gCircle = SKShapeNode(circleOfRadius: randRad)
        
        
        gCircle.physicsBody = SKPhysicsBody(circleOfRadius: randRad)
        gCircle.physicsBody?.isDynamic = true
        gCircle.physicsBody?.linearDamping = 0.0
        
        if randEdge == 0 {
            gCircle.position.x = frame.minX - randRad * 2 + 5
            gCircle.position.y = CGFloat.random(in: 20...frame.maxY - 20)
            //gCircle.physicsBody?.velocity = CGVector(dx: velocity, dy: 0.0)
            gCircle.physicsBody?.velocity.dx = velocity
        } else if randEdge == 1 {
            gCircle.position.x = frame.maxX + randRad * 2 + 5
            gCircle.position.y = CGFloat.random(in: 20...frame.maxY - 20)
            //gCircle.physicsBody?.velocity = CGVector(dx: -velocity, dy: 0.0)
            gCircle.physicsBody?.velocity.dx = -velocity
        } else if randEdge == 2 {
            gCircle.position.x = CGFloat.random(in: 20...frame.maxX - 20)
            gCircle.position.y = frame.maxY + randRad * 2 + 5
            //gCircle.physicsBody?.velocity = CGVector(dx: 0.0, dy: -velocity)
            gCircle.physicsBody?.velocity.dy = -velocity
        } else {
            gCircle.position.x = CGFloat.random(in: 20...frame.maxX - 20)
            gCircle.position.y = frame.minY - randRad * 2 + 5
            //gCircle.physicsBody?.velocity = CGVector(dx: 0.0, dy: velocity)
            gCircle.physicsBody?.velocity.dy = velocity
        }
    
        gCircle.fillColor = .green
        gCircle.strokeColor = .green
        
        gCircle.physicsBody?.collisionBitMask = 0b0000
        gCircle.physicsBody?.contactTestBitMask = 0b0001
        
        gCircle.name = "goodCircle"
        addChild(gCircle)
    }
    
    func makeBadSquare() {
        let randWidth = CGFloat.random(in: 20.0...75.0)
        let randHeight = randWidth
        let randEdge = Int.random(in:0...3)
        let velocity = CGFloat(Double((score * 5)) + diffVelocity)

        let bSquare = SKShapeNode(rectOf: CGSize(width: randWidth, height: randHeight))
        
        
        bSquare.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: randWidth, height: randHeight))
        bSquare.physicsBody?.isDynamic = true
        bSquare.physicsBody?.linearDamping = 0.0
        
        
        if randEdge == 0 {
            bSquare.position.x = frame.minX - randWidth + 5
            bSquare.position.y = CGFloat.random(in: 20...frame.maxY - 20)
            bSquare.physicsBody?.velocity = CGVector(dx: velocity, dy: 0.0)
        } else if randEdge == 1 {
            bSquare.position.x = frame.maxX + randWidth + 5
            bSquare.position.y = CGFloat.random(in: 20...frame.maxY - 20)
            bSquare.physicsBody?.velocity = CGVector(dx: -velocity, dy: 0.0)
        } else if randEdge == 2 {
            bSquare.position.x = CGFloat.random(in: 20...frame.maxX - 20)
            bSquare.position.y = frame.maxY + randWidth + 5
            bSquare.physicsBody?.velocity = CGVector(dx: 0.0, dy: -velocity)
        } else {
            bSquare.position.x = CGFloat.random(in: 20...frame.maxX - 20)
            bSquare.position.y = frame.minY - randWidth + 5
            bSquare.physicsBody?.velocity = CGVector(dx: 0.0, dy: velocity)
        }
        
        bSquare.fillColor = .red
        bSquare.strokeColor = .red
        
        bSquare.physicsBody?.collisionBitMask = 0b0000
        bSquare.physicsBody?.contactTestBitMask = 0b0001
        
        bSquare.name = "badSquare"
        addChild(bSquare)
    }
    
    /*
     * update() is called on for each new frame before the
     * scene is drawn. Make the code as streamlined as possible
     * since it runs (hopefully) 60 times a second.
     */
    
    var count = 0
    override func update(_ currentTime: TimeInterval) {
        
        if(gameOverTime != 0.0 && gameOverTime + 2 < currentTime) {
            gameView?.endScene()
            return
        }
        
        ball.update(screen: frame, radius: ballRadius)
        //print(gameOver)
        
        //add to the score and reset ball size
        if ballRadius >= maxSize {
            ballRadius = 5.0
            score += 1
            scoreLabel.text = String("Score: \(score)")
        }
        
        //controls
        for (_, dir) in rememberedTouches {
            if dir == .up {
                //print(String(currentTime) + ": UP")
                ball.physicsBody?.velocity = CGVector(dx: 0.0, dy: ballSpeed)
            }
            
            if dir == .down {
                //print(String(currentTime) + ": DOWN")
                ball.physicsBody?.velocity = CGVector(dx: 0.0, dy: -ballSpeed)
            }
            
            if dir == .left {
                //print(String(currentTime) + ": LEFT")
                ball.physicsBody?.velocity = CGVector(dx: -ballSpeed, dy: 0.0)
            }
            
            if dir == .right {
                //print(String(currentTime) + ": RIGHT")
                ball.physicsBody?.velocity = CGVector(dx: ballSpeed, dy: 0.0)
            }
        }
        
        
        //spawn in good circles
        if goodTime == 0.0{
            goodTime = currentTime
            makeGoodCir()
            
        } else if goodTime != 0.0 && goodTime + 2.5 < currentTime {
            makeGoodCir()
            goodTime = currentTime
        }
        
        //spawn in bad squares
        if badTime == 0.0{
            badTime = currentTime
            makeBadSquare()
        } else if badTime != 0.0 && badTime + 2.5 < currentTime {
            makeBadSquare()
            badTime = currentTime
        }

        if(gameOver && gameOverTime == 0.0){
            gameOverTime = currentTime
            ball.removeFromParent()
        }
    }
    
}
