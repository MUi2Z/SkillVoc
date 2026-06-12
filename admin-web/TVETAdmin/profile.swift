import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showNotifications = false
    @State private var isEditingProfile = false
    @State private var editedFullName = "Ahmad Naufal bin Azman"
    @State private var editedEmail = "ahmad.naufal@student.edu.my"
    @State private var editedPhone = "+60 12-345 6789"
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(spacing: 0) {
                SidebarView()
                    .frame(width: appState.compactSidebar ? 90 : 260)
                    .background(Color(red: 0.12, green: 0.16, blue: 0.23))
                
                VStack(spacing: 0) {
                    TopHeaderView(searchText: .constant(""), showNotifications: $showNotifications)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(appState.darkMode ? Color(red: 0.1, green: 0.1, blue: 0.12) : Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                        .zIndex(1)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 30) {
                            Text("My Profile")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(appState.darkMode ? .white : .primary)
                                .padding(.top, 30)
                                .padding(.horizontal, 40)
                            
                            ProfileBannerView(
                                isEditingProfile: $isEditingProfile,
                                editedFullName: $editedFullName,
                                editedEmail: $editedEmail,
                                editedPhone: $editedPhone
                            )
                            .padding(.horizontal, 40)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                ProfileStatCard(title: "Modules Completed", value: "8")
                                ProfileStatCard(title: "Games Completed", value: "5")
                                ProfileStatCard(title: "Achievements Earned", value: "4")
                                ProfileStatCard(title: "Courses Completed", value: "0")
                            }
                            .padding(.horizontal, 40)
                            
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
                    .background(appState.darkMode ? Color(red: 0.08, green: 0.09, blue: 0.11) : Color(red: 0.94, green: 0.95, blue: 0.96))
                    .zIndex(0)
                }
            }
            .frame(minWidth: 1000, minHeight: 700)
            .animation(appState.animatedTransitions ? .easeInOut(duration: 0.3) : .none, value: appState.compactSidebar)
            
            if showNotifications {
                NotificationDropdownView(isPresented: $showNotifications)
                    .padding(.top, 80)
                    .padding(.trailing, 60)
                    .zIndex(9999)
                    .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .sheet(isPresented: $isEditingProfile) {
            EditProfileSheet(
                isPresented: $isEditingProfile,
                fullName: $editedFullName,
                email: $editedEmail,
                phone: $editedPhone
            )
        }
    }
}

struct ProfileBannerView: View {
    @Binding var isEditingProfile: Bool
    @Binding var editedFullName: String
    @Binding var editedEmail: String
    @Binding var editedPhone: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 24) {
            ZStack {
                Circle().fill(Color.orange).frame(width: 80, height: 80)
                Text("AN").font(.system(size: 28, weight: .bold)).foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(editedFullName).font(.system(size: 22, weight: .bold)).foregroundColor(.white)
                Text(editedEmail).font(.system(size: 14)).foregroundColor(.white.opacity(0.8))
                Text("Student · Enrolled January 2026").font(.system(size: 13)).foregroundColor(.white.opacity(0.6))
            }
            Spacer()
            Button(action: { isEditingProfile = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil").font(.system(size: 14, weight: .semibold))
                    Text("Edit Profile").font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.white).padding(.horizontal, 20).padding(.vertical, 12).background(Color.orange).cornerRadius(8)
            }
        }
        .padding(32)
        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.12, green: 0.16, blue: 0.23), Color(red: 0.06, green: 0.09, blue: 0.15)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(16)
    }
}

struct EditProfileSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    @Binding var fullName: String
    @Binding var email: String
    @Binding var phone: String
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Edit Profile").font(.title2).fontWeight(.bold)
                Spacer()
                Button("Save & Close") { dismiss() }
                    .foregroundColor(.white).padding(.horizontal, 16).padding(.vertical, 8).background(Color.orange).cornerRadius(8)
            }.padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Full Name").font(.subheadline).fontWeight(.semibold).foregroundColor(.gray)
                TextField("Full Name", text: $fullName).textFieldStyle(.roundedBorder)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Email").font(.subheadline).fontWeight(.semibold).foregroundColor(.gray)
                TextField("Email", text: $email).textFieldStyle(.roundedBorder)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Phone").font(.subheadline).fontWeight(.semibold).foregroundColor(.gray)
                TextField("Phone", text: $phone).textFieldStyle(.roundedBorder)
            }
            Spacer()
        }
        .padding(30).frame(width: 500, height: 400)
    }
}

struct ProfileStatCard: View {
    @EnvironmentObject var appState: AppState
    let title: String
    let value: String
    var body: some View {
        VStack(spacing: 12) {
            Text(value).font(.system(size: 32, weight: .bold)).foregroundColor(.orange)
            Text(title).font(.system(size: 13, weight: .medium)).foregroundColor(appState.darkMode ? .gray : .secondary).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 24)
        .background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color.white).cornerRadius(12).shadow(color: .black.opacity(0.04), radius: 3, y: 1)
    }
}

struct EnrolledCoursesCard: View {
    @EnvironmentObject var appState: AppState
    let courses = [("🏗️", "Construction Technology", 0.65), ("💻", "Information Technology (KSK)", 0.40), ("🔬", "Science Home Economics (SRT)", 0.20)]
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Enrolled Courses").font(.system(size: 18, weight: .bold)).foregroundColor(appState.darkMode ? .white : .primary)
                Spacer()
                Button("View All →") {}.foregroundColor(.orange).font(.system(size: 14, weight: .semibold))
            }
            ForEach(courses, id: \.1) { course in
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 12) {
                        Text(course.0).font(.system(size: 20))
                        Text(course.1).font(.system(size: 15, weight: .semibold)).foregroundColor(appState.darkMode ? .white : .primary)
                        Spacer()
                    }
                    ProgressView(value: course.2).tint(.orange)
                    Text("\(Int(course.2 * 100))% complete").font(.system(size: 12)).foregroundColor(appState.darkMode ? .gray : .secondary)
                }
                .padding(16).background(appState.darkMode ? Color(red: 0.1, green: 0.11, blue: 0.13) : Color(red: 0.97, green: 0.98, blue: 0.99)).cornerRadius(8)
            }
        }
        .padding(28).background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color.white).cornerRadius(12).shadow(color: .black.opacity(0.04), radius: 3, y: 1)
    }
}

struct RecentAchievementsCard: View {
    @EnvironmentObject var appState: AppState
    let achievements = [("🏆", "First Module Completed", "Earned January 2026"), ("🎮", "First Game Completed", "Earned February 2026"), ("🏗️", "Construction Level 1 Cleared", "Earned March 2026"), ("💻", "IT Level 1 Cleared", "Earned April 2026")]
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Recent Achievements").font(.system(size: 18, weight: .bold)).foregroundColor(appState.darkMode ? .white : .primary)
            ForEach(achievements, id: \.1) { achievement in
                HStack(alignment: .top, spacing: 12) {
                    Text(achievement.0).font(.system(size: 20)).padding(.top, 2)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(achievement.1).font(.system(size: 14, weight: .semibold)).foregroundColor(appState.darkMode ? .white : .primary)
                        Text(achievement.2).font(.system(size: 12)).foregroundColor(appState.darkMode ? .gray : .secondary)
                    }
                    Spacer()
                }
                .padding(14).background(appState.darkMode ? Color(red: 0.1, green: 0.11, blue: 0.13) : Color(red: 0.97, green: 0.98, blue: 0.99)).cornerRadius(8)
            }
        }
        .padding(28).background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color.white).cornerRadius(12).shadow(color: .black.opacity(0.04), radius: 3, y: 1)
    }
}

#Preview {
    ProfileView().environmentObject(AppState())
}
