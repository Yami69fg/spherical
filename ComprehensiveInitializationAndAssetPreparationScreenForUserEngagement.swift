import UIKit
import SnapKit

class ComprehensiveInitializationAndAssetPreparationScreenForUserEngagement: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        organizeViewStructureAndApplyConstraints()
        startBallDropAnimationToLoadingLabel()
        startOpacityEffectForLoadingLabel()
        performNavigationToMainMenuUponLoadingCompletion()
    }

    private func organizeViewStructureAndApplyConstraints() {
        addBackgroundToViewHierarchy()
        addBallToViewHierarchy()
        addLoadingLabelToViewHierarchy()
        applyConstraintsToBackgroundImage()
        applyConstraintsToLoadingLabelImage()
    }
    
    private func addBackgroundToViewHierarchy() {
        view.addSubview(screenBackgroundImageForAllModules)
    }

    private func addBallToViewHierarchy() {
        view.addSubview(animatedBallForMainMenuLoadingScreen)
    }

    private func addLoadingLabelToViewHierarchy() {
        view.addSubview(loadingSequenceLabelImageForOpacityEffect)
    }

    private func applyConstraintsToBackgroundImage() {
        screenBackgroundImageForAllModules.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func applyConstraintsToLoadingLabelImage() {
        loadingSequenceLabelImageForOpacityEffect.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
            make.width.equalTo(350)
            make.height.equalTo(125)
        }
    }

    private func startBallDropAnimationToLoadingLabel() {
        animatedBallForMainMenuLoadingScreen.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(loadingSequenceLabelImageForOpacityEffect.snp.top).offset(-UIScreen.main.bounds.height)
            make.width.height.equalTo(250)
        }
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.animatedBallForMainMenuLoadingScreen.snp.updateConstraints { make in
                make.bottom.equalTo(self.loadingSequenceLabelImageForOpacityEffect.snp.top).offset(-20)
            }
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.startRotationAnimationForBall()
        })
    }
    
    private let loadingSequenceLabelImageForOpacityEffect: UIImageView = {
        let labelForLoading = UIImageView()
        labelForLoading.image = UIImage(named: "Load")
        labelForLoading.contentMode = .scaleAspectFit
        return labelForLoading
    }()
    
    private let animatedBallForMainMenuLoadingScreen: UIImageView = {
        let loadingBall = UIImageView()
        loadingBall.image = UIImage(named: "GBall")
        loadingBall.contentMode = .scaleAspectFill
        return loadingBall
    }()
    
    private func startRotationAnimationForBall() {
        UIView.animate(withDuration: 3, delay: 0.0, options: [.curveLinear, .repeat], animations: {
            self.animatedBallForMainMenuLoadingScreen.transform = CGAffineTransform(rotationAngle: .pi)
        }, completion: { _ in
            self.animatedBallForMainMenuLoadingScreen.transform = .identity
        })
    }

    private func startOpacityEffectForLoadingLabel() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.autoreverse, .repeat], animations: {
            self.loadingSequenceLabelImageForOpacityEffect.alpha = 0.0
        }, completion: { _ in
            self.loadingSequenceLabelImageForOpacityEffect.alpha = 1.0
        })
    }

    
    private let screenBackgroundImageForAllModules: UIImageView = {
        let backgroundImageForAllModules = UIImageView()
        backgroundImageForAllModules.image = UIImage(named: "BG")
        backgroundImageForAllModules.contentMode = .scaleAspectFill
        return backgroundImageForAllModules
    }()

    private func performNavigationToMainMenuUponLoadingCompletion() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let isLaunched = UserDefaults.standard.bool(forKey: "isLaunched")
            if !isLaunched {
                UserDefaults.standard.set(true, forKey: "isLaunched")
                UserDefaults.standard.synchronize()
                let bonusController = BonusController()
                bonusController.modalTransitionStyle = .crossDissolve
                bonusController.modalPresentationStyle = .fullScreen
                self.present(bonusController, animated: false, completion: nil)
            } else {
                let mainMenuControllerInstance = MainMenuControllerInstance()
                mainMenuControllerInstance.modalTransitionStyle = .crossDissolve
                mainMenuControllerInstance.modalPresentationStyle = .fullScreen
                self.present(mainMenuControllerInstance, animated: false, completion: nil)
            }
        }
    }
}
