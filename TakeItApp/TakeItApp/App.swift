import SwiftUI

@main
struct TakeItApp: App {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var reminderEngine = ReminderEngine()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationManager)
                .environmentObject(reminderEngine)
                .onAppear {
                    reminderEngine.bootstrap()

                    locationManager.onExitRegion = { regionID in
                        reminderEngine.handleExit(regionID: regionID)
                    }

                    locationManager.requestPermissions()
                    reminderEngine.requestNotificationPermission()
                    locationManager.updateMonitoring(places: reminderEngine.places)
                }
        }
    }
}
