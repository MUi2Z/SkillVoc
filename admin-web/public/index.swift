import SwiftUI

struct DashboardView: View {
    @State private var searchText = ""
    
    var body: some View {
        HStack(spacing: 0) {
            // Sidebar
            SidebarView()
                .frame(width: 260)
                .background(Color(red: 0.12, green: 0.16, blue: 0.23))
            
            // Main Content
            VStack(spacing: 0) {
                // Top Header
                TopHeaderView(searchText: $searchText)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                
                // Scrollable Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // Page Header
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Dashboard Overview")
                                .font(.system(size: 28, weight: .bold))
                            Text("Welcome back, Admin. Here's what's happening with TVET Mastermind today.")
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 30)
                        
                        // Stats Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
                            StatCard(
                                title: "Total Students",
                                value: "1,248",
                                icon: "person.3.fill",
                                trend: "↑ 12% from last month",
                                trendUp: true
                            )
                            StatCard(
                                title: "Active Modules",
                                value: "42",
                                icon: "book.fill",
                                trend: "↑ 3 new this week",
                                trendUp: true
                            )
                            StatCard(
                                title: "Available Games",
                                value: "18",
                                icon: "gamecontroller.fill",
                                trend: "↓ 2 pending review",
                                trendUp: false
                            )
                            StatCard(
                                title: "Completed Lessons",
                                value: "856",
                                icon: "checkmark.circle.fill",
                                trend: "↑ 24% this week",
                                trendUp: true
                            )
                        }
                        .padding(.horizontal, 40)
                        
                        // Content Grid
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
                .background(Color(red: 0.94, green: 0.95, blue: 0.96))
            }
        }
    }
}

// MARK: - Sidebar Component
struct SidebarView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Brand
            Text("TVET")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.orange)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
            
            // Nav Links
            VStack(alignment: .leading, spacing: 5) {
                SidebarLink(icon: "house.fill", text: "Home", isActive: true)
                SidebarLink(icon: "book.fill", text: "Modules", isActive: false)
                SidebarLink(icon: "gamecontroller.fill", text: "Games", isActive: false)
                SidebarLink(icon: "calendar", text: "Calendar", isActive: false)
                SidebarLink(icon: "person.fill", text: "Profile", isActive: false)
                SidebarLink(icon: "gearshape.fill", text: "Settings", isActive: false)
            }
            .padding(.horizontal, 10)
            
            Spacer()
            
            // Logout
            SidebarLink(icon: "rectangle.portrait.and.arrow.right", text: "Logout", isActive: false, isLogout: true)
                .padding(.horizontal, 10)
                .padding(.bottom, 20)
        }
    }
}

struct SidebarLink: View {
    let icon: String
    let text: String
    let isActive: Bool
    var isLogout: Bool = false
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .frame(width: 22, height: 22)
            Text(text)
                .font(.system(size: 15, weight: .medium))
            Spacer()
        }
        .foregroundColor(isLogout ? .red : (isActive ? .white : Color(red: 0.8, green: 0.84, blue: 0.89)))
        .padding(.vertical, 14)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isActive ? Color.orange : Color.clear)
        )
    }
}

// MARK: - Top Header Component
struct TopHeaderView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Logo
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange)
                        .frame(width: 48, height: 48)
                    Text("TM")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("TVET Mastermind")
                        .font(.system(size: 20, weight: .bold))
                    Text("Learning Portal")
                        .font(.system(size: 14))
                        .foregroundColor(.orange)
                }
            }
            
            Spacer()
            
            // Search Bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .frame(maxWidth: 600)
            .background(Color(red: 0.97, green: 0.98, blue: 0.99))
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(red: 0.9, green: 0.91, blue: 0.93), lineWidth: 1))
            
            // Notification Bell
            Button(action: {}) {
                Image(systemName: "bell")
                    .font(.system(size: 22))
                    .foregroundColor(.gray)
                    .frame(width: 44, height: 44)
                    .background(Color(red: 0.97, green: 0.98, blue: 0.99))
                    .cornerRadius(12)
            }
        }
    }
}

// MARK: - Stat Card Component
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let trend: String
    let trendUp: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.orange.opacity(0.1))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .foregroundColor(.orange)
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            Text(trend)
                .font(.system(size: 12))
                .foregroundColor(trendUp ? .green : .red)
                .padding(.top, 4)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
    }
}

// MARK: - Recent Students Table
struct RecentStudentsCard: View {
    let students = [
        ("Ahmad Naufal", "ahmad.naufal@student.edu.my", "Active", true),
        ("Siti Aminah", "siti.aminah@student.edu.my", "Pending", false),
        ("Muhammad Ali", "m.ali@student.edu.my", "Active", true),
        ("Nurul Izzah", "nurul.izzah@student.edu.my", "Active", true)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Recent Student Registrations")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Button("View All →") {}
                    .foregroundColor(.orange)
                    .font(.system(size: 14, weight: .semibold))
            }
            
            // Table Header
            HStack {
                Text("Name").frame(maxWidth: .infinity, alignment: .leading)
                Text("Email").frame(maxWidth: .infinity, alignment: .leading)
                Text("Status").frame(width: 80, alignment: .leading)
            }
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.secondary)
            .textCase(.uppercase)
            .padding(.bottom, 10)
            
            // Table Rows
            ForEach(students, id: \.0) { student in
                HStack {
                    Text(student.0).frame(maxWidth: .infinity, alignment: .leading)
                    Text(student.1).frame(maxWidth: .infinity, alignment: .leading)
                    
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
                Divider()
            }
        }
        .padding(28)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
    }
}

// MARK: - Recent Activity
struct RecentActivityCard: View {
    let activities = [
        ("New module \"Web Dev Basics\" was published.", "2 hours ago"),
        ("User Siti Aminah completed \"Intro to Coding\".", "4 hours ago"),
        ("System backup completed successfully.", "Yesterday"),
        ("New game \"Code Quest\" added to library.", "2 days ago")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Recent Activity")
                .font(.system(size: 18, weight: .bold))
            
            ForEach(activities, id: \.0) { activity in
                HStack(alignment: .top, spacing: 15) {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 8, height: 8)
                        .padding(.top, 6)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(activity.0)
                            .font(.system(size: 14))
                        Text(activity.1)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                Divider()
            }
        }
        .padding(28)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
    }
}

// MARK: - Preview
#Preview {
    DashboardView()
}