import SwiftUI

struct HomeView: View {

    @Binding var showSidebar: Bool
    @EnvironmentObject var appState: AppState
    @State private var goToProfile = false

    var modulesCompleted: Int { appState.modulesCompleted }
    var gamesPlayed: Int { appState.gamesPlayed }
    let achievements = 0

    var body: some View {
        ZStack {
            Color(hex: "#F5F0EB").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    greetingSection
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 20)

                    statsRow
                        .padding(.horizontal, 20)
                        .padding(.bottom, 28)

                    gameCategoriesSection
                        .padding(.bottom, 28)

                    continueLearningSection
                        .padding(.bottom, 30)
                }
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var greetingSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                Text(greetingText())
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#8E8E93"))
                Text("\(appState.userName)!")
                    .font(.system(size: 26, weight: .black))
                    .foregroundColor(Color(hex: "#1C1C1E"))
                Text("Ready to learn something new today?")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#8E8E93"))
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(Color(hex: "#E8472A"))
                    .frame(width: 48, height: 48)
                Text(appState.userInitials)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
            }
            .onTapGesture { goToProfile = true }
            .navigationDestination(isPresented: $goToProfile) {
                SettingsView(showSidebar: $showSidebar)
                    .environmentObject(appState)
            }
        }
    }

    private func greetingText() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good morning," }
        if hour < 17 { return "Good afternoon," }
        return "Good evening,"
    }

    private var statsRow: some View {
        HStack(spacing: 10) {
            HomeStatCard(value: "\(max(1, modulesCompleted))",    label: "Active\nCourses",     icon: "book",           iconColor: Color(hex: "#E8472A"))
            HomeStatCard(value: "\(modulesCompleted)", label: "Modules\nCompleted",  icon: "checkmark",      iconColor: Color(hex: "#34C759"))
            HomeStatCard(value: "\(gamesPlayed)",      label: "Games\nPlayed",       icon: "gamecontroller", iconColor: Color(hex: "#2196F3"))
            HomeStatCard(value: "\(achievements)",     label: "Achievements",        icon: "trophy",         iconColor: Color(hex: "#FF9500"))
        }
    }

    private var gameCategoriesSection: some View {
        VStack(alignment: .leading, spacing: 14) {

            HStack {
                Text("Game Categories")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(hex: "#1C1C1E"))
                Spacer()
                Button(action: {}) {
                    Text("See all games →")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "#E8472A"))
                }
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    GameCategoryCard(
                        title: "Engineering",
                        description: "Master automotive and electrical skills through hands-on simulations.",
                        icon: "wrench.and.screwdriver.fill",
                        bgColor: Color(hex: "#FFF0E6"),
                        accentColor: Color(hex: "#E8472A"),
                        gameCount: 2,
                        games: ["F1 Pit Stop: Tyre Changer", "Volt Quest: Circuit Master"]
                    )
                    GameCategoryCard(
                        title: "IT",
                        description: "Build network routing skills through interactive tile puzzles.",
                        icon: "network",
                        bgColor: Color(hex: "#E3F0FF"),
                        accentColor: Color(hex: "#2196F3"),
                        gameCount: 1,
                        games: ["RotateTheRoute"]
                    )
                    GameCategoryCard(
                        title: "Home Science",
                        description: "Match culinary cards and master food preparation knowledge.",
                        icon: "fork.knife",
                        bgColor: Color(hex: "#FCE4EC"),
                        accentColor: Color(hex: "#E91E63"),
                        gameCount: 1,
                        games: ["Culinary Memory Card"]
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            }
        }
    }

    private var continueLearningSection: some View {
        VStack(alignment: .leading, spacing: 14) {

            HStack {
                Text("Continue Learning")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(hex: "#1C1C1E"))
                Spacer()
                Button(action: {}) {
                    Text("All courses →")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "#E8472A"))
                }
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ContinueLearningCard(
                        title: "Engineering",
                        description: "Automotive technology, electrical concepts and circuit design.",
                        icon: "wrench.and.screwdriver.fill",
                        bgColor: Color(hex: "#FFF0E6"),
                        accentColor: Color(hex: "#E8472A"),
                        moduleCount: 4, gameCount: 2,
                        progress: 0.0, score: "0/4"
                    )
                    ContinueLearningCard(
                        title: "IT",
                        description: "Computer networking, routing, configuration and network security.",
                        icon: "network",
                        bgColor: Color(hex: "#E3F0FF"),
                        accentColor: Color(hex: "#2196F3"),
                        moduleCount: 4, gameCount: 1,
                        progress: 0.0, score: "0/4"
                    )
                    ContinueLearningCard(
                        title: "Home Science",
                        description: "Kitchen safety, food preparation, culinary arts and sewing basics.",
                        icon: "fork.knife",
                        bgColor: Color(hex: "#FCE4EC"),
                        accentColor: Color(hex: "#E91E63"),
                        moduleCount: 4, gameCount: 1,
                        progress: 0.0, score: "0/4"
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            }
        }
    }
}

struct HomeStatCard: View {
    let value: String
    let label: String
    let icon: String
    let iconColor: Color

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 34, height: 34)
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundColor(iconColor)
            }
            Text(value)
                .font(.system(size: 20, weight: .black))
                .foregroundColor(Color(hex: "#1C1C1E"))
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(Color(hex: "#8E8E93"))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 4)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
    }
}

struct GameCategoryCard: View {
    let title: String
    let description: String
    let icon: String
    let bgColor: Color
    let accentColor: Color
    let gameCount: Int
    let games: [String]

    @State private var goToGame = false
    @State private var selectedGameTitle: String = ""

    @ViewBuilder
    private var destinationView: some View {
        switch selectedGameTitle {
        case "F1 Pit Stop: Tyre Changer":
            PitStopView()
        case "RotateTheRoute":
            RotateTheRouteView()
        case "Volt Quest: Circuit Master":
            VoltQuestView()
        case "Culinary Memory Card":
            CulinaryMemoryCardView()
        default:
            Text("Game coming soon")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            HStack(alignment: .top) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(bgColor)
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(accentColor)
                }
                Spacer()
                Text("\(gameCount) Games")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(accentColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(accentColor.opacity(0.12))
                    .cornerRadius(20)
            }
            .padding(14)

            Text(title)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color(hex: "#1C1C1E"))
                .padding(.horizontal, 14)

            Text(description)
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "#8E8E93"))
                .lineLimit(2)
                .padding(.horizontal, 14)
                .padding(.top, 3)
                .padding(.bottom, 12)

            Divider().padding(.horizontal, 14)

            VStack(spacing: 0) {
                ForEach(Array(games.enumerated()), id: \.offset) { idx, game in
                    HStack {
                        Text(game)
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#3C3C43"))
                            .lineLimit(1)
                        Spacer()
                        Button(action: {
                            selectedGameTitle = game
                            goToGame = true
                        }) {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 26))
                                .foregroundColor(accentColor)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 11)

                    if idx < games.count - 1 {
                        Divider().padding(.horizontal, 14)
                    }
                }
            }
            .padding(.bottom, 4)
        }
        .frame(width: 280)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.06), radius: 8, y: 3)
        .navigationDestination(isPresented: $goToGame) {
            destinationView
        }
    }
}

struct ContinueLearningCard: View {
    let title: String
    let description: String
    let icon: String
    let bgColor: Color
    let accentColor: Color
    let moduleCount: Int
    let gameCount: Int
    let progress: Double
    let score: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            ZStack(alignment: .bottomLeading) {
                bgColor.frame(height: 120)

                Text("\(moduleCount) Modules")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.black.opacity(0.55))
                    .cornerRadius(8)
                    .padding(10)

                Image(systemName: icon)
                    .font(.system(size: 48))
                    .foregroundColor(accentColor.opacity(0.55))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .cornerRadius(14, corners: [.topLeft, .topRight])

            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "#1C1C1E"))
                    .lineLimit(1)

                Text(description)
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "#8E8E93"))
                    .lineLimit(2)

                HStack(spacing: 10) {
                    HStack(spacing: 3) {
                        Image(systemName: "book").font(.system(size: 10)).foregroundColor(Color(hex: "#8E8E93"))
                        Text("\(moduleCount) modules").font(.system(size: 10)).foregroundColor(Color(hex: "#8E8E93"))
                    }
                    HStack(spacing: 3) {
                        Image(systemName: "gamecontroller").font(.system(size: 10)).foregroundColor(Color(hex: "#8E8E93"))
                        Text("\(gameCount) games").font(.system(size: 10)).foregroundColor(Color(hex: "#8E8E93"))
                    }
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(hex: "#E0DDD8"))
                            .frame(height: 5)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(accentColor)
                            .frame(width: geo.size.width * progress, height: 5)
                    }
                }
                .frame(height: 5)

                HStack {
                    Text("\(Int(progress * 100))% complete")
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "#8E8E93"))
                    Spacer()
                    Text(score)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(Color(hex: "#8E8E93"))
                }
            }
            .padding(12)
        }
        .frame(width: 220)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 3)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview { HomeView(showSidebar: .constant(false)).environmentObject(AppState.shared) }
