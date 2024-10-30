import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var mainWindow: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        
        self.mainWindow = UIWindow(frame: UIScreen.main.bounds)
        self.mainWindow?.rootViewController = UINavigationController(rootViewController: ComprehensiveInitializationAndAssetPreparationScreenForUserEngagement())
        self.mainWindow?.makeKeyAndVisible()
        
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return .portrait
    }


}
