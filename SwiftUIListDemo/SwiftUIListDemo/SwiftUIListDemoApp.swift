import SwiftUI

@main
struct SwiftUIListDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(dataService: DataService())
        }
    }
}
