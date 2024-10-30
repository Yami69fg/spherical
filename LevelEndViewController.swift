import UIKit
import SnapKit

class LevelEndViewController: UIViewController {
    
    var initiateMainMenuNavigation: (() -> ())?
    var isLose = false
    var score = 0
    var restartGameplaySession: (() -> ())?
    
    private let imageViewBackgroundBlurEffect: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "Blur")
        backgroundImageView.contentMode = .scaleAspectFill
        return backgroundImageView
    }()
    
    private let imageViewBackgroundDetails: UIImageView = {
        let detailedBackgroundImageView = UIImageView()
        detailedBackgroundImageView.image = UIImage(named: "BGExtra")
        return detailedBackgroundImageView
    }()
    
    let imageViewSettingsHeaderLabel: UIImageView = {
        let settingsHeaderImageView = UIImageView()
        settingsHeaderImageView.image = UIImage(named: "TheWin")
        return settingsHeaderImageView
    }()
    
    private let labelTitleForSoundSettings: UILabel = {
        let soundSettingsTitleLabel = UILabel()
        soundSettingsTitleLabel.text = "Score"
        soundSettingsTitleLabel.textColor = .white
        soundSettingsTitleLabel.font = UIFont(name: "Questrian", size: 32)
        soundSettingsTitleLabel.textAlignment = .center
        return soundSettingsTitleLabel
    }()
    
    let labelTitleForVibrationSettings: UILabel = {
        let vibrationSettingsTitleLabel = UILabel()
        vibrationSettingsTitleLabel.text = "Total score"
        vibrationSettingsTitleLabel.textColor = .white
        vibrationSettingsTitleLabel.font = UIFont(name: "Questrian", size: 28)
        vibrationSettingsTitleLabel.textAlignment = .center
        return vibrationSettingsTitleLabel
    }()
    
    private let buttonMainMenuNavigation: UIButton = {
        let mainMenuNavigationButton = UIButton()
        mainMenuNavigationButton.setImage(UIImage(named: "TargetMenu"), for: .normal)
        return mainMenuNavigationButton
    }()
    
    private let buttonReturnToGameplay: UIButton = {
        let returnToGameplayButton = UIButton()
        returnToGameplayButton.setImage(UIImage(named: "TargetReset"), for: .normal)
        return returnToGameplayButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserInterfaceLayout()
    }
    
    private func configureUserInterfaceLayout() {
        addInterfaceElementsToViewHierarchy()
        applyImageViewConstraints()
        applyLabelConstraints()
        applyButtonConstraints()
    }
    
    private func addInterfaceElementsToViewHierarchy() {
        view.addSubview(imageViewBackgroundBlurEffect)
        view.addSubview(imageViewBackgroundDetails)
        view.addSubview(imageViewSettingsHeaderLabel)
        view.addSubview(labelTitleForSoundSettings)
        view.addSubview(labelTitleForVibrationSettings)
        view.addSubview(buttonMainMenuNavigation)
        view.addSubview(buttonReturnToGameplay)
        
        if isLose {
            imageViewSettingsHeaderLabel.image = UIImage(named: "TheLose")
        }
        
        labelTitleForSoundSettings.text = "Score \(score)"
        labelTitleForVibrationSettings.text = "Total score \(UserDefaults.standard.integer(forKey: "globalScore"))"
        
        buttonMainMenuNavigation.addTarget(self, action: #selector(activateMainMenuNavigation), for: .touchUpInside)
        addSound(button: buttonMainMenuNavigation)
        buttonReturnToGameplay.addTarget(self, action: #selector(restartGameplay), for: .touchUpInside)
        addSound(button: buttonReturnToGameplay)
    }
    
    private func applyImageViewConstraints() {
        imageViewBackgroundBlurEffect.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageViewBackgroundDetails.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        
        imageViewSettingsHeaderLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageViewBackgroundDetails.snp.top).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(250)
        }
    }
    
    private func applyLabelConstraints() {
        labelTitleForSoundSettings.snp.makeConstraints { make in
            make.left.equalTo(imageViewBackgroundDetails.snp.left).offset(50)
            make.centerY.equalToSuperview().offset(-30)
        }
        
        labelTitleForVibrationSettings.snp.makeConstraints { make in
            make.left.equalTo(imageViewBackgroundDetails.snp.left).offset(30)
            make.centerY.equalToSuperview().offset(30)
        }
    }
    
    private func applyButtonConstraints() {
    
        buttonMainMenuNavigation.snp.makeConstraints { make in
            make.top.equalTo(imageViewBackgroundDetails.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(50)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        buttonReturnToGameplay.snp.makeConstraints { make in
            make.top.equalTo(imageViewBackgroundDetails.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-50)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }
    
    @objc private func activateMainMenuNavigation() {
        dismiss(animated: false)
        initiateMainMenuNavigation?()
    }
    
    @objc private func restartGameplay() {
        dismiss(animated: true, completion: nil)
        restartGameplaySession?()
    }
}

