import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        HStack(spacing: 0) {
            // Left Side - Dark Blue
            VStack(spacing: 20) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 120, height: 120)
                        .shadow(color: .orange.opacity(0.3), radius: 10, x: 0, y: 10)
                    
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                }
                
                Text("Welcome to TVET Mastermind")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("The modern learning platform for vocational and technical education. Learn through modules and master skills through interactive games.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.12, green: 0.16, blue: 0.23), Color(red: 0.06, green: 0.09, blue: 0.15)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .ignoresSafeArea()
            
            // Right Side - White
            VStack(spacing: 0) {
                Spacer()
                
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.orange)
                            .frame(width: 48, height: 48)
                        
                        Text("TM")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Text("TVET Mastermind")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.bottom, 30)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome back")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Sign in to continue your learning journey")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 28)
                
                VStack(spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email Address")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        TextField("you@student.edu.my", text: $email)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        SecureField("Enter your password", text: $password)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    HStack {
                        Toggle("Remember me", isOn: $rememberMe)
                            .toggleStyle(CheckboxToggleStyle())
                        
                        Spacer()
                        
                        Button("Forgot password?") {
                            print("Forgot password clicked")
                        }
                        .foregroundColor(.orange)
                        .font(.subheadline)
                    }
                    .padding(.vertical, 8)
                    
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    Button(action: handleLogin) {
                        Text("Sign In")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.orange)
                            .cornerRadius(8)
                    }
                    
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        
                        Button("Sign up free") {
                            appState.navigate(to: .signup)
                        }
                        .foregroundColor(.orange)
                        .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                    .padding(.top, 8)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 60)
            .padding(.vertical, 60)
            .background(Color.white)
        }
        .frame(minWidth: 1000, minHeight: 700)
    }
    
    private func handleLogin() {
        if email.isEmpty || password.isEmpty {
            showError = true
            errorMessage = "Please fill in all fields"
            return
        }
        
        if email.contains("@") && password.count >= 6 {
            print("Login successful with: \(email)")
            appState.login()
        } else {
            showError = true
            errorMessage = "Invalid email or password"
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack(spacing: 10) {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? .orange : .gray)
                    .font(.system(size: 20))
                
                configuration.label
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    LoginView()
        .environmentObject(AppState())
}
