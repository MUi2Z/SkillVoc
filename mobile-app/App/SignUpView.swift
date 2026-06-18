import SwiftUI

struct SignUpView: View {

    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    @State private var fullName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var isLoading = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            Color(hex: "#F5F0EB").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    
                    heroBanner

                    
                    formSection
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Create Account")
    }



    private var heroBanner: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#0F172A"), Color(hex: "#1E293B")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(Color.white.opacity(0.04))
                .frame(width: 200, height: 200)
                .offset(x: -90, y: -40)
            Circle()
                .fill(Color.white.opacity(0.04))
                .frame(width: 140, height: 140)
                .offset(x: 110, y: 50)

            VStack(spacing: 14) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 86, height: 86)
                    .cornerRadius(18)
                    .shadow(color: Color(hex: "#E8472A").opacity(0.5), radius: 14, y: 6)

                VStack(spacing: 5) {
                    Text("Create Account")
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(.white)
                    Text("Join SkillVoc and start your\nTVET learning journey today.")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.65))
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                }
            }
            .padding(.vertical, 44)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Form Section

    private var formSection: some View {
        VStack(alignment: .leading, spacing: 0) {

            VStack(alignment: .leading, spacing: 4) {
                Text("Sign Up")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(Color(hex: "#1C1C1E"))
                Text("Fill in your details to create an account")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#8E8E93"))
            }
            .padding(.bottom, 24)

            // Full Name
            SignUpInputField(label: "Username", placeholder: "Enter your username",
                             text: $fullName, icon: "person")
            .padding(.bottom, 14)

            // Email
            SignUpInputField(label: "Email Address", placeholder: "you@gmail.com",
                             text: $email, icon: "envelope", keyboardType: .emailAddress)
            .padding(.bottom, 14)


            // Password
            VStack(alignment: .leading, spacing: 6) {
                Text("Password")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(hex: "#3C3C43"))
                HStack(spacing: 10) {
                    Image(systemName: "lock")
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "#8E8E93"))
                    if isPasswordVisible {
                        TextField("At least 6 characters", text: $password)
                            .font(.system(size: 15))
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    } else {
                        SecureField("At least 6 characters", text: $password)
                            .font(.system(size: 15))
                    }
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .font(.system(size: 15))
                            .foregroundColor(Color(hex: "#8E8E93"))
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#E0DDD8"), lineWidth: 1))
            }
            .padding(.bottom, 14)

            // Password strength
            if !password.isEmpty {
                PasswordStrengthView(password: password)
                    .padding(.bottom, 14)
            }

            // Error message
            if !errorMessage.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "#FF3B30"))
                    Text(errorMessage)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#FF3B30"))
                }
                .padding(12)
                .background(Color(hex: "#FF3B30").opacity(0.08))
                .cornerRadius(10)
                .padding(.bottom, 14)
            }

            // Create Account button
            Button(action: { handleSignUp() }) {
                HStack(spacing: 8) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.9)
                    }
                    Text(isLoading ? "Creating account..." : "Create Account")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(hex: "#E8472A"))
                .cornerRadius(14)
            }
            .disabled(isLoading)
            .padding(.bottom, 20)

            // Already have account
            HStack(spacing: 4) {
                Spacer()
                Text("Already have an account?")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#8E8E93"))
                Button(action: { dismiss() }) {
                    Text("Sign In")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(hex: "#E8472A"))
                }
                Spacer()
            }
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 24)
        .padding(.top, 28)
    }

    // MARK: - Sign Up Logic

    func handleSignUp() {
        errorMessage = ""

        guard !fullName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter your full name."
            return
        }
        guard !email.isEmpty, email.contains("@"), email.contains(".") else {
            errorMessage = "Please enter a valid email address."
            return
        }
        guard !password.isEmpty else {
            errorMessage = "Please enter a password."
            return
        }
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return
        }

        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            // Register dan auto-login terus
            appState.register(
                fullName: fullName.trimmed(),
                email:    email.lowercased().trimmed(),
                phone:    phone,
                password: password
            )
            isLoading = false
            // appState.isLoggedIn = true sudah dipanggil dalam register()
            // SkillVocApp akan detect dan tunjuk MainTabView automatik
        }
    }
}

// MARK: - Sign Up Input Field
struct SignUpInputField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(hex: "#3C3C43"))
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(Color(hex: "#8E8E93"))
                TextField(placeholder, text: $text)
                    .font(.system(size: 15))
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#E0DDD8"), lineWidth: 1))
        }
    }
}

// MARK: - Password Strength
struct PasswordStrengthView: View {
    let password: String

    private var strength: Int {
        var score = 0
        if password.count >= 6  { score += 1 }
        if password.count >= 10 { score += 1 }
        if password.contains(where: { $0.isUppercase }) { score += 1 }
        if password.contains(where: { $0.isNumber })    { score += 1 }
        return score
    }

    private var label: String {
        switch strength {
        case 0, 1: return "Weak"
        case 2:    return "Fair"
        case 3:    return "Good"
        default:   return "Strong"
        }
    }

    private var color: Color {
        switch strength {
        case 0, 1: return Color(hex: "#FF3B30")
        case 2:    return Color(hex: "#FF9500")
        case 3:    return Color(hex: "#34C759")
        default:   return Color(hex: "#007AFF")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Password strength:")
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "#8E8E93"))
                Text(label)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(color)
            }
            HStack(spacing: 4) {
                ForEach(0..<4, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(i < strength ? color : Color(hex: "#E0DDD8"))
                        .frame(height: 4)
                }
            }
        }
    }
}

private extension String {
    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

#Preview {
    SignUpView().environmentObject(AppState.shared)
}
