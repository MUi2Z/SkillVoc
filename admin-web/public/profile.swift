import SwiftUI

struct ProfileView: View {
    var body: some View {
        HStack(spacing: 0) {
            // Sidebar (Left)
            ProfileSidebarView()
                .frame(width: 260)
                .background(Color(red: 0.12, green: 0.16, blue: 0.23))
            
            // Main Content (Right)
            VStack(spacing: 0) {
                // Top Header
                ProfileHeaderView()
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                
                // Scrollable Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // Page Title
                        Text("My Profile")
                            .font(.system(size: 28, weight: .bold))
                            .padding(.top, 30)
                            .padding(.horizontal, 40)
                        
                        // Profile Banner
                        ProfileBannerView()
                            .padding(.horizontal, 40)
                        
                        // Stats Grid
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 20) {
                            ProfileStatCard(title: "Modules Completed", value: "8")
                            ProfileStatCard(title: "Games Completed", value: "5")
                            ProfileStatCard(title: "Achievements Earned", value: "4")
                            ProfileStatCard(title: "Courses Completed", value: "0")
                        }
                        .padding(.horizontal, 40)
                        
                        // Courses & Achievements Grid
                        HStack(alignment: .top, spacing: 24) {
                            EnrolledCoursesCard()
                                .frame(maxWidth: .infinity)
                            
                            RecentAchievementsCard()
                                .frame(width: 380)
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                    }
                }
                .background(Color(red: 0.94, green: 0.95, blue: 0.96))
            }
        }
        .frame(minWidth: 1000, minHeight: 700)
    }
}

// MARK: - Profile Banner
struct ProfileBannerView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 24) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 80, height: 80)
                Text("AN")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Details
            VStack(alignment: .leading, spacing: 6) {
                Text("Ahmad Naufal bin Azman")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                Text("ahmad.naufal@student.edu.my")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
                Text("Student · Enrolled January 2026")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            // Edit Button
            Button(action: {
                print("Edit Profile clicked")
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Edit Profile")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.orange)
                .cornerRadius(8)
            }
        }
        .padding(32)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.12, green: 0.16, blue: 0.23), Color(red: 0.06, green: 0.09, blue: 0.15)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }
}

// MARK: - Stat Card
struct ProfileStatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 12) {
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.orange)
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
    }
}

// MARK: - Enrolled Courses Card
struct EnrolledCoursesCard: View {
    let courses = [
        ("🏗️", "Construction Technology", 0.65),
        ("💻", "Information Technology (KSK)", 0.40),
        ("🔬", "Science Home Economics (SRT)", 0.20)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Enrolled Courses")
                .font(.system(size: 18, weight: .bold))
            
            ForEach(courses, id: \.1) { course in
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 12) {
                        Text(course.0)
                            .font(.system(size: 20))
                        Text(course.1)
                            .font(.system(size: 15, weight: .semibold))
                        Spacer()
                    }
                    
                    ProgressView(value: course.2)
                        .tint(.orange)
                    
                    Text("\(Int(course.2 * 100))% complete")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(16)
                .background(Color(red: 0.97, green: 0.98, blue: 0.99))
                .cornerRadius(8)
            }
        }
        .padding(28)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
    }
}

// MARK: - Recent Achievements Card
struct RecentAchievementsCard: View {
    let achievements = [
        ("", "First Module Completed", "Earned January 2026"),
        ("", "First Game Completed", "Earned February 2026"),
        ("🏗️", "Construction Level 1 Cleared", "Earned March 2026"),
        ("", "IT Level 1 Cleared", "Earned April 2026")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Recent Achievements")
                .font(.system(size: 18, weight: .bold))
            
            ForEach(achievements, id: \.1) { achievement in
                HStack(alignment: .top, spacing: 12) {
                    Text(achievement.0)
                        .font(.system(size: 20))
                        .padding(.top, 2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(achievement.1)
                            .font(.system(size: 14, weight: .semibold))
                        Text(achievement.2)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(14)
                .background(Color(red: 0.97, green: 0.98, blue: 0.99))
                .cornerRadius(8)
            }
        }
        .padding(28)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
    }
}

// MARK: - Sidebar & Header (Included for standalone preview)
// Note: If you already have these in index.swift, you can delete them from this file to avoid errors.

struct ProfileSidebarView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("TVET")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.orange)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
            
            VStack(alignment: .leading, spacing: 5) {
                SidebarItem(icon: "house.fill", text: "Home", isActive: false)
                SidebarItem(icon: "book.fill", text: "Modules", isActive: false)
                SidebarItem(icon: "gamecontroller.fill", text: "Games", isActive: false)
                SidebarItem(icon: "calendar", text: "Calendar", isActive: false)
                SidebarItem(icon: "person.fill", text: "Profile", isActive: true) // Active!
                SidebarItem(icon: "gearshape.fill", text: "Settings", isActive: false)
            }
            .padding(.horizontal, 10)
            
            Spacer()
            
            SidebarItem(icon: "rectangle.portrait.and.arrow.right", text: "Logout", isActive: false, isLogout: true)
                .padding(.horizontal, 10)
                .padding(.bottom, 20)
        }
    }
}

struct SidebarItem: View {
    let icon: String
    let text: String
    let isActive: Bool
    var isLogout: Bool = false
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon).frame(width: 22, height: 22)
            Text(text).font(.system(size: 15, weight: .medium))
            Spacer()
        }
        .foregroundColor(isLogout ? .red : (isActive ? .white : Color(red: 0.8, green: 0.84, blue: 0.89)))
        .padding(.vertical, 14)
        .padding(.horizontal, 20)
        .background(RoundedRectangle(cornerRadius: 8).fill(isActive ? Color.orange : Color.clear))
    }
}

struct ProfileHeaderView: View {
    @State private var searchText = ""
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12).fill(Color.orange).frame(width: 48, height: 48)
                    Text("TM").font(.system(size: 24, weight: .bold)).foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("TVET Mastermind").font(.system(size: 20, weight: .bold))
                    Text("Learning Portal").font(.system(size: 14)).foregroundColor(.orange)
                }
            }
            Spacer()
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Search...", text: $searchText).textFieldStyle(PlainTextFieldStyle())
            }
            .padding(.vertical, 12).padding(.horizontal, 20)
            .frame(maxWidth: 600)
            .background(Color(red: 0.97, green: 0.98, blue: 0.99))
            .cornerRadius(12)
            
            Button(action: {}) {
                Image(systemName: "bell").font(.system(size: 22)).foregroundColor(.gray)
                    .frame(width: 44, height: 44)
                    .background(Color(red: 0.97, green: 0.98, blue: 0.99))
                    .cornerRadius(12)
            }
        }
    }
}

#Preview {
    ProfileView()
}