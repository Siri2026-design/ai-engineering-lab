import Foundation
import UserNotifications
import Combine

final class ReminderEngine: ObservableObject {
    @Published var items: [CarryItem] = []
    @Published var places: [PlaceReminder] = []

    private let itemsKey = "takeit.items"
    private let placesKey = "takeit.places"

    func bootstrap() {
        load()

        if items.isEmpty {
            items = [
                CarryItem(name: "手机"),
                CarryItem(name: "钥匙"),
                CarryItem(name: "钱包"),
                CarryItem(name: "耳机"),
                CarryItem(name: "工牌")
            ]
            save()
        }
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    func handleExit(regionID: String) {
        guard let place = places.first(where: { $0.id.uuidString == regionID }) else {
            notifyLeaving(placeName: "设置地点")
            return
        }
        notifyLeaving(placeName: place.name)
    }

    func notifyLeaving(placeName: String) {
        let enabledItems = items.filter { $0.enabled }.map { $0.name }
        let body = enabledItems.isEmpty
            ? "你刚离开\(placeName)。要不要确认一下今天要带的东西？"
            : "你刚离开\(placeName)。拿了吗：\(enabledItems.joined(separator: "、"))"

        let content = UNMutableNotificationContent()
        content.title = "拿了吗？"
        content.body = body
        content.sound = .default

        let req = UNNotificationRequest(
            identifier: "takeit.leave.\(UUID().uuidString)",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        UNUserNotificationCenter.current().add(req)
    }

    func save() {
        let enc = JSONEncoder()
        if let d1 = try? enc.encode(items) { UserDefaults.standard.set(d1, forKey: itemsKey) }
        if let d2 = try? enc.encode(places) { UserDefaults.standard.set(d2, forKey: placesKey) }
    }

    private func load() {
        let dec = JSONDecoder()
        if let d1 = UserDefaults.standard.data(forKey: itemsKey),
           let v1 = try? dec.decode([CarryItem].self, from: d1) {
            items = v1
        }
        if let d2 = UserDefaults.standard.data(forKey: placesKey),
           let v2 = try? dec.decode([PlaceReminder].self, from: d2) {
            places = v2
        }
    }
}
