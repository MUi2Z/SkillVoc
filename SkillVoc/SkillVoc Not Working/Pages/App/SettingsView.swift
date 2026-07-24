import SwiftUI

// MARK: - Settings View
struct SettingsView: View {

    @Binding var showSidebar: Bool

    var body: some View {
        ZStack {
            Color(hex: "#F5F0EB").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // Title
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Settings")
                            .font(.system(size: 28, weight: .black))
                            .foregroundColor(Color(hex: "#1C1C1E"))
                        Text("Manage your account, notifications and preferences")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#8E8E93"))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 24)

                    // 3 sections
                    VStack(spacing: 12) {
                        NavigationLink(destination: ProfileSettingsView()) {
                            SettingsRowCard(
                                icon: "person.circle.fill",
                                iconColor: Color(hex: "#E8472A"),
                                title: "Profile",
                                subtitle: "Edit your name, email and phone number"
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(destination: NotificationSettingsView()) {
                            SettingsRowCard(
                                icon: "bell.fill",
                                iconColor: Color(hex: "#FF9500"),
                                title: "Notifications",
                                subtitle: "Manage alerts, reminders and push notifications"
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(destination: HelpFeedbackView()) {
                            SettingsRowCard(
                                icon: "questionmark.circle.fill",
                                iconColor: Color(hex: "#2196F3"),
                                title: "Help & Feedback",
                                subtitle: "FAQs, contact support and send feedback"
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 20)

                    Text("SkillVoc v1.0.0")
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#C7C7CC"))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 32)
                        .padding(.bottom, 16)
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Settings Row Card
struct SettingsRowCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(hex: "#1C1C1E"))
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#8E8E93"))
                    .lineLimit(1)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(hex: "#C7C7CC"))
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
    }
}

// MARK: - Profile Settings
struct ProfileSettingsView: View {

    @EnvironmentObject var appState: AppState

    @State private var editName = ""
    @State private var editEmail = ""
    @State private var editPhone = ""
    @State private var showSaved = false
    @State private var showSavedBanner = false

    // Password fields
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var passwordError = ""
    @State private var passwordSuccess = false
    @State private var showCurrentPw = false
    @State private var showNewPw = false
    @State private var showConfirmPw = false

    var body: some View {
        ZStack {
            Color(hex: "#F5F0EB").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // ── Avatar ─────────────────────────────
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#E8472A"))
                                .frame(width: 86, height: 86)
                            Text(appState.userInitials)
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                        }
                        Text(appState.userName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(hex: "#1C1C1E"))
                        Text(appState.userEmail)
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#8E8E93"))
                    }
                    .padding(.top, 20)

                    // ── Success Banner ─────────────────────
                    if showSavedBanner {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(hex: "#34C759"))
                            Text("Profile updated successfully!")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: "#34C759"))
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#34C759").opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // ── Edit Profile Card ──────────────────
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 8) {
                            Image(systemName: "person.fill")
                                .foregroundColor(Color(hex: "#E8472A"))
                            Text("Edit Profile")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                        }

                        ProfileInputField(
                            label: "Full Name",
                            placeholder: "Enter your full name",
                            text: $editName,
                            icon: "person"
                        )

                        ProfileInputField(
                            label: "Email Address",
                            placeholder: "you@student.edu.my",
                            text: $editEmail,
                            icon: "envelope",
                            keyboardType: .emailAddress
                        )

                        ProfileInputField(
                            label: "Phone Number",
                            placeholder: "+60 12-345 6789",
                            text: $editPhone,
                            icon: "phone",
                            keyboardType: .phonePad
                        )

                        Button(action: { saveProfile() }) {
                            HStack(spacing: 8) {
                                Image(systemName: "square.and.arrow.down")
                                    .font(.system(size: 14, weight: .bold))
                                Text("Save Changes")
                                    .font(.system(size: 15, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color(hex: "#E8472A"))
                            .cornerRadius(14)
                        }
                    }
                    .padding(18)
                    .background(Color.white)
                    .cornerRadius(18)
                    .padding(.horizontal, 20)

                    // ── Change Password Card ───────────────
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 8) {
                            Image(systemName: "lock.fill")
                                .foregroundColor(Color(hex: "#FF9500"))
                            Text("Change Password")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                        }

                        // Current password
                        PasswordField(
                            label: "Current Password",
                            placeholder: "Enter current password",
                            text: $currentPassword,
                            isVisible: $showCurrentPw
                        )

                        // New password
                        PasswordField(
                            label: "New Password",
                            placeholder: "At least 6 characters",
                            text: $newPassword,
                            isVisible: $showNewPw
                        )

                        // Confirm password
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Confirm New Password")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(hex: "#6C6C70"))
                            HStack(spacing: 10) {
                                Image(systemName: "lock.shield")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#8E8E93"))
                                    .frame(width: 18)
                                if showConfirmPw {
                                    TextField("Re-enter new password", text: $confirmPassword)
                                        .font(.system(size: 14))
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled()
                                } else {
                                    SecureField("Re-enter new password", text: $confirmPassword)
                                        .font(.system(size: 14))
                                }
                                Button(action: { showConfirmPw.toggle() }) {
                                    Image(systemName: showConfirmPw ? "eye.slash" : "eye")
                                        .font(.system(size: 13))
                                        .foregroundColor(Color(hex: "#8E8E93"))
                                }
                                // Match indicator
                                if !confirmPassword.isEmpty {
                                    Image(systemName: confirmPassword == newPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .font(.system(size: 15))
                                        .foregroundColor(confirmPassword == newPassword ? Color(hex: "#34C759") : Color(hex: "#FF3B30"))
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 13)
                            .background(Color(hex: "#F5F0EB"))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "#E0DDD8"), lineWidth: 1))
                        }

                        // Error / success message
                        if !passwordError.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "#FF3B30"))
                                Text(passwordError)
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "#FF3B30"))
                            }
                            .padding(10)
                            .background(Color(hex: "#FF3B30").opacity(0.08))
                            .cornerRadius(10)
                        }

                        if passwordSuccess {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "#34C759"))
                                Text("Password updated! Use new password next time you sign in.")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "#34C759"))
                            }
                            .padding(10)
                            .background(Color(hex: "#34C759").opacity(0.08))
                            .cornerRadius(10)
                        }

                        Button(action: { savePassword() }) {
                            HStack(spacing: 8) {
                                Image(systemName: "lock.rotation")
                                    .font(.system(size: 14, weight: .bold))
                                Text("Update Password")
                                    .font(.system(size: 15, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color(hex: "#E8472A"))
                            .cornerRadius(14)
                        }
                    }
                    .padding(18)
                    .background(Color.white)
                    .cornerRadius(18)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Load current values from AppState
            editName  = appState.userName
            editEmail = appState.userEmail
            editPhone = appState.userPhone
        }
    }

    private func saveProfile() {
        guard !editName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        guard editEmail.contains("@") else { return }

        appState.updateProfile(
            name:  editName.trimmingCharacters(in: .whitespaces),
            email: editEmail.lowercased().trimmingCharacters(in: .whitespaces),
            phone: editPhone
        ) { error in
            if error == nil {
                withAnimation(.spring()) { showSavedBanner = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation { showSavedBanner = false }
                }
            }
        }
    }

    private func savePassword() {
        passwordError = ""
        passwordSuccess = false

        guard !currentPassword.isEmpty, !newPassword.isEmpty, !confirmPassword.isEmpty else {
            passwordError = "Please fill in all password fields."
            return
        }
        guard newPassword == confirmPassword else {
            passwordError = "New passwords do not match."
            return
        }

        appState.changePassword(current: currentPassword, newPass: newPassword) { error in
            if let error = error {
                passwordError = error
            } else {
                passwordSuccess = true
                currentPassword = ""
                newPassword = ""
                confirmPassword = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    passwordSuccess = false
                }
            }
        }
    }
}

// MARK: - Profile Input Field
struct ProfileInputField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(hex: "#6C6C70"))
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#8E8E93"))
                    .frame(width: 18)
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 13)
            .background(Color(hex: "#F5F0EB"))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "#E0DDD8"), lineWidth: 1))
        }
    }
}

// MARK: - Password Field
struct PasswordField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(hex: "#6C6C70"))
            HStack(spacing: 10) {
                Image(systemName: "lock")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#8E8E93"))
                    .frame(width: 18)
                if isVisible {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 14))
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                } else {
                    SecureField(placeholder, text: $text)
                        .font(.system(size: 14))
                }
                Button(action: { isVisible.toggle() }) {
                    Image(systemName: isVisible ? "eye.slash" : "eye")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "#8E8E93"))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 13)
            .background(Color(hex: "#F5F0EB"))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "#E0DDD8"), lineWidth: 1))
        }
    }
}

// MARK: - Notification Settings
struct NotificationSettingsView: View {

    @State private var newEventAnnouncements    = true
    @State private var moduleCompletionReminders = true
    @State private var achievementAlerts        = true
    @State private var weeklyProgressSummary    = false
    @State private var emailNotifications       = true
    @State private var pushNotifications        = false

    var body: some View {
        ZStack {
            Color(hex: "#F5F0EB").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {

                    HStack(spacing: 12) {
                        Image(systemName: "bell.badge.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color(hex: "#FF9500"))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Stay Updated")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                            Text("Choose which notifications you want to receive")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "#8E8E93"))
                        }
                        Spacer()
                    }
                    .padding(14)
                    .background(Color(hex: "#FF9500").opacity(0.08))
                    .cornerRadius(14)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    NotificationSection(title: "Activity", icon: "bell.fill", iconColor: Color(hex: "#FF9500")) {
                        NotificationToggleRow(label: "New Event Announcements",
                                             subtitle: "Get notified about upcoming TVET events",
                                             isOn: $newEventAnnouncements)
                        Divider().padding(.leading, 20)
                        NotificationToggleRow(label: "Module Completion Reminders",
                                             subtitle: "Reminders to complete your modules",
                                             isOn: $moduleCompletionReminders)
                        Divider().padding(.leading, 20)
                        NotificationToggleRow(label: "Achievement Unlocked Alerts",
                                             subtitle: "Celebrate when you earn a new achievement",
                                             isOn: $achievementAlerts)
                        Divider().padding(.leading, 20)
                        NotificationToggleRow(label: "Weekly Progress Summary",
                                             subtitle: "A weekly recap of your learning progress",
                                             isOn: $weeklyProgressSummary)
                    }
                    .padding(.horizontal, 20)

                    NotificationSection(title: "Communication", icon: "envelope.fill", iconColor: Color(hex: "#2196F3")) {
                        NotificationToggleRow(label: "Email Notifications",
                                             subtitle: "Receive updates via your registered email",
                                             isOn: $emailNotifications)
                        Divider().padding(.leading, 20)
                        NotificationToggleRow(label: "Push Notifications",
                                             subtitle: "Receive alerts directly on your device",
                                             isOn: $pushNotifications)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationSection<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(iconColor)
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "#1C1C1E"))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(iconColor.opacity(0.06))
            content
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
    }
}

struct NotificationToggleRow: View {
    let label: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "#1C1C1E"))
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "#8E8E93"))
                    .lineLimit(1)
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .tint(Color(hex: "#E8472A"))
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }
}

// MARK: - Help & Feedback
struct HelpFeedbackView: View {

    @State private var feedbackText = ""
    @State private var selectedCategory = "General"
    @State private var showSubmitted = false
    @State private var expandedFAQ: String? = nil

    let categories = ["General", "Bug Report", "Feature Request", "Course Content", "Technical Issue"]

    let faqs: [(q: String, a: String)] = [
        ("How do I unlock locked modules?",
         "Complete the previous module first. Modules are unlocked in sequence to ensure proper learning progression."),
        ("Why can't I play some games?",
         "Some games are still in development. They will be available soon — check back regularly!"),
        ("How is my XP calculated?",
         "XP is awarded based on game difficulty. Easy = 150 XP, Medium = 250 XP, Hard = 400 XP per game completed."),
        ("How do I change my password?",
         "Go to Settings → Profile → Change Password section. Enter your current password, then your new password twice."),
    ]

    var body: some View {
        ZStack {
            Color(hex: "#F5F0EB").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    // FAQ
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(Color(hex: "#2196F3"))
                            Text("Frequently Asked Questions")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                        }

                        VStack(spacing: 0) {
                            ForEach(faqs, id: \.q) { faq in
                                FAQRow(question: faq.q, answer: faq.a,
                                       isExpanded: expandedFAQ == faq.q) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        expandedFAQ = expandedFAQ == faq.q ? nil : faq.q
                                    }
                                }
                                if faq.q != faqs.last?.q {
                                    Divider().padding(.leading, 16)
                                }
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    // Contact
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "headphones.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(Color(hex: "#34C759"))
                            Text("Contact Support")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                        }
                        HStack(spacing: 12) {
                            ContactOptionButton(icon: "envelope.fill", label: "Email Us", color: Color(hex: "#E8472A"))
                            ContactOptionButton(icon: "message.fill", label: "Live Chat", color: Color(hex: "#2196F3"))
                            ContactOptionButton(icon: "phone.fill",   label: "Call Us",  color: Color(hex: "#34C759"))
                        }
                    }
                    .padding(.horizontal, 20)

                    // Feedback form
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "star.bubble.fill")
                                .font(.system(size: 18))
                                .foregroundColor(Color(hex: "#FF9500"))
                            Text("Send Feedback")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            // Category chips
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Category")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(hex: "#6C6C70"))
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(categories, id: \.self) { cat in
                                            Button(action: { selectedCategory = cat }) {
                                                Text(cat)
                                                    .font(.system(size: 12, weight: .semibold))
                                                    .foregroundColor(selectedCategory == cat ? .white : Color(hex: "#3C3C43"))
                                                    .padding(.horizontal, 14)
                                                    .padding(.vertical, 7)
                                                    .background(selectedCategory == cat ? Color(hex: "#E8472A") : Color(hex: "#F5F0EB"))
                                                    .cornerRadius(20)
                                            }
                                        }
                                    }
                                }
                            }

                            // Text input
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Your Feedback")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(hex: "#6C6C70"))
                                ZStack(alignment: .topLeading) {
                                    TextEditor(text: $feedbackText)
                                        .font(.system(size: 14))
                                        .frame(height: 110)
                                        .padding(10)
                                        .background(Color(hex: "#F5F0EB"))
                                        .cornerRadius(10)
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "#E0DDD8"), lineWidth: 1))
                                    if feedbackText.isEmpty {
                                        Text("Tell us what you think or report an issue...")
                                            .font(.system(size: 13))
                                            .foregroundColor(Color(hex: "#C7C7CC"))
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 18)
                                            .allowsHitTesting(false)
                                    }
                                }
                            }

                            Button(action: {
                                guard !feedbackText.isEmpty else { return }
                                withAnimation { showSubmitted = true }
                                feedbackText = ""
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    withAnimation { showSubmitted = false }
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: showSubmitted ? "checkmark" : "paperplane.fill")
                                        .font(.system(size: 13, weight: .bold))
                                    Text(showSubmitted ? "Feedback Sent!" : "Submit Feedback")
                                        .font(.system(size: 15, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(showSubmitted ? Color(hex: "#34C759") : Color(hex: "#E8472A"))
                                .cornerRadius(14)
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationTitle("Help & Feedback")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FAQRow: View {
    let question: String
    let answer: String
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    Text(question)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#1C1C1E"))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#8E8E93"))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            if isExpanded {
                Text(answer)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#6C6C70"))
                    .lineSpacing(3)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 14)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

struct ContactOptionButton: View {
    let icon: String
    let label: String
    let color: Color

    var body: some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                }
                Text(label)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(hex: "#3C3C43"))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
        }
    }
}

#Preview("Settings") { SettingsView(showSidebar: .constant(false)).environmentObject(AppState.shared) }
#Preview("Profile") { ProfileSettingsView().environmentObject(AppState.shared) }
#Preview("Notifications") { NotificationSettingsView() }
#Preview("Help") { HelpFeedbackView() }
