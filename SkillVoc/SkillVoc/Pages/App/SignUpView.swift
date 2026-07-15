import SwiftUI

struct SignUpView: View {

    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
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
            LinearGradient(colors: [Color(hex: "#0F172A"), Color(hex: "#1E293B")], startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack(spacing: 14) {
                Image("logo")
                    .resizable().scaledToFit().frame(width: 86, height: 86).cornerRadius(18)
                    .shadow(color: Color(hex: "#E8472A").opacity(0.5), radius: 14, y: 6)
                VStack(spacing: 5) {
                    Text("Create Account").font(.system(size: 22, weight: .black)).foregroundColor(.white)
                    Text("Join SkillVoc and start your TVET journey.")
                        .font(.system(size: 13)).foregroundColor(.white.opacity(0.65)).multilineTextAlignment(.center)
                }
            }
            .padding(.vertical, 44)
        }
        .frame(maxWidth: .infinity)
    }

    private var formSection: some View {
        VStack(alignment: .leading, spacing: 0) {

            VStack(alignment: .leading, spacing: 4) {
                Text("Sign Up").font(.system(size: 24, weight: .black)).foregroundColor(Color(hex: "#1C1C1E"))
                Text("Fill in your details to create an account")
                    .font(.system(size: 13)).foregroundColor(Color(hex: "#8E8E93"))
            }
            .padding(.bottom, 24)

            inputField(label: "Username", placeholder: "Enter your Username", text: $fullName, icon: "person")
                .padding(.bottom, 14)
            inputField(label: "Email Address", placeholder: "you@gmail.my", text: $email, icon: "envelope", keyboard: .emailAddress)
                .padding(.bottom, 14)

            VStack(alignment: .leading, spacing: 6) {
                Text("Password").font(.system(size: 13, weight: .semibold)).foregroundColor(Color(hex: "#3C3C43"))
                HStack(spacing: 10) {
                    Image(systemName: "lock").font(.system(size: 15)).foregroundColor(Color(hex: "#8E8E93"))
                    if isPasswordVisible {
                        TextField("At least 6 characters", text: $password).font(.system(size: 15)).autocapitalization(.none).autocorrectionDisabled()
                    } else {
                        SecureField("At least 6 characters", text: $password).font(.system(size: 15))
                    }
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye").font(.system(size: 15)).foregroundColor(Color(hex: "#8E8E93"))
                    }
                }
                .padding(.horizontal, 14).padding(.vertical, 14).background(Color.white).cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#E0DDD8"), lineWidth: 1))
            }
            .padding(.bottom, 14)

            if !password.isEmpty {
                passwordStrength.padding(.bottom, 14)
            }

            if !errorMessage.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.circle.fill").font(.system(size: 13)).foregroundColor(Color(hex: "#FF3B30"))
                    Text(errorMessage).font(.system(size: 12)).foregroundColor(Color(hex: "#FF3B30"))
                }
                .padding(12).background(Color(hex: "#FF3B30").opacity(0.08)).cornerRadius(10)
                .padding(.bottom, 14)
            }

            Button(action: { handleSignUp() }) {
                HStack {
                    if appState.isLoading {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white)).scaleEffect(0.9)
                    }
                    Text(appState.isLoading ? "Creating account..." : "Create Account")
                        .font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                }
                .frame(maxWidth: .infinity).padding(.vertical, 16)
                .background(Color(hex: "#E8472A")).cornerRadius(14)
            }
            .disabled(appState.isLoading)
            .padding(.bottom, 20)

            HStack(spacing: 4) {
                Spacer()
                Text("Already have an account?").font(.system(size: 13)).foregroundColor(Color(hex: "#8E8E93"))
                Button(action: { dismiss() }) {
                    Text("Sign In").font(.system(size: 13, weight: .bold)).foregroundColor(Color(hex: "#E8472A"))
                }
                Spacer()
            }
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 24).padding(.top, 28)
    }

    @ViewBuilder
    private func inputField(label: String, placeholder: String, text: Binding<String>, icon: String, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.system(size: 13, weight: .semibold)).foregroundColor(Color(hex: "#3C3C43"))
            HStack(spacing: 10) {
                Image(systemName: icon).font(.system(size: 15)).foregroundColor(Color(hex: "#8E8E93"))
                TextField(placeholder, text: text).font(.system(size: 15)).keyboardType(keyboard).autocapitalization(.none).autocorrectionDisabled()
            }
            .padding(.horizontal, 14).padding(.vertical, 14).background(Color.white).cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#E0DDD8"), lineWidth: 1))
        }
    }

    private var passwordStrength: some View {
        let score: Int = {
            var s = 0
            if password.count >= 6 { s += 1 }
            if password.count >= 10 { s += 1 }
            if password.contains(where: { $0.isUppercase }) { s += 1 }
            if password.contains(where: { $0.isNumber }) { s += 1 }
            return s
        }()
        let label = ["Weak", "Weak", "Fair", "Good", "Strong"][score]
        let color = [Color(hex: "#FF3B30"), Color(hex: "#FF3B30"), Color(hex: "#FF9500"), Color(hex: "#34C759"), Color(hex: "#007AFF")][score]

        return VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Password strength:").font(.system(size: 11)).foregroundColor(Color(hex: "#8E8E93"))
                Text(label).font(.system(size: 11, weight: .bold)).foregroundColor(color)
            }
            HStack(spacing: 4) {
                ForEach(0..<4, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 2).fill(i < score ? color : Color(hex: "#E0DDD8")).frame(height: 4)
                }
            }
        }
    }

    private func handleSignUp() {
        errorMessage = ""
        guard !fullName.trimmingCharacters(in: .whitespaces).isEmpty else { errorMessage = "Please enter your full name."; return }
        guard !email.isEmpty, email.contains("@") else { errorMessage = "Please enter a valid email address."; return }
        guard password.count >= 6 else { errorMessage = "Password must be at least 6 characters."; return }

        // Hantar string kosong untuk phone kerana API register memerlukan String
        appState.register(fullName: fullName.trimmingCharacters(in: .whitespaces), email: email, phone: "", password: password) { error in
            if let error = error {
                errorMessage = error
            }
        }
    }
}
