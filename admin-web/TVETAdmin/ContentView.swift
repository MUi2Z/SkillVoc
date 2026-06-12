import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            switch appState.currentView {
            case .login:
                LoginView()
            case .signup:
                SignupView()
            case .dashboard:
                DashboardView()
            case .profile:
                ProfileView()
            case .settings:
                SettingsView()
            case .logout:
                LogoutView()
            case .calendar:
                CalendarEventsView()
            case .games:
                GamesView()
            case .modules:
                ModuleManagementView()
            case .lift:
                SokSokTowerView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
