import UIKit
import SnapKit

class MultiDimensionalGameAndAdventureLibrary: UIViewController {

    private var globalScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: "globalScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "globalScore")
            globalScoreLabel.text = "\(newValue)"
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
        button.setImage(UIImage(named: "Falsy"), for: .normal)
        return button
    }()
    
    private let celestialMarketButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Carond"), for: .normal)
        return button
    }()
    
    private let astralAchievementButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Hidery"), for: .normal)
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
        arrangeCosmicLayers()
        configureButtonActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        globalScoreLabel.text = "\(globalScore)"
    }

    private func arrangeCosmicLayers() {
        addBackdropLayer()
        addButtonsToView()
        addScoreElements()
        setBackdropConstraints()
        setCornerButtonConstraints()
        setVerticalButtonLayout()
        setScoreBackgroundConstraints()
        setScoreLabelConstraints()
    }

    private func addBackdropLayer() {
        view.addSubview(cosmicBackdrop)
    }

    private func addButtonsToView() {
        view.addSubview(orbitReturnButton)
        view.addSubview(nebulaPortalButton)
        view.addSubview(celestialMarketButton)
        view.addSubview(astralAchievementButton)
    }
    
    private func addScoreElements() {
        view.addSubview(scoreBackgroundImageView)
        scoreBackgroundImageView.addSubview(globalScoreLabel)
    }

    private func setBackdropConstraints() {
        cosmicBackdrop.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setCornerButtonConstraints() {
        orbitReturnButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(55)
        }
    }

    private func setVerticalButtonLayout() {
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
    }

    private func setScoreBackgroundConstraints() {
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

    private func configureButtonActions() {
        orbitReturnButton.addTarget(self, action: #selector(returnToOrbit), for: .touchUpInside)
        addSound(button: orbitReturnButton)
        nebulaPortalButton.addTarget(self, action: #selector(openNebulaPortal), for: .touchUpInside)
        addSound(button: nebulaPortalButton)
        celestialMarketButton.addTarget(self, action: #selector(openCelestialMarket), for: .touchUpInside)
        addSound(button: celestialMarketButton)
        astralAchievementButton.addTarget(self, action: #selector(viewAstralAchievements), for: .touchUpInside)
        addSound(button: astralAchievementButton)
    }

    @objc private func returnToOrbit() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func openNebulaPortal() {
        let falsyViewController = QuestStageController()
        falsyViewController.numGame = 1
        falsyViewController.levelKey = "levelCompletionStatusArray"
        falsyViewController.initiateMainMenuNavigation = { [weak self] in
            self?.dismiss(animated: false)
        }
        falsyViewController.modalTransitionStyle = .crossDissolve
        falsyViewController.modalPresentationStyle = .fullScreen
        self.present(falsyViewController, animated: false, completion: nil)
    }

    @objc private func openCelestialMarket() {
        let cardonViewController = QuestStageController()
        cardonViewController.numGame = 2
        cardonViewController.levelKey = "levelCompletionStatusArray2"
        cardonViewController.initiateMainMenuNavigation = { [weak self] in
            self?.dismiss(animated: false)
        }
        cardonViewController.modalTransitionStyle = .crossDissolve
        cardonViewController.modalPresentationStyle = .fullScreen
        self.present(cardonViewController, animated: false, completion: nil)
    }

    @objc private func viewAstralAchievements() {
        let hideryViewController = QuestStageController()
        hideryViewController.numGame = 3
        hideryViewController.levelKey = "levelCompletionStatusArray3"
        hideryViewController.initiateMainMenuNavigation = { [weak self] in
            self?.dismiss(animated: false)
        }
        hideryViewController.modalTransitionStyle = .crossDissolve
        hideryViewController.modalPresentationStyle = .fullScreen
        self.present(hideryViewController, animated: false, completion: nil)
    }
}
