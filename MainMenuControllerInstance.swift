import UIKit
import SnapKit

class MainMenuControllerInstance: UIViewController {
    
    private var globalScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: "globalScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "globalScore")
        }
    }

    private let backgroundImageContainer: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BG")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let mainImageForTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Star")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let firstButtonOption: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "TargetGame"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()

    private let secondButtonOption: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "TargetStore"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()

    private let thirdButtonOption: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "TargetAchievements"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()

    private var timer: Timer?
    private var remainingTime: TimeInterval = 3600
    private let timerLabel = UILabel()
    private let rewardButton = UIButton(type: .custom)

    private let timerStartKey = "timerStartTime"
    private let timerDuration: TimeInterval = 3600

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainInterfaceLayout()
        setupButtonActions()
        configureTimerLabel()
        configureRewardButton()
        loadSavedTimerState()
        startTimer()
    }

    private func configureMainInterfaceLayout() {
        addBackgroundToView()
        addTitleImageToView()
        addButtonsToView()
        applyConstraintsToBackground()
        applyConstraintsToTitleImage()
        applyConstraintsToButtons()
    }

    private func addBackgroundToView() {
        view.addSubview(backgroundImageContainer)
    }

    private func addTitleImageToView() {
        view.addSubview(mainImageForTitle)
    }

    private func addButtonsToView() {
        view.addSubview(firstButtonOption)
        view.addSubview(secondButtonOption)
        view.addSubview(thirdButtonOption)
    }

    private func applyConstraintsToBackground() {
        backgroundImageContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func applyConstraintsToTitleImage() {
        mainImageForTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(150)
            make.width.equalTo(350)
            make.height.equalTo(200)
        }
    }

    private func applyConstraintsToButtons() {
        firstButtonOption.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainImageForTitle.snp.bottom).offset(50)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        
        secondButtonOption.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(firstButtonOption.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        
        thirdButtonOption.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(secondButtonOption.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
    }

    private func setupButtonActions() {
        firstButtonOption.addTarget(self, action: #selector(handleFirstButtonAction), for: .touchUpInside)
        addSound(button: firstButtonOption)
        secondButtonOption.addTarget(self, action: #selector(handleSecondButtonAction), for: .touchUpInside)
        addSound(button: secondButtonOption)
        thirdButtonOption.addTarget(self, action: #selector(handleThirdButtonAction), for: .touchUpInside)
        addSound(button: thirdButtonOption)
        rewardButton.addTarget(self, action: #selector(rewardButtonTapped), for: .touchUpInside)
        addSound(button: rewardButton)
    }

    @objc private func handleFirstButtonAction() {
        let multiDimensionalGameAndAdventureLibrary = MultiDimensionalGameAndAdventureLibrary()
        multiDimensionalGameAndAdventureLibrary.modalTransitionStyle = .crossDissolve
        multiDimensionalGameAndAdventureLibrary.modalPresentationStyle = .fullScreen
        self.present(multiDimensionalGameAndAdventureLibrary, animated: false, completion: nil)
    }

    @objc private func handleSecondButtonAction() {
        let marketplaceOfVirtualEnhancementsAndUpgrades = MarketplaceOfVirtualEnhancementsAndUpgrades()
        marketplaceOfVirtualEnhancementsAndUpgrades.modalTransitionStyle = .crossDissolve
        marketplaceOfVirtualEnhancementsAndUpgrades.modalPresentationStyle = .fullScreen
        self.present(marketplaceOfVirtualEnhancementsAndUpgrades, animated: false, completion: nil)
    }

    @objc private func handleThirdButtonAction() {
        let achievementMilestoneRecognitionGallery = FileAchievementMilestoneRecognitionGallery()
        achievementMilestoneRecognitionGallery.modalTransitionStyle = .crossDissolve
        achievementMilestoneRecognitionGallery.modalPresentationStyle = .fullScreen
        self.present(achievementMilestoneRecognitionGallery, animated: false, completion: nil)
    }

    private func configureTimerLabel() {
        timerLabel.text = formatTime(remainingTime)
        timerLabel.font = UIFont(name: "Questrian", size: 18)
        timerLabel.textColor = .white
        timerLabel.textAlignment = .center
        
        rewardButton.addSubview(timerLabel)
        
        timerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func configureRewardButton() {
        rewardButton.setImage(UIImage(named: "BGTimer"), for: .normal)
        rewardButton.isEnabled = false
        
        view.addSubview(rewardButton)
        
        rewardButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(55)
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(175)
            make.height.equalTo(50)
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc private func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            timerLabel.text = formatTime(remainingTime)
            saveTimerState()
        } else {
            timer?.invalidate()
            timerLabel.text = "00:00:00"
            unlockRewardButton()
        }
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    private func unlockRewardButton() {
        rewardButton.isEnabled = true
    }

    private func loadSavedTimerState() {
        let timerStartTime = UserDefaults.standard.double(forKey: timerStartKey)
        if timerStartTime == 0 {
            remainingTime = timerDuration
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: timerStartKey)
        } else {
            let elapsedTime = Date().timeIntervalSince1970 - timerStartTime
            if elapsedTime >= timerDuration {
                remainingTime = 0
                unlockRewardButton()
            } else {
                remainingTime = timerDuration - elapsedTime
            }
        }
        
        timerLabel.text = formatTime(remainingTime)
        if remainingTime > 0 {
            rewardButton.isEnabled = false
        }
    }

    private func saveTimerState() {
        UserDefaults.standard.set(remainingTime, forKey: "remainingTime")
    }

    @objc private func rewardButtonTapped() {
        remainingTime = timerDuration
        timerLabel.text = formatTime(remainingTime)
        globalScore += 25
        rewardButton.isEnabled = false
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: timerStartKey)
        startTimer()
    }
}
