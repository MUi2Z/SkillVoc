import SwiftUI

@main
struct SkillVocApp: App {

    @StateObject private var appState = AppState.shared

    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                MainTabView()
                    .environmentObject(appState)
            } else {
                LoginView()
                    .environmentObject(appState)
            }
        }
    }
}
