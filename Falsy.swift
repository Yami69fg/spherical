import SpriteKit
import GameplayKit
import AVFAudio

class Falsy: SKScene, SKPhysicsContactDelegate {
    
    weak var mainFalsyViewController: FalsyViewController?
    private var timerLabel: SKLabelNode!
    private var gameTimer: Timer?
    var timeRemaining = 0
    var constTime = 0
    var playerAudio: AVAudioPlayer?
    private var score = 0
    private var scoringArea: SKSpriteNode!
    private var isGamePaused = false
    
    private var selectedImageName: String {
        get {
            return UserDefaults.standard.string(forKey: "selectedImageName") ?? "BG"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedImageName")
        }
    }
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupTimerLabel()
        setupScoringArea()
        startGameTimer()
        startSpawningBalls()
        physicsWorld.contactDelegate = self
    }
    
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: selectedImageName)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)
    }
    
    private func setupTimerLabel() {
        timerLabel = SKLabelNode(fontNamed: "Questrian")
        timerLabel.text = "\(timeRemaining)"
        timerLabel.fontSize = 40
        timerLabel.fontColor = .white
        timerLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(timerLabel)
    }
    
    private func setupScoringArea() {
        scoringArea = SKSpriteNode(imageNamed: "Rectangle")
        scoringArea.size = CGSize(width: size.width, height: 50)
        scoringArea.position = CGPoint(x: size.width / 2, y: 50)
        scoringArea.name = "ScoringArea"
        scoringArea.physicsBody = SKPhysicsBody(rectangleOf: scoringArea.size)
        scoringArea.physicsBody?.isDynamic = false
        scoringArea.physicsBody?.categoryBitMask = 2
        scoringArea.physicsBody?.contactTestBitMask = 1
        scoringArea.physicsBody?.collisionBitMask = 0
        addChild(scoringArea)
    }
    
    private func startGameTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        guard !isGamePaused else { return }
        timeRemaining -= 1
        timerLabel.text = "\(timeRemaining)"
        if timeRemaining <= 0 {
            gameTimer?.invalidate()
            pauseGame()
            mainFalsyViewController?.goodGame(lose: false,score:score)
        }
    }
    
    private func startSpawningBalls() {
        let spawnAction = SKAction.run { [weak self] in
            self?.spawnRandomBall()
        }
        let waitAction = SKAction.wait(forDuration: 1)
        let spawnSequence = SKAction.sequence([spawnAction, waitAction])
        run(SKAction.repeatForever(spawnSequence))
    }
    
    private func spawnRandomBall() {
        guard !isGamePaused else { return }
        let ballType = Bool.random() ? "RBall" : "GBall"
        let ball = SKSpriteNode(imageNamed: ballType)
        
        let ballSize = CGSize(width: size.width * 0.1, height: size.width * 0.1)
        ball.size = ballSize
        
        let minXPosition = ball.size.width / 2
        let maxXPosition = size.width - ball.size.width / 2
        let randomXPosition = CGFloat.random(in: minXPosition...maxXPosition)

        ball.position = CGPoint(x: randomXPosition, y: size.height + ball.size.height / 2)
        ball.name = ballType
        ball.zPosition = 1
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: -400)
        ball.physicsBody?.categoryBitMask = 1
        ball.physicsBody?.contactTestBitMask = 2
        addChild(ball)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isGamePaused, let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if node.name == "RBall" {
                if  UserDefaults.standard.bool(forKey: "audioEnabled") {
                    guard let url = Bundle.main.url(forResource: "ball", withExtension: "wav") else {
                        return
                    }
                    do {
                        playerAudio = try AVAudioPlayer(contentsOf: url)
                        playerAudio?.play()
                    } catch {
                    }
                }
                node.removeFromParent()
            } else if node.name == "GBall" {
                if  UserDefaults.standard.bool(forKey: "audioEnabled") {
                    guard let url = Bundle.main.url(forResource: "ball", withExtension: "wav") else {
                        return
                    }
                    do {
                        playerAudio = try AVAudioPlayer(contentsOf: url)
                        playerAudio?.play()
                    } catch {
                    }
                }
                node.removeFromParent()
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard !isGamePaused else { return }
        
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if (nodeA?.name == "ScoringArea" && (nodeB?.name == "RBall" || nodeB?.name == "GBall")) {
            nodeB?.removeFromParent()
            if nodeB?.name == "GBall" {
                score += 1
                if  UserDefaults.standard.bool(forKey: "audioEnabled") {
                    guard let url = Bundle.main.url(forResource: "ball", withExtension: "wav") else {
                        return
                    }
                    do {
                        playerAudio = try AVAudioPlayer(contentsOf: url)
                        playerAudio?.play()
                    } catch {
                    }
                }
                mainFalsyViewController?.addOne()
            } else if nodeB?.name == "RBall" {
                pauseGame()
                if  UserDefaults.standard.bool(forKey: "audioEnabled") {
                    guard let url = Bundle.main.url(forResource: "ball", withExtension: "wav") else {
                        return
                    }
                    do {
                        playerAudio = try AVAudioPlayer(contentsOf: url)
                        playerAudio?.play()
                    } catch {
                    }
                }
                mainFalsyViewController?.goodGame(lose: true,score:score)
            }
        } else if (nodeB?.name == "ScoringArea" && (nodeA?.name == "RBall" || nodeA?.name == "GBall")) {
            nodeA?.removeFromParent()
            if nodeA?.name == "GBall" {
                score += 1
                mainFalsyViewController?.addOne()
            } else if nodeA?.name == "RBall" {
                pauseGame()
                mainFalsyViewController?.goodGame(lose: true,score:score)
            }
        }
    }

    
    func pauseGame() {
        isGamePaused = true
        gameTimer?.invalidate()
        scene?.isPaused = true
    }
    
    func resumeGame() {
        isGamePaused = false
        scene?.isPaused = false
        startGameTimer()
    }
    
    func restartGame() {
        for node in children {
            if node.name == "RBall" || node.name == "GBall" {
                node.removeFromParent()
            }
        }
        isGamePaused = false
        timeRemaining = constTime
        score = 0
        timerLabel.text = "\(timeRemaining)"
        scene?.isPaused = false
        startGameTimer()
    }
}
