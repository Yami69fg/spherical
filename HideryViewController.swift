import UIKit
import SnapKit
import SpriteKit
import GameplayKit
import AVFAudio

class HideryViewController: UIViewController {
    
    var levelIndex = 0
    var timeSequenceForChallengeArray = [3,4,5,6,7,8,9,10,11,12,13,14]
    
    private var selectedImageName: String {
        get {
            return UserDefaults.standard.string(forKey: "selectedImageName") ?? "BG"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedImageName")
        }
    }
    
    var initiateMainMenuNavigation: (() -> ())?
    var score = 0
    
    private var universalScoreForGameplay: Int {
        get {
            return UserDefaults.standard.integer(forKey: "globalScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "globalScore")
            globalScoreLabel.text = "\(newValue)"
        }
    }
    
    var playerAudio: AVAudioPlayer?
    
    private var mysteriousLevelCompletionStatusArchive: [Bool] {
        get {
            if let preservedData = UserDefaults.standard.data(forKey: "levelCompletionStatusArray3") {
                if let decodedArchive = try? JSONDecoder().decode([Bool].self, from: preservedData) {
                    return decodedArchive
                }
            }
            return Array(repeating: false, count: 12)
        }
        set {
            if let encodedArchive = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedArchive, forKey: "levelCompletionStatusArray3")
            }
        }
    }
    
    private let enigmaticCosmicGalaxyBackdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BG")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let arcaneSettingsTargetButtonForMenu: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "TargetSettings"), for: .normal)
        return button
    }()
    
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
        label.text = "0"
        return label
    }()
    
    private let gridSize: Int = 5
    private var buttons: [[UIButton]] = []
    private var imageStatusArray: [[String]] = Array(repeating: Array(repeating: "GCell", count: 5), count: 5)
    private var flippedStates: [[Bool]] = Array(repeating: Array(repeating: false, count: 5), count: 5)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        enigmaticCosmicGalaxyBackdropImageView.layer.zPosition = -1
        enigmaticCosmicGalaxyBackdropImageView.image = UIImage(named: selectedImageName)
        globalScoreLabel.text = "\(universalScoreForGameplay)"
        view.addSubview(scoreBackgroundImageView)
        scoreBackgroundImageView.addSubview(globalScoreLabel)
        
        elaborateUIArrangement()
        configureSettingsButtonForMenu()
        setScoreBackgroundImageViewConstraints()
        setScoreLabelConstraints()
        
        createGrid()
        randomizeCells()
    }
    
    private func elaborateUIArrangement() {
        view.addSubview(enigmaticCosmicGalaxyBackdropImageView)
        establishBackdropConstraints()
    }
    
    private func setScoreBackgroundImageViewConstraints() {
        scoreBackgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(55)
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(120)
            make.height.equalTo(35)
        }
    }

    private func setScoreLabelConstraints() {
        globalScoreLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func establishBackdropConstraints() {
        enigmaticCosmicGalaxyBackdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureSettingsButtonForMenu() {
        view.addSubview(arcaneSettingsTargetButtonForMenu)
        arcaneSettingsTargetButtonForMenu.layer.zPosition = 5

        arcaneSettingsTargetButtonForMenu.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(55)
            make.height.width.equalTo(55)
        }
        
        arcaneSettingsTargetButtonForMenu.addTarget(self, action: #selector(activateControlPanel), for: .touchUpInside)
        addSound(button: arcaneSettingsTargetButtonForMenu)
    }
    
    @objc func activateControlPanel() {
        let controlPanelController = ControlPanelController()
        controlPanelController.initiateMainMenuNavigation = { [weak self] in
            self?.dismiss(animated: false)
            self?.initiateMainMenuNavigation?()
        }
        controlPanelController.modalPresentationStyle = .overCurrentContext
        self.present(controlPanelController, animated: false, completion: nil)
    }
    
    private func createGrid() {
        let buttonWidth: CGFloat = 60
        let buttonHeight: CGFloat = 60
        let spacing: CGFloat = 10
        
        for row in 0..<gridSize {
            var buttonRow: [UIButton] = []
            for col in 0..<gridSize {
                let button = UIButton(type: .custom)
                button.tag = row * gridSize + col
                button.setImage(UIImage(named: "Level"), for: .normal)
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                
                buttonRow.append(button)
                view.addSubview(button)
                
                button.snp.makeConstraints { make in
                    make.width.height.equalTo(buttonWidth)
                    make.top.equalToSuperview().offset(200 + CGFloat(row) * (buttonHeight + spacing))
                    make.left.equalToSuperview().offset(20 + CGFloat(col) * (buttonWidth + spacing))
                }
            }
            buttons.append(buttonRow)
        }
    }
    
    private func randomizeCells() {
        var randomIndices = Set<Int>()

        while randomIndices.count < timeSequenceForChallengeArray[levelIndex-1] {
            let randomIndex = Int.random(in: 0..<gridSize * gridSize)
            randomIndices.insert(randomIndex)
        }

        for index in randomIndices {
            let row = index / gridSize
            let col = index % gridSize
            
            imageStatusArray[row][col] = "RCell"
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "audioEnabled") {
            guard let url = Bundle.main.url(forResource: "card", withExtension: "mp3") else {
                return
            }
            do {
                playerAudio = try AVAudioPlayer(contentsOf: url)
                playerAudio?.play()
            } catch {
            }
        }
        let row = sender.tag / gridSize
        let col = sender.tag % gridSize
        
        if !flippedStates[row][col] {
            let currentImageStatus = imageStatusArray[row][col]
            if currentImageStatus == "GCell" {
                universalScoreForGameplay += 1
                score += 1
                globalScoreLabel.text = "\(universalScoreForGameplay)"
                imageStatusArray[row][col] = "GCell"
                flippedStates[row][col] = true
                
                UIView.transition(with: sender, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                    sender.setImage(UIImage(named: "GCell"), for: .normal)
                }, completion: nil)
            } else if currentImageStatus == "RCell" {
                flipAllButtons()
                UIView.transition(with: sender, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                    sender.setImage(UIImage(named: "RCell"), for: .normal)
                }, completion: nil)
                if score >= 5 {
                    goodGame(lose: false,score: score)
                }
                goodGame(lose: true,score: score)
            }
        }
    }
    
    func goodGame(lose: Bool,score: Int) {
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            let levelEndViewController = LevelEndViewController()
            levelEndViewController.isLose = lose
            levelEndViewController.score = score
            if !lose {
                self.markLevelAsCompleted(levelIndex: self.levelIndex)
            }
            levelEndViewController.initiateMainMenuNavigation = { [weak self] in
                self?.dismiss(animated: false)
                self?.initiateMainMenuNavigation?()
            }
            levelEndViewController.restartGameplaySession = { [weak self] in
                self?.score = 0
                self?.removeButtons()
                self?.resetGameState()
                self?.createGrid()
                self?.randomizeCells()
            }
            levelEndViewController.modalPresentationStyle = .overCurrentContext
            self.present(levelEndViewController, animated: false, completion: nil)
        }
    }
    
    func markLevelAsCompleted(levelIndex: Int) {
        guard levelIndex >= 0 && levelIndex < mysteriousLevelCompletionStatusArchive.count else { return }
        mysteriousLevelCompletionStatusArchive[levelIndex] = true
    }
    
    private func removeButtons() {
        for row in buttons {
            for button in row {
                button.removeFromSuperview()
            }
        }
        buttons.removeAll()
    }
    
    private func resetGameState() {
        imageStatusArray = Array(repeating: Array(repeating: "GCell", count: 5), count: 5)
        flippedStates = Array(repeating: Array(repeating: false, count: 5), count: 5)
        score = 0
        globalScoreLabel.text = "\(universalScoreForGameplay)"
    }
    
    private func flipAllButtons() {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                flippedStates[row][col] = true
            }
        }
    }
}
