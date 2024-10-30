import UIKit
import SnapKit
import SpriteKit
import GameplayKit
import AVFAudio

class CardonViewController: UIViewController {
    
    var levelIndex = 0
    var timeSequenceForChallengeArray = [1,2,3,4,5,6,7,8,8,9,9,10]
    var initiateMainMenuNavigation: (() -> ())?
    
    private var selectedImageName: String {
        get {
            return UserDefaults.standard.string(forKey: "selectedImageName") ?? "BG"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedImageName")
        }
    }
    
    var playerAudio: AVAudioPlayer?
    
    private var enigmaticSelectedColorByUser: String?
    private var consecutiveCorrectGuessesCount = 0
    
    private var mysteriousLevelCompletionStatusArchive: [Bool] {
        get {
            if let preservedData = UserDefaults.standard.data(forKey: "levelCompletionStatusArray2") {
                if let decodedArchive = try? JSONDecoder().decode([Bool].self, from: preservedData) {
                    return decodedArchive
                }
            }
            return Array(repeating: false, count: 12)
        }
        set {
            if let encodedArchive = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedArchive, forKey: "levelCompletionStatusArray2")
            }
        }
    }
    
    private var universalScoreForGameplay: Int {
        get {
            return UserDefaults.standard.integer(forKey: "globalScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "globalScore")
            cosmicScoreDisplayLabel.text = "\(newValue)"
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
    
    private let obscureScoreBackgroundIllustrationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BGScore")
        return imageView
    }()
    
    private let cosmicScoreDisplayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Questrian", size: 20)
        return label
    }()
    
    private let pivotalActionCenterImageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Card"), for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    private let mysticPurpleColorSelectionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "PurpleButton"), for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    private let enigmaticBlueColorSelectionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "BlueButton"), for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    private let elusiveOutcomeDisplayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Questrian", size: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Choose Color"
        return label
    }()
    
    private let streakDisplayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Questrian", size: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Streak: 0"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cosmicScoreDisplayLabel.text = "\(universalScoreForGameplay)"
        enigmaticCosmicGalaxyBackdropImageView.image = UIImage(named: selectedImageName)
        elaborateUIArrangement()
        configureSettingsButtonForMenu()
        setupCosmicScoreDisplay()
    }
    
    private func elaborateUIArrangement() {
        view.addSubview(enigmaticCosmicGalaxyBackdropImageView)
        view.addSubview(streakDisplayLabel)
        view.addSubview(pivotalActionCenterImageButton)
        view.addSubview(mysticPurpleColorSelectionButton)
        view.addSubview(enigmaticBlueColorSelectionButton)
        view.addSubview(elusiveOutcomeDisplayLabel)
        
        pivotalActionCenterImageButton.addTarget(self, action: #selector(pivotalActionCenterButtonActivated), for: .touchUpInside)
        mysticPurpleColorSelectionButton.addTarget(self, action: #selector(mysticPurpleButtonActivated), for: .touchUpInside)
        addSound(button: mysticPurpleColorSelectionButton)
        enigmaticBlueColorSelectionButton.addTarget(self, action: #selector(enigmaticBlueButtonActivated), for: .touchUpInside)
        addSound(button: enigmaticBlueColorSelectionButton)
        
        establishBackdropConstraints()
        
        streakDisplayLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pivotalActionCenterImageButton.snp.top).offset(-10)
        }
        
        pivotalActionCenterImageButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        mysticPurpleColorSelectionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-60)
            make.top.equalTo(pivotalActionCenterImageButton.snp.bottom).offset(20)
            make.width.height.equalTo(50)
        }
        
        enigmaticBlueColorSelectionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(60)
            make.top.equalTo(pivotalActionCenterImageButton.snp.bottom).offset(20)
            make.width.height.equalTo(50)
        }
        
        elusiveOutcomeDisplayLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(enigmaticBlueColorSelectionButton.snp.bottom).offset(20)
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
    
    private func setupCosmicScoreDisplay() {
        view.addSubview(obscureScoreBackgroundIllustrationImageView)
        obscureScoreBackgroundIllustrationImageView.addSubview(cosmicScoreDisplayLabel)
        
        obscureScoreBackgroundIllustrationImageView.layer.zPosition = 5
        cosmicScoreDisplayLabel.layer.zPosition = 6
        
        obscureScoreBackgroundIllustrationImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(55)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(120)
            make.height.equalTo(35)
        }
        
        cosmicScoreDisplayLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
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
    
    @objc private func mysticPurpleButtonActivated() {
        enigmaticSelectedColorByUser = "Purple"
        mysticPurpleColorSelectionButton.alpha = 0.6
        enigmaticBlueColorSelectionButton.alpha = 1.0
    }
    
    @objc private func enigmaticBlueButtonActivated() {
        enigmaticSelectedColorByUser = "Blue"
        enigmaticBlueColorSelectionButton.alpha = 0.6
        mysticPurpleColorSelectionButton.alpha = 1.0
    }
    
    @objc private func pivotalActionCenterButtonActivated() {
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
        guard let enigmaticSelectedColorByUser = enigmaticSelectedColorByUser else {
            displaySelectionAlert()
            return
        }
        
        let randomResultColor = Bool.random() ? "Blue" : "Purple"
        elusiveOutcomeDisplayLabel.text = "Result: \(randomResultColor)"
        
        UIView.transition(with: pivotalActionCenterImageButton, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            if randomResultColor == "Blue" {
                self.pivotalActionCenterImageButton.setImage(UIImage(named: "BlueIcon"), for: .normal)
            } else {
                self.pivotalActionCenterImageButton.setImage(UIImage(named: "PurpleIcon"), for: .normal)
            }
        })
        
        if enigmaticSelectedColorByUser == randomResultColor {
            elusiveOutcomeDisplayLabel.text = "Correct! +5 points"
            universalScoreForGameplay += 5
            cosmicScoreDisplayLabel.text = "\(universalScoreForGameplay)"
            consecutiveCorrectGuessesCount += 1
            if consecutiveCorrectGuessesCount >= timeSequenceForChallengeArray[levelIndex-1] {
                goodGame(lose: false, score: consecutiveCorrectGuessesCount*5)
                consecutiveCorrectGuessesCount = 0
            }
        } else {
            goodGame(lose: true, score: consecutiveCorrectGuessesCount*5)
            consecutiveCorrectGuessesCount = 0
        }
        
        streakDisplayLabel.text = "Streak: \(consecutiveCorrectGuessesCount)"
    }
    
    private func displaySelectionAlert() {
        let alert = UIAlertController(title: "Color Not Selected", message: "Please choose a color before guessing.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
                self?.consecutiveCorrectGuessesCount = 0
                self?.streakDisplayLabel.text = "Streak: \(0)"
                self?.pivotalActionCenterImageButton.setImage(UIImage(named: "Card"), for: .normal)
            }
            levelEndViewController.modalPresentationStyle = .overCurrentContext
            self.present(levelEndViewController, animated: false, completion: nil)
        }
    }
    
    func markLevelAsCompleted(levelIndex: Int) {
        guard levelIndex >= 0 && levelIndex < mysteriousLevelCompletionStatusArchive.count else { return }
        mysteriousLevelCompletionStatusArchive[levelIndex] = true
    }
}
