import SwiftUI

struct MainTabView: View {

    @EnvironmentObject var appState: AppState
    @State private var selectedPage: String = "Home"
    @State private var showSidebar: Bool = false
    @State private var showLogoutConfirm: Bool = false
    @State private var showNotifications: Bool = false

    var body: some View {
        ZStack {

            
            NavigationStack {
                currentScreenView
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    showSidebar.toggle()
                                }
                            }) {
                                Image(systemName: "line.3.horizontal")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(Color(hex: "#1C1C1E"))
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: { showNotifications = true }) {
                                Image(systemName: "bell")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(hex: "#1C1C1E"))
                            }
                        }
                    }
                    .navigationDestination(isPresented: $showNotifications) {
                        NotificationsView()
                    }
            }

            if showSidebar {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            showSidebar = false
                        }
                    }
            }

            HStack(spacing: 0) {
                SidebarView(
                    selectedPage: $selectedPage,
                    showSidebar: $showSidebar,
                    onLogout: { showLogoutConfirm = true }
                )
                .frame(width: 280)
                .offset(x: showSidebar ? 0 : -280)
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showSidebar)
                Spacer()
            }
            .ignoresSafeArea()

            if showLogoutConfirm {
                logoutConfirmOverlay
            }
        }
    }

    @ViewBuilder
    private var currentScreenView: some View {
        if selectedPage == "Home" {
            HomeView(showSidebar: $showSidebar)
                .environmentObject(appState)
        } else if selectedPage == "Modules" {
            ModulesView(showSidebar: $showSidebar)
                .environmentObject(appState)
        } else if selectedPage == "Games" {
            GamesView(showSidebar: $showSidebar)
        } else if selectedPage == "Calendar" {
            CalendarView(showSidebar: $showSidebar)
        } else if selectedPage == "Settings" {
            SettingsView(showSidebar: $showSidebar)
                .environmentObject(appState)
        } else {
            HomeView(showSidebar: $showSidebar)
                .environmentObject(appState)
        }
    }

    
    private var logoutConfirmOverlay: some View {
        ZStack {
            Color.black.opacity(0.45).ignoresSafeArea()

            VStack(spacing: 20) {

                ZStack {
                    Circle()
                        .fill(Color(hex: "#E8472A").opacity(0.12))
                        .frame(width: 60, height: 60)
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 26))
                        .foregroundColor(Color(hex: "#E8472A"))
                }

                VStack(spacing: 6) {
                    Text("Log Out")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "#1C1C1E"))
                    Text("Are you sure you want to log out?")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "#8E8E93"))
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 10) {
                    Button(action: {
                        showLogoutConfirm = false
                        showSidebar = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            appState.logout()
                        }
                    }) {
                        Text("Yes, Log Out")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(hex: "#E8472A"))
                            .cornerRadius(14)
                    }

                    Button(action: { showLogoutConfirm = false }) {
                        Text("Cancel")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color(hex: "#3C3C43"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(hex: "#F5F0EB"))
                            .cornerRadius(14)
                    }
                }
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(24)
            .padding(.horizontal, 36)
        }
    }
}

struct SidebarView: View {

    @Binding var selectedPage: String
    @Binding var showSidebar: Bool
    var onLogout: () -> Void

    let menuItems: [(icon: String, label: String)] = [
        ("house.fill",       "Home"),
        ("square.grid.2x2",  "Modules"),
        ("gamecontroller",   "Games"),
        ("calendar",         "Calendar"),
        ("gear",             "Settings"),
    ]

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                // Logo
                HStack(spacing: 12) {
                    Image("skillvoc_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .cornerRadius(10)
                    Text("SkillVoc")
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(Color(hex: "#1C1C1E"))
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 32)

                // Menu items
                VStack(spacing: 4) {
                    ForEach(menuItems, id: \.label) { item in
                        SidebarMenuItem(
                            icon: item.icon,
                            label: item.label,
                            isSelected: selectedPage == item.label
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedPage = item.label
                                showSidebar = false
                            }
                        }
                    }
                }
                .padding(.horizontal, 14)

                Spacer()

                // Log Out button
                Divider().padding(.horizontal, 24).padding(.bottom, 12)

                Button(action: onLogout) {
                    HStack(spacing: 14) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 18))
                            .foregroundColor(Color(hex: "#E8472A"))
                            .frame(width: 24)
                        Text("Log Out")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#E8472A"))
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                }

                Spacer().frame(height: 30)
            }
        }
        .shadow(color: Color.black.opacity(0.15), radius: 20, x: 5, y: 0)
    }
}

struct SidebarMenuItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(isSelected ? Color(hex: "#E8472A") : Color(hex: "#8E8E93"))
                    .frame(width: 24)
                Text(label)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? Color(hex: "#E8472A") : Color(hex: "#3C3C43"))
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(isSelected ? Color(hex: "#E8472A").opacity(0.08) : Color.clear)
            .cornerRadius(12)
            .overlay(
                HStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(hex: "#E8472A"))
                            .frame(width: 3)
                    }
                    Spacer()
                },
                alignment: .leading
            )
        }
    }
}

#Preview { MainTabView().environmentObject(AppState.shared) }
