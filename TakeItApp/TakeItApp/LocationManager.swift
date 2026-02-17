import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    // 用户可设置更小半径，但定位精度差时自动兜底
    private let fallbackRadius: Double = 50

    @Published var lastAccuracy: Double = -1
    @Published var currentLocation: CLLocation?
    @Published var authStatus: CLAuthorizationStatus = .notDetermined

    var onExitRegion: ((String) -> Void)?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = true
    }

    func requestPermissions() {
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }

    func updateMonitoring(places: [PlaceReminder]) {
        for region in manager.monitoredRegions {
            manager.stopMonitoring(for: region)
        }

        for place in places where place.enabled {
            let effectiveRadius: Double
            if lastAccuracy < 0 || lastAccuracy > 30 {
                effectiveRadius = max(place.radius, fallbackRadius)
            } else {
                effectiveRadius = max(place.radius, 20)
            }

            let region = CLCircularRegion(
                center: place.coordinate,
                radius: max(20, effectiveRadius),
                identifier: place.id.uuidString
            )
            region.notifyOnEntry = false
            region.notifyOnExit = true
            manager.startMonitoring(for: region)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        currentLocation = loc
        lastAccuracy = loc.horizontalAccuracy
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authStatus = status
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        onExitRegion?(region.identifier)
    }
}
