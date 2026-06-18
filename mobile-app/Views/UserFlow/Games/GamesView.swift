import SwiftUI

// MARK: - Game Model
struct GameItem: Identifiable {
    let id = UUID()
    let title: String
    let department: String
    let difficulty: String        // "Easy" / "Medium" / "Hard" / "Expert"
    let difficultyColor: Color
    let xpReward: Int
    let estimatedMinutes: Int
    let rating: Double
    let cardColor: Color          // dark background for game card
    let icon: String
    let isPremium: Bool
    let isFree: Bool
    let description: String
    let isPlayable: Bool          // false = game belum ready
}

// MARK: - Dummy Games Data
let sampleGames: [GameItem] = [
    GameItem(
        title: "F1 Pit Stop: Tyre Changer",
        department: "Mechanical",
        difficulty: "Hard",
        difficultyColor: Color(hex: "#FF3B30"),
        xpReward: 250,
        estimatedMinutes: 2,
        rating: 4.8,
        cardColor: Color(hex: "#1A1E2E"),
        icon: "wrench.and.screwdriver.fill",
        isPremium: false,
        isFree: true,
        description: "Experience the thrill of an F1 pit stop! Change all 4 tyres before time runs out. Master speed, precision, and automotive technology.",
        isPlayable: true
    ),
    GameItem(
        title: "Coding Adventure",
        department: "ICT",
        difficulty: "Medium",
        difficultyColor: Color(hex: "#FF9500"),
        xpReward: 180,
        estimatedMinutes: 15,
        rating: 4.5,
        cardColor: Color(hex: "#1A2E1A"),
        icon: "laptopcomputer",
        isPremium: false,
        isFree: true,
        description: "Solve coding challenges and debug programs in this interactive adventure. Learn programming fundamentals through gameplay.",
        isPlayable: false
    ),
    GameItem(
        title: "Cyber Security Mission",
        department: "ICT",
        difficulty: "Expert",
        difficultyColor: Color(hex: "#FF3B30"),
        xpReward: 320,
        estimatedMinutes: 30,
        rating: 4.7,
        cardColor: Color(hex: "#2E1A2E"),
        icon: "lock.shield.fill",
        isPremium: true,
        isFree: false,
        description: "Defend against cyber attacks and protect sensitive data. Learn network security concepts through immersive gameplay.",
        isPlayable: false
    ),
    GameItem(
        title: "Restaurant Simulator",
        department: "Hospitality",
        difficulty: "Easy",
        difficultyColor: Color(hex: "#34C759"),
        xpReward: 120,
        estimatedMinutes: 10,
        rating: 4.3,
        cardColor: Color(hex: "#1A2E1E"),
        icon: "fork.knife",
        isPremium: false,
        isFree: true,
        description: "Run your own restaurant and learn culinary management skills. Serve customers, manage inventory, and grow your business.",
        isPlayable: false
    ),
    GameItem(
        title: "Electrical Circuit Builder",
        department: "Mechanical",
        difficulty: "Medium",
        difficultyColor: Color(hex: "#FF9500"),
        xpReward: 200,
        estimatedMinutes: 20,
        rating: 4.6,
        cardColor: Color(hex: "#2E2A1A"),
        icon: "bolt.fill",
        isPremium: true,
        isFree: false,
        description: "Build and test electrical circuits in a safe virtual environment. Learn fundamentals of electrical engineering.",
        isPlayable: false
    ),
    GameItem(
        title: "Design Studio Challenge",
        department: "Creative",
        difficulty: "Easy",
        difficultyColor: Color(hex: "#34C759"),
        xpReward: 150,
        estimatedMinutes: 12,
        rating: 4.4,
        cardColor: Color(hex: "#1A1A2E"),
        icon: "paintbrush.fill",
        isPremium: false,
        isFree: true,
        description: "Express your creativity through design challenges. Learn graphic design principles and digital tools.",
        isPlayable: false
    ),
]

// MARK: - Games View
// Letak dalam folder: Views/UserFlow/Games/GamesView.swift

struct GamesView: View {

    @State private var selectedFilter = "Hot 🔥"
    let filters = ["Hot 🔥", "Mechanical", "ICT", "Hospitality", "Creative"]

    var filteredGames: [GameItem] {
        if selectedFilter == "Hot 🔥" { return sampleGames }
        return sampleGames.filter { $0.department == selectedFilter }
    }

    // Split into 2 columns
    var leftGames: [GameItem] { filteredGames.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element } }
    var rightGames: [GameItem] { filteredGames.enumerated().filter { $0.offset % 2 == 1 }.map { $0.element } }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F5F0EB").ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {

                        // ── Filter Chips ───────────────────────────
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(filters, id: \.self) { filter in
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedFilter = filter
                                        }
                                    }) {
                                        Text(filter)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(selectedFilter == filter ? .white : Color(hex: "#3C3C43"))
                                            .padding(.horizontal, 18)
                                            .padding(.vertical, 10)
                                            .background(
                                                selectedFilter == filter
                                                    ? Color(hex: "#E8472A")
                                                    : Color.white
                                            )
                                            .cornerRadius(20)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 16)

                        // ── 2-Column Grid ──────────────────────────
                        HStack(alignment: .top, spacing: 14) {

                            // Left column
                            VStack(spacing: 14) {
                                ForEach(leftGames) { game in
                                    NavigationLink(destination: GameDetailView(game: game)) {
                                        GameCardView(game: game)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }

                            // Right column
                            VStack(spacing: 14) {
                                ForEach(rightGames) { game in
                                    NavigationLink(destination: GameDetailView(game: game)) {
                                        GameCardView(game: game)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Games")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color(hex: "#1C1C1E"))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "bell")
                            .font(.system(size: 18))
                            .foregroundColor(Color(hex: "#1C1C1E"))
                    }
                }
            }
        }
    }
}

// MARK: - Game Card (dark card style ikut design)
struct GameCardView: View {
    let game: GameItem

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Top badge
            HStack {
                if game.isPremium {
                    Text("Premium")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: "#1C1C1E"))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(hex: "#F5A623"))
                        .cornerRadius(20)
                }
                if game.isFree {
                    Text("Free")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(hex: "#34C759"))
                        .cornerRadius(20)
                }
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)

            // Game icon
            ZStack {
                Image(systemName: game.icon)
                    .font(.system(size: 44))
                    .foregroundColor(.white.opacity(0.85))
                    .shadow(color: .black.opacity(0.3), radius: 8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)

            // Title + difficulty + XP
            VStack(alignment: .leading, spacing: 6) {
                Text(game.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 5) {
                    Circle()
                        .fill(game.difficultyColor)
                        .frame(width: 7, height: 7)
                    Text(game.difficulty)
                        .font(.system(size: 11))
                        .foregroundColor(Color.white.opacity(0.7))
                }

                Text("+\(game.xpReward) XP")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(hex: "#1C1C1E"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#F5A623"))
                    .cornerRadius(20)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 14)
            .padding(.top, 4)
        }
        .background(game.cardColor)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.07), lineWidth: 1)
        )
    }
}

// MARK: - Game Detail View
struct GameDetailView: View {
    let game: GameItem
    @Environment(\.dismiss) var dismiss
    @State private var showGame = false

    var body: some View {
        ZStack {
            Color(hex: "#1C1C1E").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // Hero
                    ZStack {
                        LinearGradient(
                            colors: [game.cardColor, Color(hex: "#1C1C1E")],
                            startPoint: .top, endPoint: .bottom
                        )
                        .frame(height: 240)

                        VStack(spacing: 0) {
                            Image(systemName: game.icon)
                                .font(.system(size: 80))
                                .foregroundColor(.white.opacity(0.9))
                                .shadow(color: .black.opacity(0.4), radius: 20)
                                .padding(.top, 30)
                            Spacer()
                        }
                    }
                    .frame(height: 240)

                    // Info panel
                    VStack(alignment: .leading, spacing: 20) {

                        // Title row
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(game.title)
                                    .font(.system(size: 24, weight: .black))
                                    .foregroundColor(.white)
                                Text(game.department + " & TVET")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color.white.opacity(0.5))
                            }
                            Spacer()
                            Text("+\(game.xpReward) XP")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(Color(hex: "#E8472A"))
                                .cornerRadius(12)
                        }

                        // Stats row
                        HStack(spacing: 10) {
                            GameStatBox(value: game.difficulty, label: "Difficulty", color: game.difficultyColor)
                            GameStatBox(value: "\(game.estimatedMinutes) min", label: "Est. Time", color: .white)
                            GameStatBox(value: String(format: "%.1f", game.rating), label: "Rating", color: Color(hex: "#F5A623"))
                        }

                        // Description
                        Text(game.description)
                            .font(.system(size: 14))
                            .foregroundColor(Color.white.opacity(0.7))
                            .lineSpacing(5)

                        // Play Now button
                        if game.isPlayable {
                            NavigationLink(destination: Game3View()) {
                                Text("Play Now")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(Color(hex: "#E8472A"))
                                    .cornerRadius(18)
                            }
                        } else {
                            Button(action: {}) {
                                Text("Coming Soon")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(Color.white.opacity(0.5))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(18)
                            }
                            .disabled(true)
                        }

                        // Secondary buttons
                        HStack(spacing: 12) {
                            Button(action: {}) {
                                Text("Preview")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(14)
                            }
                            Button(action: {}) {
                                Text("Leaderboard")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "#F5A623"))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(14)
                            }
                        }
                    }
                    .padding(20)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Game Detail")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "heart")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

private struct GameStatBox: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(Color.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.08))
        .cornerRadius(12)
    }
}

#Preview { GamesView() }
