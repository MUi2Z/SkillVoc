import SwiftUI
import FirebaseCore

@main
struct SkillVocApp: App {
    @StateObject private var appState = AppState.shared

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(appState)
        }
    }
}
