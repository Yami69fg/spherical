import UIKit
import SnapKit

class ControlPanelController: UIViewController {
    
    var initiateMainMenuNavigation: (() -> ())?
    var resumeGameplaySession: (() -> ())?
    
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
    
    private let imageViewSettingsHeaderLabel: UIImageView = {
        let settingsHeaderImageView = UIImageView()
        settingsHeaderImageView.image = UIImage(named: "Settings")
        return settingsHeaderImageView
    }()
    
    private let labelTitleForSoundSettings: UILabel = {
        let soundSettingsTitleLabel = UILabel()
        soundSettingsTitleLabel.text = "Sound"
        soundSettingsTitleLabel.textColor = .white
        soundSettingsTitleLabel.font = UIFont(name: "Questrian", size: 32)
        soundSettingsTitleLabel.textAlignment = .center
        return soundSettingsTitleLabel
    }()
    
    private let buttonSoundToggleSwitch: UIButton = {
        let soundToggleSwitchButton = UIButton()
        soundToggleSwitchButton.translatesAutoresizingMaskIntoConstraints = false
        return soundToggleSwitchButton
    }()
    
    private let labelTitleForVibrationSettings: UILabel = {
        let vibrationSettingsTitleLabel = UILabel()
        vibrationSettingsTitleLabel.text = "Vibration"
        vibrationSettingsTitleLabel.textColor = .white
        vibrationSettingsTitleLabel.font = UIFont(name: "Questrian", size: 32)
        vibrationSettingsTitleLabel.textAlignment = .center
        return vibrationSettingsTitleLabel
    }()
    
    private let buttonVibrationToggleSwitch: UIButton = {
        let vibrationToggleSwitchButton = UIButton()
        vibrationToggleSwitchButton.translatesAutoresizingMaskIntoConstraints = false
        return vibrationToggleSwitchButton
    }()
    
    private let buttonMainMenuNavigation: UIButton = {
        let mainMenuNavigationButton = UIButton()
        mainMenuNavigationButton.setImage(UIImage(named: "TargetMenu"), for: .normal)
        return mainMenuNavigationButton
    }()
    
    private let buttonReturnToGameplay: UIButton = {
        let returnToGameplayButton = UIButton()
        returnToGameplayButton.setImage(UIImage(named: "TargetDiss"), for: .normal)
        return returnToGameplayButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserInterfaceLayout()
        applyDefaultSettingsForUser()
        configureToggleButtonStatesFromSavedSettings()
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
        view.addSubview(buttonSoundToggleSwitch)
        view.addSubview(labelTitleForVibrationSettings)
        view.addSubview(buttonVibrationToggleSwitch)
        view.addSubview(buttonMainMenuNavigation)
        view.addSubview(buttonReturnToGameplay)
        
        buttonMainMenuNavigation.addTarget(self, action: #selector(activateMainMenuNavigation), for: .touchUpInside)
        addSound(button: buttonMainMenuNavigation)
        buttonReturnToGameplay.addTarget(self, action: #selector(resumeGameplay), for: .touchUpInside)
        addSound(button: buttonReturnToGameplay)
        buttonSoundToggleSwitch.addTarget(self, action: #selector(toggleSoundPreferenceSetting), for: .touchUpInside)
        addSound(button: buttonSoundToggleSwitch)
        buttonVibrationToggleSwitch.addTarget(self, action: #selector(toggleVibrationPreferenceSetting), for: .touchUpInside)
        addSound(button: buttonVibrationToggleSwitch)
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
            make.height.equalTo(100)
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
        buttonSoundToggleSwitch.snp.makeConstraints { make in
            make.left.equalTo(labelTitleForSoundSettings.snp.right).offset(20)
            make.centerY.equalToSuperview().offset(-30)
            make.width.equalTo(60)
            make.height.equalTo(35)
        }
        
        buttonVibrationToggleSwitch.snp.makeConstraints { make in
            make.left.equalTo(labelTitleForVibrationSettings.snp.right).offset(20)
            make.centerY.equalToSuperview().offset(30)
            make.width.equalTo(60)
            make.height.equalTo(35)
        }
        
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
    
    private func applyDefaultSettingsForUser() {
        if UserDefaults.standard.object(forKey: "audioEnabled") == nil {
            UserDefaults.standard.set(true, forKey: "audioEnabled")
        }
        if UserDefaults.standard.object(forKey: "vibrationEnabled") == nil {
            UserDefaults.standard.set(true, forKey: "vibrationEnabled")
        }
    }
    
    private func configureToggleButtonStatesFromSavedSettings() {
        let audioSettingEnabled = UserDefaults.standard.bool(forKey: "audioEnabled")
        let vibrationSettingEnabled = UserDefaults.standard.bool(forKey: "vibrationEnabled")
        
        buttonSoundToggleSwitch.setImage(UIImage(named: audioSettingEnabled ? "ToggleOnIcon" : "ToggleOffIcon"), for: .normal)
        buttonVibrationToggleSwitch.setImage(UIImage(named: vibrationSettingEnabled ? "ToggleOnIcon" : "ToggleOffIcon"), for: .normal)
    }
    
    @objc private func toggleSoundPreferenceSetting() {
        let isSoundActive = buttonSoundToggleSwitch.currentImage == UIImage(named: "ToggleOnIcon")
        let newSoundState = !isSoundActive
        buttonSoundToggleSwitch.setImage(UIImage(named: newSoundState ? "ToggleOnIcon" : "ToggleOffIcon"), for: .normal)
        UserDefaults.standard.set(newSoundState, forKey: "audioEnabled")
    }
    
    @objc private func toggleVibrationPreferenceSetting() {
        let isVibrationActive = buttonVibrationToggleSwitch.currentImage == UIImage(named: "ToggleOnIcon")
        let newVibrationState = !isVibrationActive
        buttonVibrationToggleSwitch.setImage(UIImage(named: newVibrationState ? "ToggleOnIcon" : "ToggleOffIcon"), for: .normal)
        UserDefaults.standard.set(newVibrationState, forKey: "vibrationEnabled")
    }
    
    @objc private func activateMainMenuNavigation() {
        dismiss(animated: false)
        initiateMainMenuNavigation?()
    }
    
    @objc private func resumeGameplay() {
        resumeGameplaySession?()
        dismiss(animated: true, completion: nil)
    }
}
