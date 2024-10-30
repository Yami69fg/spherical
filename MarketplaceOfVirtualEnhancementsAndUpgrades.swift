import UIKit
import SnapKit

class MarketplaceOfVirtualEnhancementsAndUpgrades: UIViewController {

    private var globalScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: "globalScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "globalScore")
            globalScoreLabel.text = "\(newValue)"
        }
    }
    
    private var selectedImageName: String {
        get {
            return UserDefaults.standard.string(forKey: "selectedImageName") ?? "BG"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedImageName")
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
        button.setImage(UIImage(named: "PoppyButton"), for: .normal)
        return button
    }()
    
    private let celestialMarketButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "FieldButton"), for: .normal)
        return button
    }()
    
    private let astralAchievementButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "RoseButton"), for: .normal)
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
    
    private let nebulaPortalCost = 250
    private let celestialMarketCost = 500
    private let astralAchievementCost = 1000

    override func viewDidLoad() {
        super.viewDidLoad()
        globalScoreLabel.text = "\(globalScore)"
        arrangeLayers()
        configureButtonActions()
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
        purchaseImage(named: "Poppy", cost: nebulaPortalCost)
    }

    @objc private func openCelestialMarket() {
        purchaseImage(named: "Field", cost: celestialMarketCost)
    }

    @objc private func viewAstralAchievements() {
        purchaseImage(named: "Rose", cost: astralAchievementCost)
    }

    private func purchaseImage(named imageName: String, cost: Int) {
        let purchasedKey = "\(imageName)_purchased"
        if UserDefaults.standard.bool(forKey: purchasedKey) {
            selectedImageName = imageName
            showAlert(message: "\(imageName) background set.")
            return
        }

        if globalScore < cost {
            showAlert(message: "You need \(cost) points for \(imageName) background.")
            return
        }

        let alert = UIAlertController(title: "Confirm Purchase", message: "Spend \(cost) points for \(imageName) background?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.globalScore -= cost
            UserDefaults.standard.set(true, forKey: purchasedKey)
            self.selectedImageName = imageName
            self.showAlert(message: "\(imageName) background purchased and set.")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
