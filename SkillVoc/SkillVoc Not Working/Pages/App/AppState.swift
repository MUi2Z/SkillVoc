import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

final class AppState: ObservableObject {

    static let shared = AppState()

    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    @Published var userPhone: String = ""
    @Published var moduleProgress: [String: ModuleStatus] = [:]
    @Published var gameProgress: [String: GameProgress] = [:]

    private let db = Firestore.firestore()
    private var authListener: AuthStateDidChangeListenerHandle?

    var userInitials: String {
        let parts = userName.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))".uppercased()
        }
        return String(userName.prefix(2)).uppercased()
    }

    var modulesCompleted: Int { moduleProgress.values.filter { $0 == .completed }.count }
    var gamesPlayed: Int { gameProgress.values.filter { $0.hasPlayed }.count }
    var achievements: Int {
        var count = 0
        if modulesCompleted >= 1 { count += 1 }
        if modulesCompleted >= 6 { count += 1 }
        if modulesCompleted >= 12 { count += 1 }
        if gamesPlayed >= 1 { count += 1 }
        if gamesPlayed >= 3 { count += 1 }
        if gamesPlayed >= 5 { count += 1 }
        return count
    }

    private init() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            if let user = user {
                self.isLoggedIn = true
                self.fetchUserData(uid: user.uid)
            } else {
                self.isLoggedIn = false
                self.clearLocalData()
            }
        }
    }

    func register(fullName: String, email: String, phone: String, password: String, completion: @escaping (String?) -> Void) {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            self.isLoading = false
            if let error = error {
                completion(error.localizedDescription)
                return
            }
            guard let uid = result?.user.uid else { return }
            let data: [String: Any] = [
                "fullName": fullName,
                "email": email,
                "phone": phone,
                "createdAt": FieldValue.serverTimestamp()
            ]
            self.db.collection("users").document(uid).setData(data) { error in
                if let error = error {
                    completion(error.localizedDescription)
                    return
                }
                self.userName = fullName
                self.userEmail = email
                self.userPhone = phone
                self.isLoggedIn = true
                completion(nil)
            }
        }
    }

    func login(email: String, password: String, completion: @escaping (String?) -> Void) {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self = self else { return }
            self.isLoading = false
            if let error = error {
                completion(error.localizedDescription)
                return
            }
            completion(nil)
        }
    }

    func logout() {
        try? Auth.auth().signOut()
        clearLocalData()
    }

    func updateProfile(name: String, email: String, phone: String, completion: @escaping (String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data: [String: Any] = ["fullName": name, "email": email, "phone": phone]
        db.collection("users").document(uid).updateData(data) { [weak self] error in
            if let error = error {
                completion(error.localizedDescription)
                return
            }
            self?.userName = name
            self?.userEmail = email
            self?.userPhone = phone
            completion(nil)
        }
    }

    func changePassword(current: String, newPass: String, completion: @escaping (String?) -> Void) {
        guard let user = Auth.auth().currentUser, let email = user.email else { return }
        if newPass.count < 6 {
            completion("New password must be at least 6 characters.")
            return
        }
        let credential = EmailAuthProvider.credential(withEmail: email, password: current)
        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                completion("Current password is incorrect.")
                return
            }
            user.updatePassword(to: newPass) { error in
                if let error = error {
                    completion(error.localizedDescription)
                    return
                }
                completion(nil)
            }
        }
    }

    func status(for moduleTitle: String) -> ModuleStatus {
        return moduleProgress[moduleTitle] ?? .notStarted
    }

    func setModuleStatus(_ status: ModuleStatus, for title: String) {
        moduleProgress[title] = status
        saveModuleProgress()
    }

    func markGamePlayed(_ title: String, level: String, time: Double) {
        let key = "\(title)_\(level)"
        var progress = gameProgress[key] ?? GameProgress()
        progress.hasPlayed = true
        progress.bestTime = progress.bestTime == 0 ? time : min(progress.bestTime, time)
        gameProgress[key] = progress
        saveGameProgress()
    }

    private func fetchUserData(uid: String) {
        db.collection("users").document(uid).getDocument { [weak self] snapshot, _ in
            guard let self = self, let data = snapshot?.data() else { return }
            self.userName = data["fullName"] as? String ?? ""
            self.userEmail = data["email"] as? String ?? ""
            self.userPhone = data["phone"] as? String ?? ""
        }
        db.collection("users").document(uid).collection("progress").document("modules").getDocument { [weak self] snapshot, _ in
            guard let self = self, let raw = snapshot?.data() as? [String: String] else { return }
            self.moduleProgress = raw.compactMapValues { ModuleStatus(rawValue: $0) }
        }
        db.collection("users").document(uid).collection("progress").document("games").getDocument { [weak self] snapshot, _ in
            guard let self = self, let data = snapshot?.data() else { return }
            var result: [String: GameProgress] = [:]
            for (key, value) in data {
                if let dict = value as? [String: Any] {
                    let played = dict["hasPlayed"] as? Bool ?? false
                    let best = dict["bestTime"] as? Double ?? 0
                    result[key] = GameProgress(hasPlayed: played, bestTime: best)
                }
            }
            self.gameProgress = result
        }
    }

    private func saveModuleProgress() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let raw = moduleProgress.mapValues { $0.rawValue }
        db.collection("users").document(uid).collection("progress").document("modules").setData(raw) { _ in }
    }

    private func saveGameProgress() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var data: [String: Any] = [:]
        for (key, value) in gameProgress {
            data[key] = ["hasPlayed": value.hasPlayed, "bestTime": value.bestTime]
        }
        db.collection("users").document(uid).collection("progress").document("games").setData(data) { _ in }
    }

    private func clearLocalData() {
        userName = ""
        userEmail = ""
        userPhone = ""
        moduleProgress = [:]
        gameProgress = [:]
    }
}

enum ModuleStatus: String {
    case completed   = "Completed"
    case inProgress  = "In Progress"
    case notStarted  = ""

    var label: String { self.rawValue }
}

struct GameProgress: Codable {
    var hasPlayed: Bool = false
    var bestTime: Double = 0
}
