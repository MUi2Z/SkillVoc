import SwiftUI
import Foundation
import Combine
import AVFoundation


enum CulinaryTheme {
    static let primary = Color(red: 1.00, green: 0.45, blue: 0.20)   // hot orange
    static let secondary = Color(red: 0.95, green: 0.25, blue: 0.35) // tomato red
    static let accent = Color(red: 1.00, green: 0.78, blue: 0.30)    // egg yolk yellow
    static let deep = Color(red: 0.20, green: 0.10, blue: 0.18)      // dark maroon

    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [Color(hex: "#F5F0EB")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var cardBackGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 216/255, green: 90/255, blue: 48/255),
                Color(red: 190/255, green: 75/255, blue: 38/255)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var cardFaceGradient: LinearGradient {
        LinearGradient(
            colors: [Color.white, Color(red: 1.0, green: 0.97, blue: 0.90)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Kitchen Item Model
struct CulinaryKitchenItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String

    static let all: [CulinaryKitchenItem] = [
        CulinaryKitchenItem(name: "Knife", imageName: "knife"),
        CulinaryKitchenItem(name: "Grater", imageName: "grater"),
        CulinaryKitchenItem(name: "Steamer", imageName: "steamer"),
        CulinaryKitchenItem(name: "Whisk", imageName: "whisk"),
        CulinaryKitchenItem(name: "Tong", imageName: "tong"),
        CulinaryKitchenItem(name: "Ladle", imageName: "ladle"),
        CulinaryKitchenItem(name: "Peeler", imageName: "peeler"),
        CulinaryKitchenItem(name: "Colander", imageName: "colander"),
        CulinaryKitchenItem(name: "Stoves", imageName: "stoves"),
        CulinaryKitchenItem(name: "Teaspoon", imageName: "teaspoon"),
        CulinaryKitchenItem(name: "Bowls", imageName: "bowls"),
        CulinaryKitchenItem(name: "Strainer", imageName: "strainer"),
        CulinaryKitchenItem(name: "Blender", imageName: "blender"),
        CulinaryKitchenItem(name: "Mixer", imageName: "mixer"),
        CulinaryKitchenItem(name: "Spatula", imageName: "spatula"),
        CulinaryKitchenItem(name: "Oven", imageName: "oven"),
        CulinaryKitchenItem(name: "Pot", imageName: "pot"),
        CulinaryKitchenItem(name: "Pan", imageName: "pan"),
        CulinaryKitchenItem(name: "Plate", imageName: "plate"),
        CulinaryKitchenItem(name: "Chiller", imageName: "chiller"),
    ]
}

// MARK: - Card Model
// Renamed from "Card" to "CulinaryCard" — "Card" is too generic and risks clashing
struct CulinaryCard: Identifiable {
    let id = UUID()
    let item: CulinaryKitchenItem
    var isFaceUp: Bool = false
    var isMatched: Bool = false
}

// MARK: - Sound Manager
// Renamed from "SoundManager" to "CulinarySoundManager" to avoid clashing with
// any sound manager other games (or future features) might introduce
class CulinarySoundManager {

    static let shared = CulinarySoundManager()

    private var player: AVAudioPlayer?

    func playSound(named soundName: String) {
        guard let url = Bundle.main.url(
            forResource: soundName,
            withExtension: "mp3"
        ) else {
            print("Sound not found")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error playing sound")
        }
    }
}


final class CulinaryGameViewModel: ObservableObject {
    @Published var cards: [CulinaryCard] = []
    @Published var moves: Int = 0
    @Published var isPreviewing: Bool = true
    @Published var isFinished: Bool = false

    let level: Int
    private var firstFlippedIndex: Int?
    private var lockBoard = false
    private var chosenItems: [CulinaryKitchenItem] = []

    init(level: Int) {
        self.level = level
        let pairsNeeded = Self.cardCount(for: level) / 2
        self.chosenItems = Array(CulinaryKitchenItem.all.shuffled().prefix(pairsNeeded))
        setupGame()
    }

    static func cardCount(for level: Int) -> Int {
        switch level {
        case 1: return 4
        case 2: return 12
        case 3: return 20
        default: return 4
        }
    }

    private var previewDuration: Double {
        switch level {
        case 1: return 2.0
        case 2: return 4.0
        case 3: return 8.0
        default: return 2.0
        }
    }

    func restart() {
        setupGame()
    }

    func newGame() {
        let pairsNeeded = Self.cardCount(for: level) / 2
        chosenItems = Array(CulinaryKitchenItem.all.shuffled().prefix(pairsNeeded))
        setupGame()
    }

    func setupGame() {
        var deck: [CulinaryCard] = []
        for item in chosenItems {
            deck.append(CulinaryCard(item: item, isFaceUp: true))
            deck.append(CulinaryCard(item: item, isFaceUp: true))
        }
        deck.shuffle()
        cards = deck
        moves = 0
        firstFlippedIndex = nil
        isPreviewing = true
        isFinished = false
        lockBoard = true

        DispatchQueue.main.asyncAfter(deadline: .now() + previewDuration) { [weak self] in
            guard let self else { return }
            withAnimation(.easeInOut(duration: 0.4)) {
                for i in self.cards.indices { self.cards[i].isFaceUp = false }
            }
            self.isPreviewing = false
            self.lockBoard = false
        }
    }

    func flip(_ index: Int) {
        guard !lockBoard, !isPreviewing else { return }
        guard cards.indices.contains(index) else { return }
        guard !cards[index].isFaceUp, !cards[index].isMatched else { return }

        CulinarySoundManager.shared.playSound(named: "flip")
        withAnimation(.easeInOut(duration: 0.25)) {
            cards[index].isFaceUp = true
        }

        if let first = firstFlippedIndex {
            moves += 1
            if cards[first].item == cards[index].item {

                CulinarySoundManager.shared.playSound(named: "correct")

                cards[first].isMatched = true
                cards[index].isMatched = true
                firstFlippedIndex = nil
                checkFinish()
            } else {

                CulinarySoundManager.shared.playSound(named: "wrong")
                lockBoard = true
                let a = first
                let b = index
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                    guard let self else { return }
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.cards[a].isFaceUp = false
                        self.cards[b].isFaceUp = false
                    }
                    self.firstFlippedIndex = nil
                    self.lockBoard = false
                }
            }
        } else {
            firstFlippedIndex = index
        }
    }

    private func checkFinish() {
        if cards.allSatisfy({ $0.isMatched }) {
            CulinarySoundManager.shared.playSound(named: "win")
            isFinished = true
        }
    }
}


struct CulinaryCardView: View {
    let card: CulinaryCard

    var body: some View {
        ZStack {
            // ===== Card back =====
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(CulinaryTheme.cardBackGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.35), lineWidth: 1.5)
                )
                .overlay(
                    VStack(spacing: 4) {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)

                        Text("CULINARY")
                            .font(.system(size: 8, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }
                )
                .shadow(color: CulinaryTheme.deep.opacity(0.35), radius: 6, x: 0, y: 4)
                .opacity(card.isFaceUp ? 0 : 1)
                .rotation3DEffect(.degrees(card.isFaceUp ? 180 : 0), axis: (0, 1, 0))

            // ===== Card face =====
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(CulinaryTheme.cardFaceGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(
                            card.isMatched ? Color.green.opacity(0.8) : CulinaryTheme.primary.opacity(0.45),
                            lineWidth: card.isMatched ? 3 : 2
                        )
                )
                .overlay(
                    VStack(spacing: 8) {

                        Spacer(minLength: 4)

                        Image(card.item.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 70, maxHeight: 70)

                        Text(card.item.name)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundColor(CulinaryTheme.deep)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                            .frame(height: 28)

                        Spacer(minLength: 4)
                    }
                    .padding(6)
                )
                .overlay(
                    Group {
                        if card.isMatched {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(Color.green, lineWidth: 2)
                                .blur(radius: 6)
                                .opacity(0.8)
                        }
                    }
                )
                .shadow(color: CulinaryTheme.primary.opacity(0.25), radius: 5, x: 0, y: 3)
                .opacity(card.isFaceUp ? 1 : 0)
                .rotation3DEffect(.degrees(card.isFaceUp ? 0 : -180), axis: (0, 1, 0))
                .clipped()
        }
        .scaleEffect(card.isMatched ? 0.95 : 1.0)
        .opacity(card.isMatched ? 0.85 : 1)
        .animation(.spring(response: 0.45, dampingFraction: 0.7), value: card.isFaceUp)
        .animation(.easeInOut(duration: 0.3), value: card.isMatched)
        .aspectRatio(2/3, contentMode: .fit)
    }
}

// MARK: - Game View (gameplay screen with grid)
// Renamed from "GameView" to "CulinaryGameView"
struct CulinaryGameView: View {
    let level: Int
    @StateObject private var vm: CulinaryGameViewModel
    @Environment(\.dismiss) private var dismiss

    init(level: Int) {
        self.level = level
        _vm = StateObject(wrappedValue: CulinaryGameViewModel(level: level))
    }

    private var columnsCount: Int {
        switch level {
        case 1: return 2
        case 2: return 4
        case 3: return 5
        default: return 2
        }
    }

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 10), count: columnsCount)
    }

    private var matchedPairs: Int {
        vm.cards.filter { $0.isMatched }.count / 2
    }

    private var totalPairs: Int {
        vm.cards.count / 2
    }

    private var progress: Double {
        totalPairs == 0 ? 0 : Double(matchedPairs) / Double(totalPairs)
    }

    var body: some View {
        ZStack {
            CulinaryTheme.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 14) {
                // ===== Header stats =====
                HStack(spacing: 12) {
                    statChip(icon: "star.fill", label: "Level", value: "\(level)", tint: CulinaryTheme.accent)
                    statChip(icon: "hand.tap.fill", label: "Moves", value: "\(vm.moves)", tint: CulinaryTheme.primary)
                    statChip(icon: "checkmark.seal.fill", label: "Matched", value: "\(matchedPairs)/\(totalPairs)", tint: .green)
                }
                .padding(.horizontal)
                .padding(.top, 4)

                // ===== Progress bar =====
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.4))
                        Capsule()
                            .fill(
                                LinearGradient(colors: [CulinaryTheme.accent, CulinaryTheme.primary, CulinaryTheme.secondary],
                                               startPoint: .leading, endPoint: .trailing)
                            )
                            .frame(width: max(8, geo.size.width * progress))
                            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: progress)
                    }
                }
                .frame(height: 10)
                .padding(.horizontal)

                // ===== Preview banner =====
                if vm.isPreviewing {
                    HStack(spacing: 8) {
                        Image(systemName: "eye.fill")
                        Text("Remember cards now…")
                            .font(.system(.subheadline, design: .rounded).bold())
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16).padding(.vertical, 8)
                    .background(
                        Capsule().fill(CulinaryTheme.secondary)
                            .shadow(color: CulinaryTheme.secondary.opacity(0.4), radius: 6, y: 3)
                    )
                    .transition(.scale.combined(with: .opacity))
                }

                // ===== Card grid =====
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(Array(vm.cards.enumerated()), id: \.element.id) { index, card in
                            CulinaryCardView(card: card)
                                .onTapGesture { vm.flip(index) }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                }

                // ===== Buttons =====
                HStack(spacing: 10) {
                    Button {
                        withAnimation { vm.restart() }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Replay")
                                .font(.system(.headline, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(colors: [CulinaryTheme.primary, CulinaryTheme.secondary],
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: CulinaryTheme.secondary.opacity(0.4), radius: 8, y: 4)
                    }

                    Button {
                        withAnimation { vm.newGame() }
                    } label: {
                        HStack {
                            Image(systemName: "shuffle")
                            Text("New Cards")
                                .font(.system(.headline, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .foregroundColor(CulinaryTheme.secondary)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(CulinaryTheme.secondary.opacity(0.4), lineWidth: 1.5)
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)

            }
        }
        .navigationTitle("Culinary Memory")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Congratulations! 🎉", isPresented: $vm.isFinished) {
            Button("Replay") { vm.restart() }
            Button("Exit", role: .cancel) { dismiss() }
        } message: {
            Text("You won level \(level) in \(vm.moves) moves.")
        }
    }

    @ViewBuilder
    private func statChip(icon: String, label: String, value: String, tint: Color) -> some View {
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .bold))
                Text(label)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
            }
            .foregroundColor(.white.opacity(0.9))
            Text(value)
                .font(.system(size: 17, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(tint)
                .shadow(color: tint.opacity(0.4), radius: 5, y: 3)
        )
    }
}


struct CulinaryMemoryCardView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F5F0EB")
                    .ignoresSafeArea()

                VStack(spacing: 22) {
                    Spacer()

                    Image("logo_culinary")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .cornerRadius(20)
                        .shadow(color: Color(hex: "#E8472A").opacity(0.2), radius: 12, y: 6)

                    VStack(spacing: 6) {
                        Text("CULINARY MEMORY CARD")
                            .font(.system(size: 25, weight: .black, design: .rounded))
                            .foregroundColor(Color(hex: "#1C1C1E"))
                        Text("Match pairs of kitchen utensils!")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(Color(hex: "#8E8E93"))
                            .multilineTextAlignment(.center)
                    }

                    Spacer().frame(height: 4)

                    VStack(spacing: 14) {
                        levelButton(level: 1, cards: 4, emoji: "🥄", subtitle: "Easy",
                                    gradient: [Color(red: 0.30, green: 0.78, blue: 0.55), Color(red: 0.18, green: 0.60, blue: 0.45)])
                        levelButton(level: 2, cards: 12, emoji: "🍳", subtitle: "Medium",
                                    gradient: [Color(red: 1.00, green: 0.55, blue: 0.20), Color(red: 0.95, green: 0.35, blue: 0.20)])
                        levelButton(level: 3, cards: 20, emoji: "🔥", subtitle: "Hard",
                                    gradient: [Color(red: 0.85, green: 0.20, blue: 0.45), Color(red: 0.55, green: 0.10, blue: 0.35)])
                    }
                    .padding(.horizontal, 24)

                    Spacer()
                }
            }
        }
    }

    @ViewBuilder
    private func levelButton(level: Int, cards: Int, emoji: String, subtitle: String, gradient: [Color]) -> some View {
        NavigationLink(destination: CulinaryGameView(level: level)) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 48, height: 48)
                    Text(emoji).font(.system(size: 28))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Level \(level)")
                        .font(.system(.headline, design: .rounded).bold())
                    Text(subtitle)
                        .font(.system(.caption, design: .rounded))
                        .opacity(0.85)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(cards)")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                    Text("cards")
                        .font(.system(.caption2, design: .rounded))
                        .opacity(0.85)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .opacity(0.8)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(
                LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: gradient.last!.opacity(0.45), radius: 10, y: 6)
        }
    }
}

#Preview {
    CulinaryMemoryCardView()
}
