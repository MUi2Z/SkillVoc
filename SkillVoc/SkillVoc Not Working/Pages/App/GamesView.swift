import SwiftUI

struct GameItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let department: String
    let icon: String
    let cardBgColor: Color
    let iconColor: Color
    let isPlayable: Bool
    let developerName: String
}

let sampleGames: [GameItem] = [
    GameItem(
        title: "F1 Pit Stop: Tyre Changer",
        description: "Change all 4 F1 tyres before time runs out. Tap, swipe and hold for each step. Master automotive speed and precision!",
        department: "Engineering",
        icon: "wrench.and.screwdriver.fill",
        cardBgColor: Color(hex: "#FFF0E6"),
        iconColor: Color(hex: "#E8472A"),
        isPlayable: true,
        developerName: "Emir"
    ),
    GameItem(
        title: "Volt Quest: Circuit Master",
        description: "Build and repair electrical circuits within the given time. Understand electrical components and how they work.",
        department: "Engineering",
        icon: "bolt.fill",
        cardBgColor: Color(hex: "#FFFDE7"),
        iconColor: Color(hex: "#FFC107"),
        isPlayable: true,
        developerName: "Afiq"
    ),
    GameItem(
        title: "RotateTheRoute",
        description: "Rotate tiles to connect the network path from source to destination. Solve the puzzle before time runs out!",
        department: "IT",
        icon: "network",
        cardBgColor: Color(hex: "#E3F0FF"),
        iconColor: Color(hex: "#2196F3"),
        isPlayable: true,
        developerName: "Muizz"
    ),
    GameItem(
        title: "NetIsolator",
        description: "Wire out the network from the top left corner to the bottom right corner. Can you solve this puzzle in time?",
        department: "IT",
        icon: "network",
        cardBgColor: Color(hex: "#E3F0FF"),
        iconColor: Color(hex: "#2196F3"),
        isPlayable: true,
        developerName: "Muizz"
    ),
    GameItem(
        title: "Culinary Memory Card",
        description: "Match pairs of culinary equipment and food ingredient cards. Test your memory and hospitality knowledge!",
        department: "Home Science",
        icon: "fork.knife",
        cardBgColor: Color(hex: "#FCE4EC"),
        iconColor: Color(hex: "#E91E63"),
        isPlayable: true,
        developerName: "Ami"
    ),
    GameItem(
        title: "Fashion & Sewing",
        description: "Match sewing tools on the grid and answer questions about fashion and sewing techniques!",
        department: "Home Science",
        icon: "scissors",
        cardBgColor: Color(hex: "#FCE4EC"),
        iconColor: Color(hex: "#E91E63"),
        isPlayable: true,
        developerName: "Ami"
    ),
]

let gameFilterOptions = ["All Games", "Engineering", "IT", "Home Science"]

func gameDeptEmoji(_ dept: String) -> String {
    switch dept {
    case "Engineering": return "🔧"
    case "IT":           return "💻"
    case "Home Science":           return "🍽️"
    default:              return "🎮"
    }
}

struct GamesView: View {

    @Binding var showSidebar: Bool
    @EnvironmentObject var appState: AppState
    @State private var selectedFilter = "All Games"
    @State private var searchText = ""

    var filteredGames: [GameItem] {
        var result = sampleGames
        if selectedFilter != "All Games" {
            result = result.filter { $0.department == selectedFilter }
        }
        if !searchText.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        return result
    }

    var body: some View {
        ZStack {
            Color(hex: "#F5F0EB").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Educational Games")
                            .font(.system(size: 26, weight: .black))
                            .foregroundColor(Color(hex: "#1C1C1E"))
                        Text("Reinforce your learning through interactive challenges")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#8E8E93"))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 14)

                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(hex: "#8E8E93"))
                        TextField("Search games...", text: $searchText)
                            .font(.system(size: 15))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 14)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(gameFilterOptions, id: \.self) { filter in
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedFilter = filter
                                    }
                                }) {
                                    Text(filter)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(selectedFilter == filter ? .white : Color(hex: "#3C3C43"))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(selectedFilter == filter ? Color(hex: "#E8472A") : Color.white)
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(selectedFilter == filter ? Color.clear : Color(hex: "#E0DDD8"), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 22)

                    VStack(spacing: 16) {
                        ForEach(filteredGames) { game in
                            NavigationLink(destination: GameDetailView(game: game).environmentObject(appState)) {
                                GameCardView(game: game)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationTitle("Games")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GameCardView: View {
    let game: GameItem

    var body: some View {
        HStack(spacing: 0) {

            ZStack {
                game.cardBgColor

                VStack(spacing: 10) {
                    Image(systemName: game.icon)
                        .font(.system(size: 48))
                        .foregroundColor(game.iconColor)
                }
            }
            .frame(width: 130, height: 190)

            VStack(alignment: .leading, spacing: 8) {

                Text(game.department)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(game.iconColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(game.iconColor.opacity(0.1))
                    .cornerRadius(20)

                Text(game.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: "#1C1C1E"))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(game.description)
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "#8E8E93"))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Spacer()

                Text(game.isPlayable ? "Play" : "Coming Soon")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(game.isPlayable ? .white : Color(hex: "#8E8E93"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(game.isPlayable ? Color(hex: "#E8472A") : Color(hex: "#F0F0F0"))
                    .cornerRadius(10)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 190)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
    }
}

struct GameDetailView: View {
    let game: GameItem
    @State private var goToGame = false
    @EnvironmentObject var appState: AppState

    @ViewBuilder
    private var destinationView: some View {
        switch game.title {
        case "F1 Pit Stop: Tyre Changer":
            PitStopView()
                .onDisappear { appState.markGamePlayed("F1 Pit Stop: Tyre Changer", level: "any", time: 0) }
        case "Volt Quest: Circuit Master":
            VoltQuestView()
                .onDisappear { appState.markGamePlayed("Volt Quest: Circuit Master", level: "any", time: 0) }
        case "RotateTheRoute":
            RotateTheRouteView()
                .onDisappear { appState.markGamePlayed("RotateTheRoute", level: "any", time: 0) }
        case "Culinary Memory Card":
            CulinaryMemoryCardView()
                .onDisappear { appState.markGamePlayed("Culinary Memory Card", level: "any", time: 0) }
        case "Fashion & Sewing":
            FashionSewingView()
                .onDisappear { appState.markGamePlayed("Fashion & Sewing", level: "any", time: 0) }
            
        default:
            Text("Game coming soon")
        }
    }

    var body: some View {
        ZStack {
            Color(hex: "#F5F0EB").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    ZStack {
                        game.cardBgColor.frame(height: 240)
                        VStack(spacing: 14) {
                            Image(systemName: game.icon)
                                .font(.system(size: 80))
                                .foregroundColor(game.iconColor)
                        }
                    }

                    VStack(alignment: .leading, spacing: 16) {

                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(game.title)
                                    .font(.system(size: 22, weight: .black))
                                    .foregroundColor(Color(hex: "#1C1C1E"))
                                Text(game.department)
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "#8E8E93"))
                            }
                            Spacer()
                        }
                        .padding(.top, 20)

                        Text(game.description)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#6C6C70"))
                            .lineSpacing(4)
                            .padding(14)
                            .background(Color.white)
                            .cornerRadius(14)

                        HStack(spacing: 8) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "#8E8E93"))
                            Text("Developed by \(game.developerName)")
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "#8E8E93"))
                        }
                        .padding(.horizontal, 4)
                        .padding(.top, -8)

                        Button(action: { if game.isPlayable { goToGame = true } }) {
                            Text(game.isPlayable ? "Play" : "Coming Soon")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(game.isPlayable ? .white : Color(hex: "#8E8E93"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(game.isPlayable ? Color(hex: "#E8472A") : Color(hex: "#F0F0F0"))
                                .cornerRadius(16)
                        }
                        .disabled(!game.isPlayable)
                        .navigationDestination(isPresented: $goToGame) {
                            destinationView
                        }
                        .padding(.bottom, 30)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationTitle(game.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview { GamesView(showSidebar: .constant(false)) }
