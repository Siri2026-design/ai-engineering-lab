import Foundation
import CoreLocation

struct CarryItem: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var enabled: Bool

    init(id: UUID = UUID(), name: String, enabled: Bool = true) {
        self.id = id
        self.name = name
        self.enabled = enabled
    }
}

struct PlaceReminder: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var radius: Double // 用户设置半径，默认 5m
    var enabled: Bool

    init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double, radius: Double = 5, enabled: Bool = true) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.enabled = enabled
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
