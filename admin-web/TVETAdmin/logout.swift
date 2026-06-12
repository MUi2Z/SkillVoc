import SwiftUI

struct LogoutView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Color(red: 0.94, green: 0.95, blue: 0.96).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.orange)
                
                Text("You have been logged out")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Thank you for using SkillVoc")
                    .foregroundColor(.gray)
                
                Button(action: {
                    appState.navigate(to: .login)
                }) {
                    Text("Sign In Again")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color.orange)
                        .cornerRadius(8)
                }
                .padding(.top, 20)
                
                Spacer()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                appState.navigate(to: .login)
            }
        }
    }
}

#Preview {
    LogoutView()
        .environmentObject(AppState())
}
