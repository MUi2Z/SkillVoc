import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var showSaveSuccess = false
    
    // Edit Profile Fields
    @State private var fullName = "Ahmad Naufal bin Azman"
    @State private var email = "ahmad.naufal@student.edu.my"
    @State private var phone = "+60 12-345 6789"
    
    // Change Password Fields
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var passwordError = ""
    @State private var showPasswordError = false
    
    var body: some View {
        HStack(spacing: 0) {
            SidebarView()
                .frame(width: appState.compactSidebar ? 90 : 260)
                .background(Color(red: 0.12, green: 0.16, blue: 0.23))
            
            VStack(spacing: 0) {
                TopHeaderView(searchText: .constant(""))
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(appState.darkMode ? Color(red: 0.1, green: 0.1, blue: 0.12) : Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Settings")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(appState.darkMode ? .white : .primary)
                            Text("Manage your account, notifications and preferences")
                                .foregroundColor(appState.darkMode ? .gray : .secondary)
                        }
                        .padding(.top, 30)
                        .padding(.horizontal, 40)
                        
                        if showSaveSuccess {
                            Text("✓ Settings saved successfully!")
                                .foregroundColor(.green)
                                .font(.subheadline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                                .transition(.opacity)
                        }
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
                            
                            // 1. Edit Profile Card
                            SettingsCard(title: "Edit Profile", icon: "person", darkMode: appState.darkMode) {
                                VStack(spacing: 16) {
                                    SettingsTextField(title: "Full Name", text: $fullName, darkMode: appState.darkMode)
                                    SettingsTextField(title: "Email Address", text: $email, darkMode: appState.darkMode)
                                    SettingsTextField(title: "Phone Number", text: $phone, darkMode: appState.darkMode)
                                    
                                    Button(action: saveProfile) {
                                        Text("Save Changes")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(Color.orange)
                                            .cornerRadius(8)
                                    }
                                    .padding(.top, 8)
                                }
                            }
                            
                            // 2. Change Password Card
                            SettingsCard(title: "Change Password", icon: "lock.shield", darkMode: appState.darkMode) {
                                VStack(spacing: 16) {
                                    SettingsSecureField(title: "Current Password", text: $currentPassword, darkMode: appState.darkMode)
                                    SettingsSecureField(title: "New Password", text: $newPassword, darkMode: appState.darkMode)
                                    SettingsSecureField(title: "Confirm New Password", text: $confirmPassword, darkMode: appState.darkMode)
                                    
                                    if showPasswordError {
                                        Text(passwordError)
                                            .foregroundColor(.red)
                                            .font(.subheadline)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    
                                    Button(action: updatePassword) {
                                        Text("Update Password")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(Color.orange)
                                            .cornerRadius(8)
                                    }
                                    .padding(.top, 8)
                                }
                            }
                            
                            // 3. Notifications Card
                            SettingsCard(title: "Notifications", icon: "bell", darkMode: appState.darkMode) {
                                VStack(spacing: 0) {
                                    ToggleRow(title: "New Event Announcements", isOn: $appState.notifEvents, darkMode: appState.darkMode)
                                    Divider()
                                    ToggleRow(title: "Module Completion Reminders", isOn: $appState.notifModules, darkMode: appState.darkMode)
                                    Divider()
                                    ToggleRow(title: "Achievement Unlocked Alerts", isOn: $appState.notifAchievements, darkMode: appState.darkMode)
                                    Divider()
                                    ToggleRow(title: "Weekly Progress Summary", isOn: $appState.notifWeekly, darkMode: appState.darkMode)
                                    Divider()
                                    ToggleRow(title: "Email Notifications", isOn: $appState.notifEmail, darkMode: appState.darkMode)
                                    Divider()
                                    ToggleRow(title: "Push Notifications", isOn: $appState.notifPush, isLast: true, darkMode: appState.darkMode)
                                }
                            }
                            
                            // 4. Theme & Display Card
                            SettingsCard(title: "Theme & Display", icon: "paintpalette", darkMode: appState.darkMode) {
                                VStack(spacing: 0) {
                                    ToggleRow(title: "Dark Mode", isOn: $appState.darkMode, darkMode: appState.darkMode)
                                    Divider()
                                    ToggleRow(title: "Compact Sidebar", isOn: $appState.compactSidebar, darkMode: appState.darkMode)
                                    Divider()
                                    ToggleRow(title: "Show Progress Percentages", isOn: $appState.showProgressPercentages, darkMode: appState.darkMode)
                                    Divider()
                                    ToggleRow(title: "Animated Transitions", isOn: $appState.animatedTransitions, isLast: true, darkMode: appState.darkMode)
                                }
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                    }
                }
                .background(appState.darkMode ? Color(red: 0.08, green: 0.09, blue: 0.11) : Color(red: 0.94, green: 0.95, blue: 0.96))
            }
        }
        .frame(minWidth: 1000, minHeight: 700)
        .animation(appState.animatedTransitions ? .easeInOut(duration: 0.3) : .none, value: appState.compactSidebar)
    }
    
    private func saveProfile() {
        print("Profile saved: \(fullName), \(email), \(phone)")
        showSaveSuccess = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showSaveSuccess = false
        }
    }
    
    private func updatePassword() {
        if newPassword != confirmPassword {
            passwordError = "New passwords do not match"
            showPasswordError = true
            return
        }
        
        if newPassword.count < 6 {
            passwordError = "Password must be at least 6 characters"
            showPasswordError = true
            return
        }
        
        if currentPassword.isEmpty {
            passwordError = "Please enter your current password"
            showPasswordError = true
            return
        }
        
        passwordError = ""
        showPasswordError = false
        currentPassword = ""
        newPassword = ""
        confirmPassword = ""
        showSaveSuccess = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showSaveSuccess = false
        }
    }
}

// MARK: - Reusable Components

struct SettingsCard<Content: View>: View {
    let title: String
    let icon: String
    var darkMode: Bool = false
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(.orange)
                    .font(.system(size: 18))
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(darkMode ? .white : .primary)
            }
            
            content
        }
        .padding(28)
        .background(darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
    }
}

struct SettingsTextField: View {
    let title: String
    @Binding var text: String
    var darkMode: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(darkMode ? Color(red: 0.7, green: 0.7, blue: 0.75) : Color(red: 0.4, green: 0.4, blue: 0.45))
            
            TextField("", text: $text)
                .padding(12)
                .background(darkMode ? Color(red: 0.08, green: 0.09, blue: 0.11) : Color(red: 0.97, green: 0.98, blue: 0.99))
                .foregroundColor(darkMode ? .white : .black)
                .cornerRadius(8)
        }
    }
}

struct SettingsSecureField: View {
    let title: String
    @Binding var text: String
    var darkMode: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(darkMode ? Color(red: 0.7, green: 0.7, blue: 0.75) : Color(red: 0.4, green: 0.4, blue: 0.45))
            
            SecureField("", text: $text)
                .padding(12)
                .background(darkMode ? Color(red: 0.08, green: 0.09, blue: 0.11) : Color(red: 0.97, green: 0.98, blue: 0.99))
                .foregroundColor(darkMode ? .white : .black)
                .cornerRadius(8)
        }
    }
}

struct ToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    var isLast: Bool = false
    var darkMode: Bool = false
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(darkMode ? .white : .primary)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.orange)
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
