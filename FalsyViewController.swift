import UIKit
import SpriteKit
import GameplayKit
import AVFAudio


class FalsyViewController: UIViewController {
    
    weak var falsyGame: Falsy?
    
    var levelIndex = 0
    
    var arrayTimer = [5,10,15,20,25,30,35,40,45,50,55,60]
    
    private var levelCompletionStatusArray: [Bool] {
        get {
            if let savedData = UserDefaults.standard.data(forKey: "levelCompletionStatusArray") {
                if let savedArray = try? JSONDecoder().decode([Bool].self, from: savedData) {
                    return savedArray
                }
            }
            return Array(repeating: false, count: 12)
        }
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedData, forKey: "levelCompletionStatusArray")
            }
        }
    }
    
    private let targetSettingsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "TargetSettings"), for: .normal)
        return button
    }()
    
    private var globalScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: "globalScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "globalScore")
            globalScoreLabel.text = "\(newValue)"
        }
    }
    
    private let scoreBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BGScore")
        return imageView
    }()
    
    private let globalScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Questrian", size: 20)
        return label
    }()
    
    var initiateMainMenuNavigation: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = SKView(frame: view.frame)
        
        if let view = self.view as? SKView {
            let openFalsyViewController = Falsy(size: view.bounds.size)
            self.falsyGame = openFalsyViewController
            openFalsyViewController.constTime = arrayTimer[levelIndex-1]
            openFalsyViewController.timeRemaining = arrayTimer[levelIndex-1]
            openFalsyViewController.mainFalsyViewController = self
            openFalsyViewController.scaleMode = .aspectFill
            view.presentScene(openFalsyViewController)
        }
        
        globalScoreLabel.text = "\(globalScore)"
        setSettingsButton()
        setupScoreDisplay()
    }
    
    func setSettingsButton() {
        view.addSubview(targetSettingsButton)
        targetSettingsButton.layer.zPosition = 5

        targetSettingsButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(55)
            make.height.width.equalTo(55)
        }
        
        targetSettingsButton.addTarget(self, action: #selector(openControlPanelController), for: .touchUpInside)
        addSound(button: targetSettingsButton)
    }
    
    private func setupScoreDisplay() {
        view.addSubview(scoreBackgroundImageView)
        scoreBackgroundImageView.addSubview(globalScoreLabel)
        
        scoreBackgroundImageView.layer.zPosition = 5
        globalScoreLabel.layer.zPosition = 6
        
        scoreBackgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(55)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(120)
            make.height.equalTo(35)
        }
        
        globalScoreLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    @objc func openControlPanelController() {
        let controlPanelController = ControlPanelController()
        falsyGame?.pauseGame()
        controlPanelController.initiateMainMenuNavigation = { [weak self] in
            self?.dismiss(animated: false)
            self?.initiateMainMenuNavigation?()
        }
        controlPanelController.resumeGameplaySession = { [weak self] in
            self?.falsyGame?.resumeGame()
        }
        controlPanelController.modalPresentationStyle = .overCurrentContext
        self.present(controlPanelController, animated: false, completion: nil)
    }
    
    func goodGame(lose: Bool,score: Int) {
        theEndAudio()
        let levelEndViewController = LevelEndViewController()
        levelEndViewController.isLose = lose
        levelEndViewController.score = score
        if !lose {
            markLevelAsCompleted(levelIndex: levelIndex)
        }
        falsyGame?.pauseGame()
        levelEndViewController.initiateMainMenuNavigation = { [weak self] in
            self?.dismiss(animated: false)
            self?.initiateMainMenuNavigation?()
        }
        levelEndViewController.restartGameplaySession = { [weak self] in
            self?.falsyGame?.restartGame()
        }
        levelEndViewController.modalPresentationStyle = .overCurrentContext
        self.present(levelEndViewController, animated: false, completion: nil)
    }
    
    func addOne(){
        globalScore+=1
        globalScoreLabel.text = "\(globalScore)"
    }
    
    func markLevelAsCompleted(levelIndex: Int) {
        guard levelIndex >= 0 && levelIndex < levelCompletionStatusArray.count else { return }
        levelCompletionStatusArray[levelIndex] = true
    }
    
    func theEndAudio() {
        if UserDefaults.standard.bool(forKey: "audioEnabled") {
            guard let url = Bundle.main.url(forResource: "theEnd", withExtension: "mp3") else {
                return
            }
            do {
                playerAudio = try AVAudioPlayer(contentsOf: url)
                playerAudio?.play()
            } catch {
            }
        }
    }
    
    var playerAudio: AVAudioPlayer?
}
