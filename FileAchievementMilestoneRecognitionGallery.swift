import UIKit
import SnapKit

class FileAchievementMilestoneRecognitionGallery: UIViewController {

    private var globalScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: "globalScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "globalScore")
            globalScoreLabel.text = "\(newValue)"
        }
    }
    
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
    
    private let cosmicBackdrop: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BG")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let orbitReturnButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "TargetBack"), for: .normal)
        return button
    }()
    
    private let nebulaPortalButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "LevelsSix"), for: .normal)
        return button
    }()
    
    private let celestialMarketButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "FirstTime"), for: .normal)
        return button
    }()
    
    private let astralAchievementButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Scores"), for: .normal)
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
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        globalScoreLabel.text = "\(globalScore)"
        arrangeLayers()
        configureButtonActions()
        checkAchievementsStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        globalScoreLabel.text = "\(globalScore)"
    }

    private func arrangeLayers() {
        view.addSubview(cosmicBackdrop)
        view.addSubview(orbitReturnButton)
        view.addSubview(nebulaPortalButton)
        view.addSubview(celestialMarketButton)
        view.addSubview(astralAchievementButton)
        view.addSubview(scoreBackgroundImageView)
        scoreBackgroundImageView.addSubview(globalScoreLabel)
        
        cosmicBackdrop.snp.makeConstraints { $0.edges.equalToSuperview() }
        orbitReturnButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(55)
        }
        nebulaPortalButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(125)
            make.width.equalToSuperview().multipliedBy(0.525)
            make.height.equalToSuperview().multipliedBy(0.225)
        }
        celestialMarketButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nebulaPortalButton.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.525)
            make.height.equalToSuperview().multipliedBy(0.225)
        }
        astralAchievementButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(celestialMarketButton.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.525)
            make.height.equalToSuperview().multipliedBy(0.225)
        }
        scoreBackgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(55)
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(120)
            make.height.equalTo(35)
        }
        globalScoreLabel.snp.makeConstraints { $0.center.equalToSuperview() }
    }

    private func configureButtonActions() {
        orbitReturnButton.addTarget(self, action: #selector(returnToOrbit), for: .touchUpInside)
        addSound(button: orbitReturnButton)
        nebulaPortalButton.addTarget(self, action: #selector(checkLevelAchievement), for: .touchUpInside)
        addSound(button: nebulaPortalButton)
        celestialMarketButton.addTarget(self, action: #selector(checkFirstTimeAchievement), for: .touchUpInside)
        addSound(button: celestialMarketButton)
        astralAchievementButton.addTarget(self, action: #selector(checkScoreAchievement), for: .touchUpInside)
        addSound(button: astralAchievementButton)
    }

    @objc private func returnToOrbit() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func checkLevelAchievement() {
        let levelsCompleted = mysteriousLevelCompletionStatusArchive.filter { $0 == true }.count
        
        if levelsCompleted >= 6 {
            showAlert(message: "Achievement Unlocked: 6 Levels in Hidery Completed!")
            nebulaPortalButton.alpha = 1.0
        } else {
            showAlert(message: "Achievement Not Unlocked: Complete 6 Levels in Hidery.")
            nebulaPortalButton.alpha = 0.7
        }
    }

    @objc private func checkFirstTimeAchievement() {
        showAlert(message: "Achievement Unlocked: First Time Opening App!")
        celestialMarketButton.alpha = 1.0
    }

    @objc private func checkScoreAchievement() {
        if globalScore >= 1000 {
            showAlert(message: "Achievement Unlocked: 1000 Points Reached!")
            astralAchievementButton.alpha = 1.0
        } else {
            showAlert(message: "Achievement Not Unlocked: Reach 1000 Points.")
            astralAchievementButton.alpha = 0.7
        }
    }

    private func checkAchievementsStatus() {
        let levelsCompleted = mysteriousLevelCompletionStatusArchive.filter { $0 == true }.count
        
        nebulaPortalButton.alpha = levelsCompleted >= 6 ? 1.0 : 0.7

        celestialMarketButton.alpha = 1.0
        
        astralAchievementButton.alpha = globalScore >= 1000 ? 1.0 : 0.7
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
