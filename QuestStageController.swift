import UIKit
import SnapKit

class QuestStageController: UIViewController {
    var initiateMainMenuNavigation: (() -> ())?
    
    var numGame = 1
    
    private var globalScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: "globalScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "globalScore")
            globalScoreLabel.text = "\(newValue)"
        }
    }

    private let cosmicGalaxyBackdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BG")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let orbitReturnToMainButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "TargetBack"), for: .normal)
        return button
    }()
    
    private let levelDisplayHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Levels")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let centralInteractiveAreaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BGExtra")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let actionInitiationButtonUnderImage: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "TargetInstruction"), for: .normal)
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
    
    var levelKey = "levelCompletionStatusArray"
    
    private var levelCompletionStatusArray: [Bool] {
        get {
            if let savedData = UserDefaults.standard.data(forKey: levelKey) {
                if let savedArray = try? JSONDecoder().decode([Bool].self, from: savedData) {
                    return savedArray
                }
            }
            return Array(repeating: false, count: 12)
        }
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedData, forKey: levelKey)
            }
        }
    }

    private var stageLevelButtonsArray: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        levelCompletionStatusArray[0] = true
        layoutInitialSetup()
        configureMainButtonActions()
        refreshLevelButtonAppearances()
        generateAllLevelButtonsForGameStart()
    }

    private func layoutInitialSetup() {
        view.addSubview(cosmicGalaxyBackdropImageView)
        view.addSubview(orbitReturnToMainButton)
        view.addSubview(levelDisplayHeaderImageView)
        view.addSubview(centralInteractiveAreaImageView)
        view.addSubview(actionInitiationButtonUnderImage)
        
        
        globalScoreLabel.text = "\(globalScore)"
        view.addSubview(scoreBackgroundImageView)
        scoreBackgroundImageView.addSubview(globalScoreLabel)

        setBackdropImageViewConstraints()
        setCornerReturnButtonConstraints()
        setTopLevelHeaderImageConstraints()
        setCentralImageConstraints()
        setActionButtonUnderImageConstraints()
        
        setScoreBackgroundImageViewConstraints()
        setScoreLabelConstraints()
    }

    private func setBackdropImageViewConstraints() {
        cosmicGalaxyBackdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setCornerReturnButtonConstraints() {
        orbitReturnToMainButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(55)
        }
    }
    
    private func setTopLevelHeaderImageConstraints() {
        levelDisplayHeaderImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(centralInteractiveAreaImageView.snp.top).offset(-20)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(80)
        }
    }

    private func setCentralImageConstraints() {
        centralInteractiveAreaImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
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

    private func generateAllLevelButtonsForGameStart() {
        let columns = 4
        
        for levelIndex in 0..<12 {
            let specificLevelButton = UIButton(type: .custom)
            specificLevelButton.tag = levelIndex
            specificLevelButton.addTarget(self, action: #selector(levelButtonDidTap), for: .touchUpInside)
            addSound(button: specificLevelButton)
            stageLevelButtonsArray.append(specificLevelButton)
            centralInteractiveAreaImageView.addSubview(specificLevelButton)
            
            specificLevelButton.snp.makeConstraints { make in
                make.width.equalTo(centralInteractiveAreaImageView).multipliedBy(0.175)
                make.height.equalTo(specificLevelButton.snp.width)

                if levelIndex % columns == 0 {
                    make.left.equalTo(centralInteractiveAreaImageView.snp.left).offset(35)
                } else {
                    make.left.equalTo(centralInteractiveAreaImageView.subviews[levelIndex - 1].snp.right).offset(5)
                }

                if levelIndex / columns == 0 {
                    make.top.equalTo(centralInteractiveAreaImageView.snp.top).offset(50)
                } else {
                    make.top.equalTo(centralInteractiveAreaImageView.subviews[levelIndex - columns].snp.bottom).offset(15)
                }
            }

            applyButtonAppearanceBasedOnLevelStatus(specificLevelButton, forIndex: levelIndex)
        }
    }

    private func applyButtonAppearanceBasedOnLevelStatus(_ levelButton: UIButton, forIndex levelIndex: Int) {
        let levelNumber = levelIndex + 1

        if levelCompletionStatusArray[levelIndex] {
            levelButton.setImage(UIImage(named: "Level"), for: .normal)
            let levelNumberLabel = UILabel()
            levelNumberLabel.text = "\(levelNumber)"
            levelNumberLabel.textColor = .white
            levelNumberLabel.textAlignment = .center
            levelNumberLabel.font = UIFont(name: "Questrian", size: 20)
            levelButton.isUserInteractionEnabled = true
            levelButton.addSubview(levelNumberLabel)

            levelNumberLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        } else {
            levelButton.setImage(UIImage(named: "LockedLevel"), for: .normal)
            levelButton.isUserInteractionEnabled = false
        }
    }

    private func setActionButtonUnderImageConstraints() {
        actionInitiationButtonUnderImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(centralInteractiveAreaImageView.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
    }

    private func configureMainButtonActions() {
        orbitReturnToMainButton.addTarget(self, action: #selector(returnToMainOrbitScreen), for: .touchUpInside)
        addSound(button: orbitReturnToMainButton)
        actionInitiationButtonUnderImage.addTarget(self, action: #selector(performActionButtonTapped), for: .touchUpInside)
        addSound(button: actionInitiationButtonUnderImage)
    }

    private func refreshLevelButtonAppearances() {
        for (index, button) in stageLevelButtonsArray.enumerated() {
            if levelCompletionStatusArray[index] {
                button.setImage(UIImage(named: "Level"), for: .normal)
                let levelLabel = UILabel()
                levelLabel.text = "\(index + 1)"
                levelLabel.textColor = .white
                levelLabel.font = UIFont.boldSystemFont(ofSize: 26)
                levelLabel.textAlignment = .center
                button.addSubview(levelLabel)

                levelLabel.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
            } else {
                button.setImage(UIImage(named: "LockedLevel"), for: .normal)
                button.isUserInteractionEnabled = false
            }
        }
    }
    


    @objc private func levelButtonDidTap(_ sender: UIButton) {
        let levelIndex = sender.tag+1
        if numGame == 1 {
            let falsyViewController = FalsyViewController()
            falsyViewController.levelIndex = levelIndex
            falsyViewController.initiateMainMenuNavigation = { [weak self] in
                self?.dismiss(animated: false)
                self?.initiateMainMenuNavigation?()
            }
            falsyViewController.modalTransitionStyle = .crossDissolve
            falsyViewController.modalPresentationStyle = .fullScreen
            self.present(falsyViewController, animated: false, completion: nil)
        } else if numGame == 2 {
            let cardonViewController = CardonViewController()
            cardonViewController.levelIndex = levelIndex
            cardonViewController.initiateMainMenuNavigation = { [weak self] in
                self?.dismiss(animated: false)
                self?.initiateMainMenuNavigation?()
            }
            cardonViewController.modalTransitionStyle = .crossDissolve
            cardonViewController.modalPresentationStyle = .fullScreen
            self.present(cardonViewController, animated: false, completion: nil)
        } else if numGame == 3 {
            let hideryViewController = HideryViewController()
            hideryViewController.levelIndex = levelIndex
            hideryViewController.initiateMainMenuNavigation = { [weak self] in
                self?.dismiss(animated: false)
                self?.initiateMainMenuNavigation?()
            }
            hideryViewController.modalTransitionStyle = .crossDissolve
            hideryViewController.modalPresentationStyle = .fullScreen
            self.present(hideryViewController, animated: false, completion: nil)
        }
    }

    @objc private func returnToMainOrbitScreen() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func performActionButtonTapped() {
        let falsyViewController = IntergalacticDirective()
        falsyViewController.numDiscription = numGame
        falsyViewController.modalTransitionStyle = .crossDissolve
        falsyViewController.modalPresentationStyle = .fullScreen
        self.present(falsyViewController, animated: false, completion: nil)
    }
}
