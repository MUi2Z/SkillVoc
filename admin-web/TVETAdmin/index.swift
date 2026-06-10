import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var showNotifications = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(spacing: 0) {
                // Sidebar
                SidebarView()
                    .frame(width: appState.compactSidebar ? 90 : 260)
                    .background(Color(red: 0.12, green: 0.16, blue: 0.23))
                
                // Main Content
                VStack(spacing: 0) {
                    TopHeaderView(searchText: $searchText, showNotifications: $showNotifications)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(appState.darkMode ? Color(red: 0.1, green: 0.1, blue: 0.12) : Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                    
                    ScrollView {
                        DashboardContent()
                    }
                    .background(appState.darkMode ? Color(red: 0.08, green: 0.09, blue: 0.11) : Color(red: 0.94, green: 0.95, blue: 0.96))
                }
            }
            .frame(minWidth: 1000, minHeight: 700)
            .animation(appState.animatedTransitions ? .easeInOut(duration: 0.3) : .none, value: appState.compactSidebar)
            
            // Notification Dropdown - At TOP LEVEL to float above everything
            if showNotifications {
                NotificationDropdownView(isPresented: $showNotifications)
                    .padding(.top, 80)
                    .padding(.trailing, 60)
                    .zIndex(9999)
                    .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

// MARK: - Dashboard Content
struct DashboardContent: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Dashboard Overview")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(appState.darkMode ? .white : .primary)
                Text("Welcome back, Admin. Here's what's happening with TVET Mastermind today.")
                    .foregroundColor(appState.darkMode ? .gray : .secondary)
            }
            .padding(.top, 30)
            .padding(.horizontal, 40)
            
            // Stats Grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
                StatCard(title: "Total Students", value: "1,248", icon: "person.3.fill", trend: "↑ 12% from last month", trendUp: true)
                StatCard(title: "Active Modules", value: "42", icon: "book.fill", trend: "↑ 3 new this week", trendUp: true)
                StatCard(title: "Available Games", value: "18", icon: "gamecontroller.fill", trend: "↓ 2 pending review", trendUp: false)
                StatCard(title: "Completed Lessons", value: "856", icon: "checkmark.circle.fill", trend: "↑ 24% this week", trendUp: true)
            }
            .padding(.horizontal, 40)
            
            HStack(alignment: .top, spacing: 24) {
                RecentStudentsCard()
                    .frame(maxWidth: .infinity)
                RecentActivityCard()
                    .frame(width: 350)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    @EnvironmentObject var appState: AppState
    let title: String
    let value: String
    let icon: String
    let trend: String
    let trendUp: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 8).fill(Color.orange.opacity(0.1)).frame(width: 40, height: 40)
                Image(systemName: icon).foregroundColor(.orange)
            }
            Text(value).font(.system(size: 28, weight: .bold)).foregroundColor(appState.darkMode ? .white : .primary)
            Text(title).font(.system(size: 14, weight: .medium)).foregroundColor(appState.darkMode ? .gray : .secondary)
            Text(trend).font(.system(size: 12)).foregroundColor(trendUp ? .green : .red).padding(.top, 4)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
    }
}

// MARK: - Recent Students
struct RecentStudentsCard: View {
    @EnvironmentObject var appState: AppState
    let students = [
        ("Ahmad Naufal", "ahmad.naufal@student.edu.my", "Active", true),
        ("Siti Aminah", "siti.aminah@student.edu.my", "Pending", false),
        ("Muhammad Ali", "m.ali@student.edu.my", "Active", true),
        ("Nurul Izzah", "nurul.izzah@student.edu.my", "Active", true)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Recent Student Registrations").font(.system(size: 18, weight: .bold)).foregroundColor(appState.darkMode ? .white : .primary)
                Spacer()
                Button("View All →") {}
                    .foregroundColor(.orange)
                    .font(.system(size: 14, weight: .semibold))
            }
            
            HStack {
                Text("Name").frame(maxWidth: .infinity, alignment: .leading)
                Text("Email").frame(maxWidth: .infinity, alignment: .leading)
                Text("Status").frame(width: 80, alignment: .leading)
            }
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(appState.darkMode ? .gray : .secondary)
            .textCase(.uppercase)
            .padding(.bottom, 10)
            
            ForEach(students, id: \.0) { student in
                HStack {
                    Text(student.0).frame(maxWidth: .infinity, alignment: .leading).foregroundColor(appState.darkMode ? .white : .primary)
                    Text(student.1).frame(maxWidth: .infinity, alignment: .leading).foregroundColor(appState.darkMode ? .gray : .secondary)
                    Text(student.2)
                        .font(.system(size: 12, weight: .semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(student.3 ? Color.green.opacity(0.1) : Color.orange.opacity(0.1))
                        .foregroundColor(student.3 ? .green : .orange)
                        .cornerRadius(20)
                        .frame(width: 80, alignment: .leading)
                }
                .padding(.vertical, 12)
                Divider().background(appState.darkMode ? Color.gray.opacity(0.3) : Color.gray.opacity(0.2))
            }
        }
        .padding(28)
        .background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
    }
}

// MARK: - Recent Activity
struct RecentActivityCard: View {
    @EnvironmentObject var appState: AppState
    let activities = [
        ("New module \"Web Dev Basics\" was published.", "2 hours ago"),
        ("User Siti Aminah completed \"Intro to Coding\".", "4 hours ago"),
        ("System backup completed successfully.", "Yesterday"),
        ("New game \"Code Quest\" added to library.", "2 days ago")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Recent Activity").font(.system(size: 18, weight: .bold)).foregroundColor(appState.darkMode ? .white : .primary)
            
            ForEach(activities, id: \.0) { activity in
                HStack(alignment: .top, spacing: 15) {
                    Circle().fill(Color.orange).frame(width: 8, height: 8).padding(.top, 6)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(activity.0).font(.system(size: 14)).foregroundColor(appState.darkMode ? .white : .primary)
                        Text(activity.1).font(.system(size: 12)).foregroundColor(appState.darkMode ? .gray : .secondary)
                    }
                    Spacer()
                }
                Divider().background(appState.darkMode ? Color.gray.opacity(0.3) : Color.gray.opacity(0.2))
            }
        }
        .padding(28)
        .background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
    }
}

// MARK: - Sidebar
struct SidebarView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.orange)
                    .frame(width: 48, height: 48)
                    .overlay(Text("TM").font(.system(size: 24, weight: .bold)).foregroundColor(.white))
                
                if !appState.compactSidebar {
                    Text("TVET")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .transition(.opacity)
                }
            }
            .padding(.vertical, 30)
            .padding(.horizontal, appState.compactSidebar ? 10 : 20)
            
            VStack(alignment: appState.compactSidebar ? .center : .leading, spacing: 5) {
                SidebarLink(icon: "house.fill", text: "Home", isActive: appState.currentView == .dashboard, compact: appState.compactSidebar) {
                    appState.navigate(to: .dashboard)
                }
                SidebarLink(icon: "book.fill", text: "Modules", isActive: appState.currentView == .modules, compact: appState.compactSidebar) {
                    appState.navigate(to: .modules)
                }
                SidebarLink(icon: "gamecontroller.fill", text: "Games", isActive: appState.currentView == .games, compact: appState.compactSidebar) {
                    appState.navigate(to: .games)
                }
                SidebarLink(icon: "calendar", text: "Calendar", isActive: appState.currentView == .calendar, compact: appState.compactSidebar) {
                    appState.navigate(to: .calendar)
                }
                SidebarLink(icon: "person.fill", text: "Profile", isActive: appState.currentView == .profile, compact: appState.compactSidebar) {
                    appState.navigate(to: .profile)
                }
                SidebarLink(icon: "gearshape.fill", text: "Settings", isActive: appState.currentView == .settings, compact: appState.compactSidebar) {
                    appState.navigate(to: .settings)
                }
            }
            .padding(.horizontal, 10)
            
            Spacer()
            
            SidebarLink(icon: "rectangle.portrait.and.arrow.right", text: "Logout", isActive: false, isLogout: true, compact: appState.compactSidebar) {
                appState.logout()
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 20)
        }
    }
}

struct SidebarLink: View {
    @EnvironmentObject var appState: AppState
    let icon: String
    let text: String
    let isActive: Bool
    var isLogout: Bool = false
    var compact: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon).frame(width: 22, height: 22)
                
                if !compact {
                    Text(text).font(.system(size: 15, weight: .medium))
                        .transition(.opacity)
                    Spacer()
                }
            }
            .foregroundColor(isLogout ? .red : (isActive ? .white : Color(red: 0.8, green: 0.84, blue: 0.89)))
            .padding(.vertical, 14)
            .padding(.horizontal, compact ? 10 : 20)
            .frame(maxWidth: compact ? nil : .infinity, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 8).fill(isActive ? Color.orange : Color.clear))
        }
        .buttonStyle(PlainButtonStyle())
        .animation(appState.animatedTransitions ? .easeInOut(duration: 0.2) : .none, value: compact)
    }
}

// MARK: - Top Header (Simplified - no dropdown here anymore)
struct TopHeaderView: View {
    @Binding var searchText: String
    @Binding var showNotifications: Bool
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.orange)
                    .frame(width: 48, height: 48)
                    .overlay(Text("TM").font(.system(size: 24, weight: .bold)).foregroundColor(.white))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("TVET Mastermind").font(.system(size: 20, weight: .bold)).foregroundColor(appState.darkMode ? .white : .primary)
                    Text("Learning Portal").font(.system(size: 14)).foregroundColor(.orange)
                }
            }
            Spacer()
            
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Search...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(appState.darkMode ? .white : .primary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .frame(maxWidth: 600)
            .background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color(red: 0.97, green: 0.98, blue: 0.99))
            .cornerRadius(12)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showNotifications.toggle()
                }
            }) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bell")
                        .font(.system(size: 22))
                        .foregroundColor(appState.darkMode ? .white : .gray)
                        .frame(width: 44, height: 44)
                        .background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color(red: 0.97, green: 0.98, blue: 0.99))
                        .cornerRadius(12)
                    
                    if appState.unreadCount > 0 {
                        Text("\(appState.unreadCount)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.red)
                            .clipShape(Circle())
                            .offset(x: 8, y: -6)
                    }
                }
            }
        }
    }
}

// MARK: - Notification Dropdown
struct NotificationDropdownView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("Notifications")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(appState.darkMode ? .white : .primary)
                Spacer()
                if appState.unreadCount > 0 {
                    Button(action: { appState.markAllAsRead() }) {
                        Text("Mark all read")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.orange)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
            .background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color(red: 0.97, green: 0.98, blue: 0.99))
            
            Divider()
            
            // List
            if appState.notifications.isEmpty {
                Text("No notifications")
                    .foregroundColor(.gray)
                    .padding(30)
                    .frame(maxWidth: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(appState.notifications) { notification in
                            NotificationRow(notification: notification)
                                .onTapGesture {
                                    appState.markAsRead(id: notification.id)
                                }
                            
                            if notification.id != appState.notifications.last?.id {
                                Divider()
                            }
                        }
                    }
                }
                .frame(maxHeight: 300)
            }
            
            // Footer
            if !appState.notifications.isEmpty {
                Divider()
                HStack {
                    Button(action: { appState.clearAll() }) {
                        Text("Clear all")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button(action: { print("View all") }) {
                        Text("View all")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.orange)
                    }
                    .buttonStyle(.plain)
                }
                .padding(12)
                .background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color(red: 0.97, green: 0.98, blue: 0.99))
            }
        }
        .frame(width: 350)
        .background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

struct NotificationRow: View {
    @EnvironmentObject var appState: AppState
    let notification: Notification
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(notification.isRead ? Color.clear : Color.orange)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .font(.system(size: 14, weight: notification.isRead ? .regular : .semibold))
                    .foregroundColor(appState.darkMode ? .white : (notification.isRead ? .gray : .primary))
                
                Text(notification.message)
                    .font(.system(size: 13))
                    .foregroundColor(appState.darkMode ? .gray : .secondary)
                    .lineLimit(2)
                
                Text(notification.time)
                    .font(.system(size: 11))
                    .foregroundColor(appState.darkMode ? .gray : .secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(notification.isRead ? (appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color.white) : Color(red: 0.97, green: 0.98, blue: 0.99))
    }
}

#Preview {
    DashboardView()
        .environmentObject(AppState())
}
