import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appState: AppState
    @State private var isActive = false

    var body: some View {
        if isActive {
            if appState.isLoggedIn {
                MainTabView()
                    .environmentObject(appState)
            } else {
                LoginView()
                    .environmentObject(appState)
            }
        } else {
            ZStack {
                Color(hex: "#F5F0EB").ignoresSafeArea()

                VStack(spacing: 15) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .cornerRadius(20)
                        .shadow(color: Color(hex: "#E8472A").opacity(0.5), radius: 16, y: 6)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
