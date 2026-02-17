import SwiftUI
import CoreLocation

struct HomeView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var reminderEngine: ReminderEngine

    @State private var newItemName: String = ""
    @State private var placeName: String = "家"
    @State private var placeRadius: Double = 80

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    header
                    itemsCard
                    placesCard
                    testCard
                }
                .padding(16)
            }
            .background(Color(red: 244/255, green: 251/255, blue: 248/255).ignoresSafeArea())
            .navigationTitle("拿了吗")
        }
        .onAppear {
            locationManager.updateMonitoring(places: reminderEngine.places)
        }
        .onChange(of: reminderEngine.places) { newValue in
            locationManager.updateMonitoring(places: newValue)
            reminderEngine.save()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("出发前看一眼，今天更安心 🌿")
                .font(.headline)
            Text("提醒方式：离开地点后提醒。定位不稳时自动放宽半径，保证可用性。")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var itemsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("必拿清单")
                .font(.headline)

            ForEach($reminderEngine.items) { $item in
                Toggle(item.name, isOn: $item.enabled)
                    .tint(Color(red: 111/255, green: 214/255, blue: 184/255))
            }

            HStack {
                TextField("新增物品（例如：充电器）", text: $newItemName)
                    .textFieldStyle(.roundedBorder)
                Button("添加") {
                    let text = newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !text.isEmpty else { return }
                    reminderEngine.items.append(CarryItem(name: text))
                    reminderEngine.save()
                    newItemName = ""
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 246/255, green: 226/255, blue: 122/255))
                .foregroundStyle(.black)
            }
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var placesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("提醒地点")
                .font(.headline)

            TextField("地点名称", text: $placeName)
                .textFieldStyle(.roundedBorder)

            HStack {
                Text("提醒半径")
                Spacer()
                Text("\(Int(placeRadius))m")
                    .foregroundColor(.secondary)
            }
            Slider(value: $placeRadius, in: 50...200, step: 10)
                .tint(Color(red: 111/255, green: 214/255, blue: 184/255))

            Button("用当前位置添加地点") {
                guard let loc = locationManager.currentLocation else { return }
                let name = placeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "常用地点" : placeName
                let place = PlaceReminder(
                    name: name,
                    latitude: loc.coordinate.latitude,
                    longitude: loc.coordinate.longitude,
                    radius: placeRadius,
                    enabled: true
                )
                reminderEngine.places.append(place)
                reminderEngine.save()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 111/255, green: 214/255, blue: 184/255))

            if reminderEngine.places.isEmpty {
                Text("还没有地点。先到目标位置，再点“用当前位置添加地点”。")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            ForEach(reminderEngine.places) { place in
                VStack(alignment: .leading, spacing: 4) {
                    Text(place.name)
                        .font(.subheadline.weight(.semibold))
                    Text("半径 \(Int(place.radius))m")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color(red: 237/255, green: 250/255, blue: 244/255))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var testCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("状态")
                .font(.headline)
            Text("定位精度：\(locationManager.lastAccuracy < 0 ? "未知" : "约 \(Int(locationManager.lastAccuracy))m")")
                .font(.caption)
                .foregroundColor(.secondary)

            Button("测试提醒") {
                reminderEngine.notifyLeaving(placeName: "测试地点")
            }
            .buttonStyle(.bordered)
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
