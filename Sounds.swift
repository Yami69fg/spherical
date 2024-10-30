import UIKit
import SpriteKit
import AVFoundation

class sound {
    
    static let shared = sound()
    private var audio: AVAudioPlayer?

    private init() {}
    
    func playSoundPress() {
        let isSoundEnabled = UserDefaults.standard.bool(forKey: "audioEnabled")
        if isSoundEnabled {
            guard let sound = Bundle.main.url(forResource: "button", withExtension: "mp3") else { return }
            audio = try? AVAudioPlayer(contentsOf: sound)
            audio?.play()
        }
        
        let isVibrationEnabled = UserDefaults.standard.bool(forKey: "vibrationEnabled")
        if isVibrationEnabled {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.impactOccurred()
        }
    }
}



extension UIViewController {
    
    func addSound(button: UIButton) {
        button.addTarget(self, action: #selector(handleButtonTouchDown(sender:)), for: .touchDown)
    }
    
    @objc private func handleButtonTouchDown(sender: UIButton) {
        sound.shared.playSoundPress()
    }
}
