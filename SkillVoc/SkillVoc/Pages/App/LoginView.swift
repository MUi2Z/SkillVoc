import SwiftUI

struct LoginView: View {

    @EnvironmentObject var appState: AppState

    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var errorMessage = ""
    @State private var showSignUp = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F5F0EB").ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        heroBanner
                        loginForm
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView().environmentObject(appState)
            }
        }
    }

    private var heroBanner: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#0F172A"), Color(hex: "#1E293B")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            Circle().fill(Color.white.opacity(0.04)).frame(width: 220, height: 220).offset(x: -100, y: -50)
            Circle().fill(Color.white.opacity(0.04)).frame(width: 160, height: 160).offset(x: 120, y: 60)

            VStack(spacing: 16) {
                Image("logo")
                    .resizable().scaledToFit().frame(width: 90, height: 90)
                    .cornerRadius(20)
                    .shadow(color: Color(hex: "#E8472A").opacity(0.5), radius: 16, y: 6)

                VStack(spacing: 6) {
                    Text("Welcome to SkillVoc")
                        .font(.system(size: 22, weight: .black)).foregroundColor(.white)
                    Text("The modern TVET learning platform.")
                        .font(.system(size: 13)).foregroundColor(.white.opacity(0.65))
                }
            }
            .padding(.vertical, 50)
        }
        .frame(maxWidth: .infinity)
    }

    private var loginForm: some View {
        VStack(alignment: .leading, spacing: 0) {

            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back")
                    .font(.system(size: 24, weight: .black)).foregroundColor(Color(hex: "#1C1C1E"))
                Text("Sign in to continue your learning journey")
                    .font(.system(size: 13)).foregroundColor(Color(hex: "#8E8E93"))
            }
            .padding(.bottom, 28)

            VStack(alignment: .leading, spacing: 6) {
                Text("Email Address").font(.system(size: 13, weight: .semibold)).foregroundColor(Color(hex: "#3C3C43"))
                HStack(spacing: 10) {
                    Image(systemName: "envelope").font(.system(size: 15)).foregroundColor(Color(hex: "#8E8E93"))
                    TextField("you@gmail.my", text: $email)
                        .font(.system(size: 15)).keyboardType(.emailAddress)
                        .autocapitalization(.none).autocorrectionDisabled()
                }
                .padding(.horizontal, 14).padding(.vertical, 14)
                .background(Color.white).cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#E0DDD8"), lineWidth: 1))
            }
            .padding(.bottom, 14)

            VStack(alignment: .leading, spacing: 6) {
                Text("Password").font(.system(size: 13, weight: .semibold)).foregroundColor(Color(hex: "#3C3C43"))
                HStack(spacing: 10) {
                    Image(systemName: "lock").font(.system(size: 15)).foregroundColor(Color(hex: "#8E8E93"))
                    if isPasswordVisible {
                        TextField("Enter your password", text: $password)
                            .font(.system(size: 15)).autocapitalization(.none).autocorrectionDisabled()
                    } else {
                        SecureField("Enter your password", text: $password).font(.system(size: 15))
                    }
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .font(.system(size: 15)).foregroundColor(Color(hex: "#8E8E93"))
                    }
                }
                .padding(.horizontal, 14).padding(.vertical, 14)
                .background(Color.white).cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#E0DDD8"), lineWidth: 1))
            }
            .padding(.bottom, 14)

            if !errorMessage.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.circle.fill").font(.system(size: 13)).foregroundColor(Color(hex: "#FF3B30"))
                    Text(errorMessage).font(.system(size: 12)).foregroundColor(Color(hex: "#FF3B30"))
                }
                .padding(12).background(Color(hex: "#FF3B30").opacity(0.08)).cornerRadius(10)
                .padding(.bottom, 14)
            }

            Button(action: { handleLogin() }) {
                HStack {
                    if appState.isLoading {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white)).scaleEffect(0.9)
                    }
                    Text(appState.isLoading ? "Signing in..." : "Sign In")
                        .font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                }
                .frame(maxWidth: .infinity).padding(.vertical, 16)
                .background(Color(hex: "#E8472A")).cornerRadius(14)
            }
            .disabled(appState.isLoading)
            .padding(.bottom, 24)

            HStack(spacing: 4) {
                Spacer()
                Text("Don't have an account?").font(.system(size: 13)).foregroundColor(Color(hex: "#8E8E93"))
                Button(action: { showSignUp = true }) {
                    Text("Sign up free").font(.system(size: 13, weight: .bold)).foregroundColor(Color(hex: "#E8472A"))
                }
                Spacer()
            }
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 24).padding(.top, 28)
    }

    private func handleLogin() {
        errorMessage = ""
        guard !email.isEmpty else { errorMessage = "Please enter your email address."; return }
        guard !password.isEmpty else { errorMessage = "Please enter your password."; return }

        appState.login(email: email, password: password) { error in
            if let error = error {
                errorMessage = error
            }
        }
    }
}
