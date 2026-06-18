import Foundation
import Combine


final class AppState: ObservableObject {

    static let shared = AppState()

    @Published var isLoggedIn: Bool = false
    @Published var isRegistered: Bool = false

    // User info
    @Published var userName: String     = ""
    @Published var userEmail: String    = ""
    @Published var userPhone: String    = ""
    @Published var userPassword: String = ""

   
    @Published var moduleProgress: [String: ModuleStatus] = [:]
    @Published var gameProgress: [String: GameProgress] = [:]

    var userInitials: String {
        let parts = userName.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))".uppercased()
        }
        return String(userName.prefix(2)).uppercased()
    }

    // Stats derived from progress
    var modulesCompleted: Int { moduleProgress.values.filter { $0 == .completed }.count }
    var gamesPlayed: Int { gameProgress.values.filter { $0.hasPlayed }.count }

    private init() {}


    func register(fullName: String, email: String, phone: String, password: String) {
        userName     = fullName
        userEmail    = email
        userPhone    = phone
        userPassword = password
        isRegistered = true

        // Reset all progress for new account
        moduleProgress = [:]
        gameProgress   = [:]

        isLoggedIn = true
    }

    // MARK: - Login
    func login(email: String, password: String) -> String? {
        guard isRegistered else {
            return "No account found. Please sign up first."
        }
        if email.lowercased() != userEmail.lowercased() {
            return "Email not found. Please check your email or sign up."
        }
        if password != userPassword {
            return "Incorrect password. Please try again."
        }
        isLoggedIn = true
        return nil
    }

    // MARK: - Logout
    func logout() {
        isLoggedIn = false
    }

    // MARK: - Update Profile
    func updateProfile(name: String, email: String, phone: String) {
        userName  = name
        userEmail = email
        userPhone = phone
    }

    // MARK: - Change Password
    func changePassword(current: String, newPass: String) -> String? {
        if current != userPassword {
            return "Current password is incorrect."
        }
        if newPass.count < 6 {
            return "New password must be at least 6 characters."
        }
        userPassword = newPass
        return nil
    }

    // MARK: - Module Progress
    func status(for moduleTitle: String) -> ModuleStatus {
        return moduleProgress[moduleTitle] ?? .locked
    }

    func setModuleStatus(_ status: ModuleStatus, for title: String) {
        moduleProgress[title] = status
    }

    // MARK: - Game Progress
    func gameProgressFor(_ title: String, level: String) -> GameProgress {
        let key = "\(title)_\(level)"
        return gameProgress[key] ?? GameProgress()
    }

    func markGamePlayed(_ title: String, level: String, time: Double) {
        let key = "\(title)_\(level)"
        var progress = gameProgress[key] ?? GameProgress()
        progress.hasPlayed = true
        progress.bestTime = progress.bestTime == 0 ? time : min(progress.bestTime, time)
        gameProgress[key] = progress
    }
}

// MARK: - Module Status
enum ModuleStatus: String {
    case completed  = "Completed"
    case inProgress = "In Progress"
    case locked     = "Locked"

    var label: String { self.rawValue }
}

// MARK: - Game Progress
struct GameProgress {
    var hasPlayed: Bool = false
    var bestTime: Double = 0
}
