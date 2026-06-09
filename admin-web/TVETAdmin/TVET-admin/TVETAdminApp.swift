import SwiftUI
import Combine

@main
struct TVETAdminApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

// App State Manager
class AppState: ObservableObject {
    @Published var currentView: AppView = .login
    @Published var isLoggedIn = false
    
    // Settings
    @Published var darkMode = false
    @Published var compactSidebar = false
    @Published var showProgressPercentages = true
    @Published var animatedTransitions = true
    
    // Notifications
    @Published var notifications: [Notification] = [
        Notification(id: 1, title: "New module published", message: "Web Dev Basics is now available", time: "2 hours ago", isRead: false),
        Notification(id: 2, title: "Student completed course", message: "Siti Aminah completed Intro to Coding", time: "4 hours ago", isRead: false),
        Notification(id: 3, title: "System backup", message: "Backup completed successfully", time: "Yesterday", isRead: true),
        Notification(id: 4, title: "New game added", message: "Code Quest added to library", time: "2 days ago", isRead: true)
    ]
    
    // Notification Preferences
    @Published var notifEvents = true
    @Published var notifModules = true
    @Published var notifAchievements = true
    @Published var notifWeekly = false
    @Published var notifEmail = true
    @Published var notifPush = false
    
    enum AppView: String {
        case login, dashboard, profile, settings, modules, games, calendar, logout, signup
    }
    
    func login() {
        isLoggedIn = true
        currentView = .dashboard
    }
    
    func logout() {
        isLoggedIn = false
        currentView = .login
    }
    
    func navigate(to view: AppView) {
        withAnimation(animatedTransitions ? .easeInOut(duration: 0.3) : .none) {
            currentView = view
        }
    }
    
    var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }
    
    func markAsRead(id: Int) {
        if let index = notifications.firstIndex(where: { $0.id == id }) {
            notifications[index].isRead = true
        }
    }
    
    func markAllAsRead() {
        for i in 0..<notifications.count {
            notifications[i].isRead = true
        }
    }
    
    func clearAll() {
        notifications.removeAll()
    }
    
    func getFilteredNotifications() -> [Notification] {
        return notifications.filter { notification in
            if notification.title.contains("module") && !notifModules { return false }
            if notification.title.contains("Achievement") && !notifAchievements { return false }
            if notification.title.contains("Weekly") && !notifWeekly { return false }
            if notification.title.contains("Event") && !notifEvents { return false }
            return true
        }
    }
}

// Notification Model
struct Notification: Identifiable {
    let id: Int
    let title: String
    let message: String
    let time: String
    var isRead: Bool
}
