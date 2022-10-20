
import Foundation
import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    
    let locationManager = LocationManager()
    let firebaseManager = FirebaseManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        locationManager.setUpLocationManager()
        locationManager.requestAlwaysAuthorization()
        
        let _ = locationManager.lastLocation
            .subscribe { (newLocation) in
                guard let coord = newLocation?.coordinate else {return}
                self.firebaseManager.sendLocation(location: coord)
            } onError: { (error) in
                
            } onCompleted: {
                
            } onDisposed: {
                
            }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        locationManager.removeNotifications(application: application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        locationManager.saveLastLocationOnAppKilled()
    }
}
