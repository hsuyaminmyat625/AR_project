import SwiftUI

@main
struct ARRunnerApp: App {
    private let appLocale = Locale(identifier: "ja_JP")

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.locale, appLocale)
        }
    }
}
