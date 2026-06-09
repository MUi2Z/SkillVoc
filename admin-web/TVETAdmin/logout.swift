import SwiftUI
import Combine

struct LogoutView: View {
    // Countdown state
    @State private var secondsRemaining = 10
    // Timer publisher to update the countdown every second
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.94, green: 0.95, blue: 0.97)
                .ignoresSafeArea()
            
            // Main Card
            VStack(spacing: 24) {
                
                // Logout Icon
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 90, height: 90)
                    
                    Image(systemName: "rectangle.portrait.and.arrow.forward")
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(.orange)
                }
                .padding(.top, 20)
                
                // Title
                Text("You Have Been Logged Out")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                
                // Subtitle
                Text("Thank you for using TVET Mastermind. Your session has been ended successfully. We hope to see you again soon!")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                // Buttons
                HStack(spacing: 16) {
                    // Back to Login Button
                    Button(action: {
                        print("Navigate to Login")
                        // TODO: Add navigation logic here
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("Back to Login")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.orange)
                        .cornerRadius(8)
                    }
                    
                    // Cancel Button
                    Button(action: {
                        print("Cancel clicked - stay here")
                    }) {
                        Text("Cancel")
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(red: 0.94, green: 0.95, blue: 0.97))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 10)
                
                // Divider
                Divider()
                    .padding(.horizontal, 40)
                
                // Countdown Text
                HStack(spacing: 4) {
                    Text("Redirecting to login page in")
                        .foregroundColor(.gray)
                    Text("\(secondsRemaining)")
                        .foregroundColor(.orange)
                        .fontWeight(.bold)
                    Text("seconds...")
                        .foregroundColor(.gray)
                }
                .font(.system(size: 14))
                .padding(.bottom, 20)
            }
            .padding(40)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
            .frame(maxWidth: 600)
        }
        // Update the timer every second
        .onReceive(timer) { _ in
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                // Timer reached 0, navigate to login
                print("Time's up! Navigating to Login...")
                // TODO: Add navigation logic here
                timer.upstream.connect().cancel() // Stop the timer
            }
        }
    }
}

// MARK: - Preview
#Preview {
    LogoutView()
}