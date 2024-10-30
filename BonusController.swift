import UIKit
import SnapKit

class BonusController: UIViewController {
    
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
    
    private let greetingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Welcome")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let bonusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Chest"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundToView()
        addGreetingImageToView()
        addBonusButtonToView()
        setupButtonAction()
    }
    
    private func addBackgroundToView() {
        view.addSubview(backgroundImageContainer)
        applyConstraintsToBackground()
    }
    
    private func applyConstraintsToBackground() {
        backgroundImageContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addGreetingImageToView() {
        view.addSubview(greetingImageView)
        applyConstraintsToGreetingImage()
    }
    
    private func applyConstraintsToGreetingImage() {
        greetingImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(100)
            make.width.equalTo(300)
            make.height.equalTo(100)
        }
    }
    
    private func addBonusButtonToView() {
        view.addSubview(bonusButton)
        applyConstraintsToBonusButton()
    }
    
    private func applyConstraintsToBonusButton() {
        bonusButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(300)
        }
    }
    
    private func setupButtonAction() {
        bonusButton.addTarget(self, action: #selector(bonusButtonTapped), for: .touchUpInside)
        addSound(button: bonusButton)
    }
    
    @objc private func bonusButtonTapped() {
        let alert = UIAlertController(title: "Congratulations!", message: "You've received 50 bonus coins!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.globalScore += 50
            self.navigateToMainMenu()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func navigateToMainMenu() {
        let mainMenuController = MainMenuControllerInstance()
        mainMenuController.modalTransitionStyle = .crossDissolve
        mainMenuController.modalPresentationStyle = .fullScreen
        self.present(mainMenuController, animated: true, completion: nil)
    }
}
