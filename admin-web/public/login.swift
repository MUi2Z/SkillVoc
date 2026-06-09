import SwiftUI

struct LoginView: View {
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
                
                // Graduation Cap Icon
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
                    gradient: Gradient(colors: [Color(hex: "1e293b"), Color(hex: "0f172a")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .ignoresSafeArea()
            
            // Right Side - White
            VStack(spacing: 0) {
                Spacer()
                
                // Logo
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
                
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome back")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Sign in to continue your learning journey")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 28)
                
                // Form
                VStack(spacing: 18) {
                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email Address")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        TextField("you@student.edu.my", text: $email)
                            .textFieldStyle(CustomTextFieldStyle())
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        SecureField("Enter your password", text: $password)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    // Remember Me & Forgot Password
                    HStack {
                        Toggle("Remember me", isOn: $rememberMe)
                            .toggleStyle(CheckboxToggleStyle())
                        
                        Spacer()
                        
                        Button("Forgot password?") {
                            // TODO: Implement forgot password
                            print("Forgot password clicked")
                        }
                        .foregroundColor(.orange)
                        .font(.subheadline)
                    }
                    .padding(.vertical, 8)
                    
                    // Error Message
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    // Sign In Button
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
                    
                    // Sign Up Link
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        
                        Button("Sign up free") {
                            // TODO: Navigate to signup
                            print("Navigate to signup")
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
        // Validate inputs
        if email.isEmpty || password.isEmpty {
            showError = true
            errorMessage = "Please fill in all fields"
            return
        }
        
        // Simple validation (replace with actual API call)
        if email.contains("@") && password.count >= 6 {
            // Login successful - navigate to dashboard
            print("Login successful with: \(email)")
            // TODO: Navigate to dashboard
        } else {
            showError = true
            errorMessage = "Invalid email or password"
        }
    }
}

// MARK: - Custom TextField Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}

// MARK: - Checkbox Toggle Style
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

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

// MARK: - Preview
#Preview {
    LoginView()
}