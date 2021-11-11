import UIKit
import BanubaSdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let documents = FileManager.default.urls(
        for: .documentDirectory,
           in: .userDomainMask
    ).last ?? FileManager.default.temporaryDirectory
    
    func application(_application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        BanubaSdkManager.initialize(
            resourcePath: [documents.appendingPathComponent("Effects").path],
            clientTokenString: banubaClientToken
        )
        
        return true
    }
}

