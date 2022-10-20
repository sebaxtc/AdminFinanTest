import Foundation
import UIKit
import CoreLocation
import Combine
import RxSwift

enum PreferencesKeys: String {
  case savedItems
}

class LocationManager: NSObject, ObservableObject {
    private let firebaseManager = FirebaseManager()
    private let locationManager = CLLocationManager()
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @Published var locationStatus: CLAuthorizationStatus? {
        willSet {
            objectWillChange.send()
        }
    }
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }

        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
        
    let dispose = DisposeBag()

    let lastLocation = BehaviorSubject<CLLocation?>(
        value: CLLocation(latitude: CLLocationDegrees(19.4319716),
                                      longitude: CLLocationDegrees(-99.1356141)) //lastLocation instantiated with a starting value (single event buffer)
    )
        
    override init() {
        super.init()
        setUpLocationManager()
    }
    
    func setUpLocationManager() {
        let options: UNAuthorizationOptions = [.sound, .alert]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { _, error in
          if let error = error {
            print("Error: \(error)")
          }
        }
        stopAllMonitoring()
        locationManager.delegate = self
    }
    
    func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func removeNotifications(application: UIApplication) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func saveLastLocationOnAppKilled() {
        guard let lastLocation = locationManager.location else {return}
        print(lastLocation.coordinate)
        stopUpdatingLocations()
        stopAllMonitoring()
        removeAllGeotifications()
        var allGeotifications = getAllGeotifications()
        let newGeotification = createGeotifications(coordinate: lastLocation.coordinate, note: "newLocation", eventType: .onExit)
        allGeotifications.append(newGeotification)
        let _ = startMonitoring(geotification: newGeotification)
        let _ = saveGeotifications(geotifications: allGeotifications)
    }
    
    func stopUpdatingLocations() {
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingLocations() {
        locationManager.startUpdatingLocation()
    }
    
}

// MARK: - Location Manager Delegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
        print(#function, statusString)
        
        switch status {
            case .denied: // Setting option: Never
              print("LocationManager didChangeAuthorization denied")
            case .notDetermined: // Setting option: Ask Next Time
              print("LocationManager didChangeAuthorization notDetermined")
            case .authorizedWhenInUse: // Setting option: While Using the App
              print("LocationManager didChangeAuthorization authorizedWhenInUse")
              // Stpe 6: Request a one-time location information
            case .authorizedAlways: // Setting option: Always
              print("LocationManager didChangeAuthorization authorizedAlways")
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.activityType = CLActivityType.other
                locationManager.allowsBackgroundLocationUpdates = true
                locationManager.pausesLocationUpdatesAutomatically = false
                //locationManager.distanceFilter = 1.0
                startUpdatingLocations()
            case .restricted: // Restricted by parental control
              print("LocationManager didChangeAuthorization restricted")
            default:
              print("LocationManager didChangeAuthorization")
            }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation.on(.next(location))
        print(#function, location)
        firebaseManager.sendLocation(location: location.coordinate)
    }
    
    func locationManager(
      _ manager: CLLocationManager,
      didEnterRegion region: CLRegion
    ) {
      if region is CLCircularRegion {
        handleEvent(for: region)
      }
    }

    func locationManager(
      _ manager: CLLocationManager,
      didExitRegion region: CLRegion
    ) {
      if region is CLCircularRegion {
        handleEvent(for: region)
      }
    }

    func handleEvent(for region: CLRegion) {
      // Show an alert if application is active
      if UIApplication.shared.applicationState == .active {
        guard let _ = note(from: region.identifier) else { return }
      }
      else {
        var body = "no last location"
        let locationManager = CLLocationManager()
        guard let lastLocation = locationManager.location else {return}
        body = "last: \(lastLocation)"
        // Otherwise present a local notification
        guard let geotification = getGeotification(from: region.identifier) else { return }
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = geotification.note
        notificationContent.body = body
        notificationContent.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
          identifier: "location_change",
          content: notificationContent,
          trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
          if let error = error {
            print("Error: \(error)")
          }
        }
        
        stopMonitoring(geotification: geotification)
        let result = removeGeotification(geotification)
        var allGeotifications = getAllGeotifications()
        let newGeotification = createGeotifications(coordinate: lastLocation.coordinate, note: "newLocation: " + "\(result)", eventType: .onExit)
        allGeotifications.append(newGeotification)
        let _ = startMonitoring(geotification: newGeotification)
        let _ = saveGeotifications(geotifications: allGeotifications)
      }
    }

    func note(from identifier: String) -> String? {
      let geotifications = Geotification.allGeotifications()
      let matched = geotifications.first { $0.identifier == identifier }
      return matched?.note
    }
    
    func getGeotification(from identifier: String) -> Geotification? {
      let geotifications = Geotification.allGeotifications()
      let matched = geotifications.first { $0.identifier == identifier }
      return matched
    }
    
    func createGeotifications(coordinate: CLLocationCoordinate2D, note: String, eventType: Geotification.EventType) -> Geotification {
      let radius = Double(1)
      let identifier = NSUUID().uuidString
      let geotification = Geotification(
        coordinate: coordinate,
        radius: radius,
        identifier: identifier,
        note: note,
        eventType: eventType)
      
      return geotification
    }
    
    func removeGeotification(_ geotification: Geotification) -> Bool {
      var allGeotifications = getAllGeotifications()
      guard let index = allGeotifications.firstIndex(where: { (item) -> Bool in
        item.identifier == geotification.identifier // test if this is the item you're looking for
      }) else {
        return false
      }
      allGeotifications.remove(at: index)
      return saveGeotifications(geotifications: allGeotifications)
    }
    
    func removeAllGeotifications() {
      UserDefaults.standard.removeObject(forKey: PreferencesKeys.savedItems.rawValue)
    }
    
    func saveGeotifications(geotifications: [Geotification]) -> Bool {
      let encoder = JSONEncoder()
      do {
        let data = try encoder.encode(geotifications)
        UserDefaults.standard.set(data, forKey: PreferencesKeys.savedItems.rawValue)
      } catch {
        print("error encoding geotifications")
        return false
      }
      return true
    }
    
    func getAllGeotifications() -> [Geotification] {
      return Geotification.allGeotifications()
    }
    
    // MARK: Put monitoring functions below
    func startMonitoring(geotification: Geotification) -> Bool {
      // 1
      if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
        return false
      }

      // 2
      let fenceRegion = geotification.region
      locationManager.startMonitoring(for: fenceRegion)
      return true
    }

    func stopMonitoring(geotification: Geotification) {
      for region in locationManager.monitoredRegions {
        guard let circularRegion = region as? CLCircularRegion,
          circularRegion.identifier == geotification.identifier
        else { continue }

        locationManager.stopMonitoring(for: circularRegion)
      }
    }
    
    func stopAllMonitoring() {
      for region in locationManager.monitoredRegions {
        guard let circularRegion = region as? CLCircularRegion
        else { continue }

        locationManager.stopMonitoring(for: circularRegion)
      }
    }
}
