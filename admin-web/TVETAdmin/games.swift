//
//  games.swift
//  SkillVocWeb
//
//  Created by MUi2Z on 11/06/2026.
//

import SwiftUI

// MARK: - Model
struct GameItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: String
    let level: String // Easy, Medium, Hard
    let iconName: String
}

struct GamesView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var selectedCategory = "All Games"
    
    let categories = ["All Games", "Construction", "IT (KSK)", "SRT", "Level 1 — Easy", "Level 2 — Medium", "Level 3 — Hard"]
    
    // Mock Data based on image
    let games = [
        GameItem(title: "Bricklaying Challenge", description: "Place bricks in the correct order and learn proper mortar application techniques.", category: "Construction", level: "Easy", iconName: "house.fill"),
        GameItem(title: "Blueprint Puzzle", description: "Match building components to their blueprint symbols and scale measurements.", category: "Construction", level: "Medium", iconName: "map.fill"),
        GameItem(title: "Site Safety Inspection", description: "Identify all safety violations across a complex, multi-area construction site scene.", category: "Construction", level: "Hard", iconName: "exclamationmark.triangle.fill"),
        GameItem(title: "Network Installation Sim", description: "Connect network devices and configure basic LAN settings to build a working network.", category: "IT (KSK)", level: "Easy", iconName: "network"),
        GameItem(title: "IP Address Challenge", description: "Solve subnetting puzzles and assign the correct IP addresses to various host devices.", category: "IT (KSK)", level: "Medium", iconName: "computermouse.fill"),
        GameItem(title: "Computer Assembly Sim", description: "Assemble a full computer system from individual components in the correct sequence.", category: "IT (KSK)", level: "Hard", iconName: "cpu"),
        GameItem(title: "Cake Decoration Challenge", description: "Decorate cakes using the correct tools, icing techniques and creative designs.", category: "SRT", level: "Easy", iconName: "birthday.cake.fill"),
        GameItem(title: "Laundry Management Sim", description: "Sort garments correctly and select the appropriate wash cycles for different fabrics.", category: "SRT", level: "Medium", iconName: "washer.fill"),
        GameItem(title: "Sewing Practice Game", description: "Master complex stitching patterns and complete a full sewing project from start to finish.", category: "SRT", level: "Hard", iconName: "scissors")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            // Sidebar (Reused from your Dashboard code)
            SidebarView()
                .frame(width: appState.compactSidebar ? 90 : 260)
                .background(Color(red: 0.12, green: 0.16, blue: 0.23))
            
            VStack(spacing: 0) {
                // Top Header
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // Page Title & Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Educational Games")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(appState.darkMode ? .white : .primary)
                            Text("Reinforce your learning through interactive challenges")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 30)
                        
                        // Filter Bar
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(categories, id: \.self) { cat in
                                    CategoryPill(title: cat, isSelected: selectedCategory == cat) {
                                        selectedCategory = cat
                                    }
                                }
                            }
                        }
                        
                        // Games Grid
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 20),
                            GridItem(.flexible(), spacing: 20),
                            GridItem(.flexible(), spacing: 20)
                        ], spacing: 25) {
                            ForEach(games.filter { selectedCategory == "All Games" || $0.category == selectedCategory || $0.level == selectedCategory.replacingOccurrences(of: "Level.*— ", with: "", options: .regularExpression) }) { game in
                                GameCard(game: game)
                            }
                        }
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 40)
                }
                .background(appState.darkMode ? Color(red: 0.08, green: 0.09, blue: 0.11) : Color(red: 0.94, green: 0.95, blue: 0.96))
            }
        }
        .frame(minWidth: 1200, minHeight: 800)
    }
}

// MARK: - Supporting Views

struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? Color.orange : Color.white.opacity(0.1))
                .background(isSelected ? Color.orange : (Color.gray.opacity(0.1)))
                .foregroundColor(isSelected ? .white : .gray)
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct GameCard: View {
    @EnvironmentObject var appState: AppState
    let game: GameItem
    
    var levelColor: Color {
        switch game.level {
        case "Easy": return .green
        case "Medium": return .orange
        case "Hard": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Card Thumbnail Placeholder
            ZStack {
                Rectangle()
                    .fill(appState.darkMode ? Color.black.opacity(0.3) : Color.gray.opacity(0.05))
                    .frame(height: 160)
                
                Image(systemName: game.iconName)
                    .font(.system(size: 50))
                    .foregroundColor(levelColor.opacity(0.7))
                
                // Level Badge
                VStack {
                    HStack {
                        Spacer()
                        Text("Level — \(game.level)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(levelColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(levelColor.opacity(0.1))
                            .cornerRadius(4)
                    }
                    Spacer()
                }
                .padding(12)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                Text(game.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(appState.darkMode ? .white : .primary)
                
                Text(game.description)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .frame(height: 40, alignment: .top)
                
                HStack {
                    Text(game.category)
                        .font(.system(size: 11, weight: .semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(appState.darkMode ? Color.white.opacity(0.05) : Color.gray.opacity(0.1))
                        .foregroundColor(.gray)
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Play Now")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                            .background(Color.orange)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(20)
        }
        .background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    GamesView()
        .environmentObject(AppState())
}
