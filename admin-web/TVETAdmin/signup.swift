import SwiftUI

struct SignupView: View {
    // Form States
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreeToTerms = false
    
    // UI States
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
                
                Text("Join TVET Mastermind")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("Start your vocational and technical education journey today. Access interactive modules, track your progress, and earn achievements.")
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
            VStack(alignment: .leading, spacing: 0) {
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
                    Text("Create account")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Start your learning journey with us")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 28)
                
                // Form
                VStack(spacing: 18) {
                    // First & Last Name (Side by Side)
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("First Name")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                            TextField("Ahmad", text: $firstName)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Last Name")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                            TextField("Naufal", text: $lastName)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    
                    // Email
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email Address")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        TextField("you@student.edu.my", text: $email)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // Phone
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phone Number")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        TextField("+60 12-345 6789", text: $phone)
                            .textFieldStyle(.roundedBorder)

                    }
                    
                    // Password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        SecureField("At least 8 characters", text: $password)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // Confirm Password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirm Password")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        SecureField("Re-enter your password", text: $confirmPassword)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // Terms Checkbox
                    Toggle(isOn: $agreeToTerms) {
                        Text("I agree to the ")
                            .foregroundColor(.gray) +
                        Text("Terms of Service")
                            .foregroundColor(.orange) +
                        Text(" and ")
                            .foregroundColor(.gray) +
                        Text("Privacy Policy")
                            .foregroundColor(.orange)
                    }
                    .toggleStyle(.checkbox) // Uses native macOS checkbox style
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
                    
                    // Sign Up Button
                    Button(action: handleSignup) {
                        Text("Create Account")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.orange)
                            .cornerRadius(8)
                    }
                    
                    // Sign In Link
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        
                        Button("Sign in") {
                            print("Navigate to Login")
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
    
    private func handleSignup() {
        // Basic Validation
        if password != confirmPassword {
            showError = true
            errorMessage = "Passwords do not match"
            return
        }
        
        if password.count < 8 {
            showError = true
            errorMessage = "Password must be at least 8 characters"
            return
        }
        
        if !agreeToTerms {
            showError = true
            errorMessage = "Please agree to the terms and conditions"
            return
        }
        
        // If valid
        showError = false
        print("Account created for: \(firstName) \(lastName)")
        // TODO: Add navigation to login or dashboard
    }
}

// MARK: - Preview
#Preview {
    SignupView()
}
