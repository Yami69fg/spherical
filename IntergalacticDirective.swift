import UIKit
import SnapKit

class IntergalacticDirective: UIViewController {
    
    var numDiscription = 1
    
    private let cosmicBackdropGalaxyView: UIImageView = {
        let imageViewBackdrop = UIImageView()
        imageViewBackdrop.image = UIImage(named: "BG")
        imageViewBackdrop.contentMode = .scaleAspectFill
        return imageViewBackdrop
    }()
    
    private let navigateBackToOrbitButton: UIButton = {
        let buttonOrbitBack = UIButton()
        buttonOrbitBack.setImage(UIImage(named: "TargetBack"), for: .normal)
        return buttonOrbitBack
    }()
    
    private let interactiveContentZoneImageView: UIImageView = {
        let imageViewContentZone = UIImageView()
        imageViewContentZone.image = UIImage(named: "BGExtra")
        imageViewContentZone.isUserInteractionEnabled = true
        return imageViewContentZone
    }()
    
    private let instructionHeaderDisplayImageView: UIImageView = {
        let imageViewInstructionHeader = UIImageView()
        imageViewInstructionHeader.image = UIImage(named: "Instruction")
        imageViewInstructionHeader.contentMode = .scaleAspectFit
        return imageViewInstructionHeader
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLayoutForInitialSetup()
    }

    private func initializeLayoutForInitialSetup() {
        view.addSubview(cosmicBackdropGalaxyView)
        view.addSubview(navigateBackToOrbitButton)
        view.addSubview(interactiveContentZoneImageView)
        view.addSubview(instructionHeaderDisplayImageView)

        setBackdropConstraintsForGalaxyView()
        setReturnButtonConstraintsForOrbitScreen()
        setContentZoneConstraintsForInteractiveImage()
        setInstructionHeaderImageConstraints()
        addInstructionalMultilineTextLabelWithAutoSizing()
    }

    private func setBackdropConstraintsForGalaxyView() {
        cosmicBackdropGalaxyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setReturnButtonConstraintsForOrbitScreen() {
        navigateBackToOrbitButton.addTarget(self, action: #selector(performReturnToMainOrbitScreenAction), for: .touchUpInside)
        addSound(button: navigateBackToOrbitButton)
        navigateBackToOrbitButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(55)
        }
    }

    private func setContentZoneConstraintsForInteractiveImage() {
        interactiveContentZoneImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func setInstructionHeaderImageConstraints() {
        instructionHeaderDisplayImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(interactiveContentZoneImageView.snp.top).offset(-20)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(80)
        }
    }
    
    private func addInstructionalMultilineTextLabelWithAutoSizing() {
        let instructionalAutoSizingTextLabel = UILabel()
        if numDiscription == 1{
            instructionalAutoSizingTextLabel.text = "Every second, a green or red ball will fall, and you need to tap only on the red balls to destroy them. If a red ball touches the bottom line, you’ll lose. In each level, you need to survive for a set amount of time."
        } else if numDiscription == 2{
            instructionalAutoSizingTextLabel.text = "You have two buttons to choose a color: purple or blue. After selecting a color, tap on the card, and it will flip to reveal whether you guessed the card's color correctly or not."
        } else {
            instructionalAutoSizingTextLabel.text = "You have a 5x5 grid where you need to guess the location of a green ball five times. If you uncover a red ball, you lose the game, and with each guess, the number of red balls increases."
        }
        instructionalAutoSizingTextLabel.numberOfLines = 0
        instructionalAutoSizingTextLabel.textAlignment = .center
        instructionalAutoSizingTextLabel.textColor = .white
        instructionalAutoSizingTextLabel.font = UIFont(name: "Questrian", size: 32)
        instructionalAutoSizingTextLabel.adjustsFontSizeToFitWidth = true
        instructionalAutoSizingTextLabel.minimumScaleFactor = 0.5

        interactiveContentZoneImageView.addSubview(instructionalAutoSizingTextLabel)
        
        instructionalAutoSizingTextLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(instructionalAutoSizingTextLabel.snp.width).multipliedBy(1.25)
        }
    }

    @objc private func performReturnToMainOrbitScreenAction() {
        dismiss(animated: true, completion: nil)
    }
}
