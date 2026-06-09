import SwiftUI

struct SettingsView: View {
    // Form States
    @State private var fullName = "Ahmad Naufal bin Azman"
    @State private var email = "ahmad.naufal@student.edu.my"
    @State private var phone = "+60 12-345 6789"
    
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    // Toggle States
    @State private var darkMode = false
    @State private var compactSidebar = false
    @State private var showProgress = true
    @State private var animatedTransitions = true
    
    @State private var notifEvents = true
    @State private var notifModules = true
    @State private var notifAchievements = true
    @State private var notifWeekly = false
    @State private var notifEmail = true
    @State private var notifPush = false
    
    var body: some View {
        HStack(spacing: 0) {
            // Sidebar (Assuming you have SidebarView in index.swift)
            // If you get an error, remove this line and the VStack below it, 
            // and just use the ScrollView part.
            SidebarView()
                .frame(width: 260)
                .background(Color(red: 0.12, green: 0.16, blue: 0.23))
            
            VStack(spacing: 0) {
                // Top Header
                TopHeaderView(searchText: .constant(""))
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // Page Header
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Settings")
                                .font(.system(size: 28, weight: .bold))
                            Text("Manage your account, notifications and preferences")
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 30)
                        .padding(.horizontal, 40)
                        
                        // 2-Column Grid for Cards
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
                            
                            // 1. Edit Profile Card
                            SettingsCard(title: "Edit Profile", icon: "person.crop.circle") {
                                VStack(alignment: .leading, spacing: 16) {
                                    SettingsTextField(title: "Full Name", text: $fullName)
                                    SettingsTextField(title: "Email Address", text: $email)
                                    SettingsTextField(title: "Phone Number", text: $phone)
                                    
                                    Button(action: {
                                        print("Profile Saved")
                                    }) {
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
                            SettingsCard(title: "Change Password", icon: "lock.shield") {
                                VStack(alignment: .leading, spacing: 16) {
                                    SettingsSecureField(title: "Current Password", text: $currentPassword)
                                    SettingsSecureField(title: "New Password", text: $newPassword)
                                    SettingsSecureField(title: "Confirm New Password", text: $confirmPassword)
                                    
                                    Button(action: {
                                        print("Password Updated")
                                    }) {
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
                            SettingsCard(title: "Notifications", icon: "bell") {
                                VStack(spacing: 0) {
                                    ToggleRow(title: "New Event Announcements", isOn: $notifEvents)
                                    Divider()
                                    ToggleRow(title: "Module Completion Reminders", isOn: $notifModules)
                                    Divider()
                                    ToggleRow(title: "Achievement Unlocked Alerts", isOn: $notifAchievements)
                                    Divider()
                                    ToggleRow(title: "Weekly Progress Summary", isOn: $notifWeekly)
                                    Divider()
                                    ToggleRow(title: "Email Notifications", isOn: $notifEmail)
                                    Divider()
                                    ToggleRow(title: "Push Notifications", isOn: $notifPush, isLast: true)
                                }
                            }
                            
                            // 4. Theme & Display Card
                            SettingsCard(title: "Theme & Display", icon: "paintpalette") {
                                VStack(spacing: 0) {
                                    ToggleRow(title: "Dark Mode", isOn: $darkMode)
                                    Divider()
                                    ToggleRow(title: "Compact Sidebar", isOn: $compactSidebar)
                                    Divider()
                                    ToggleRow(title: "Show Progress Percentages", isOn: $showProgress)
                                    Divider()
                                    ToggleRow(title: "Animated Transitions", isOn: $animatedTransitions, isLast: true)
                                }
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                    }
                }
                .background(Color(red: 0.94, green: 0.95, blue: 0.96))
            }
        }
        .frame(minWidth: 1000, minHeight: 700)
    }
}

// MARK: - Reusable Settings Components

struct SettingsCard<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(.orange)
                    .font(.system(size: 18))
                Text(title)
                    .font(.system(size: 18, weight: .bold))
            }
            
            content
        }
        .padding(28)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
    }
}

struct SettingsTextField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.gray)
            
            TextField("", text: $text)
                .padding(12)
                .background(Color(red: 0.97, green: 0.98, blue: 0.99))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2), lineWidth: 1))
        }
    }
}

struct SettingsSecureField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.gray)
            
            SecureField("", text: $text)
                .padding(12)
                .background(Color(red: 0.97, green: 0.98, blue: 0.99))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2), lineWidth: 1))
        }
    }
}

struct ToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    var isLast: Bool = false
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.primary)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.orange) // Makes the toggle switch orange when on
        }
        .padding(.vertical, 12)
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
}