import SwiftUI
import Combine


struct HapticHelper {
    static func triggerLight() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }
    
    static func triggerError() {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        #endif
    }
}


struct TVETTheme {
    static let creamBackground = Color(red: 0.96, green: 0.95, blue: 0.92)
    static let terracotta = Color(red: 0.82, green: 0.35, blue: 0.18)
    static let darkSlate = Color(red: 0.15, green: 0.17, blue: 0.20)
    static let obstacleSlate = Color(red: 0.08, green: 0.09, blue: 0.11)
    static let tileBorder = Color(red: 0.85, green: 0.83, blue: 0.78)
    static let dangerRed = Color(red: 0.90, green: 0.15, blue: 0.15)
    static let activeGreen = Color(red: 0.24, green: 0.54, blue: 0.36)
    static let linkPurple = Color(red: 0.55, green: 0.28, blue: 0.80)
    static let textDark = Color(red: 0.15, green: 0.15, blue: 0.15)
    static let cardWhite = Color(red: 0.98, green: 0.98, blue: 0.97)
    static let highlightPC = Color(red: 0.12, green: 0.68, blue: 0.85)
    static let highlightMalware = Color(red: 0.90, green: 0.15, blue: 0.15)
    static let highlightMaintenance = Color(red: 192 / 255.0, green: 243 / 255.0, blue: 191 / 255.0) // #C0F3BF
    static let highlightLocked = Color(red: 0.75, green: 0.55, blue: 0.20)
}

enum TileTemplateType: Equatable {
    case pc
    case straight(Double)
    case corner(Double)
    case junction(Double)
    case router
    case blank
    case malwarePc
    case lockedStraight(Double)
    case lockedCorner(Double)
    case maintenanceGrid
    case linkedStraight(Double, Int)
    case linkedCorner(Double, Int)
}

struct GridTile: Identifiable {
    let id = UUID()
    let row: Int
    let col: Int
    var templateType: TileTemplateType
    var rotationAngle: Double
    var isActive: Bool = false
    var isCured: Bool = false
    var linkGroupId: Int? = nil
}

struct LevelData {
    let id: Int
    let name: String
    let description: String
    let layout: [[TileTemplateType]]
}

class GameViewModel: ObservableObject {
    @Published var grid: [[GridTile]] = []
    @Published var currentLevelIndex: Int = 0
    @Published var isLevelComplete: Bool = false
    @Published var isSystemHacked: Bool = false
    @Published var tutorMessage: String = ""
    @Published var movesCount: Int = 0
    
    // Level Locking Progress (Unlocks indices based on successful completions)
    @Published var unlockedLevelIndices: Set<Int> = [0]
    
    // Countdown Penalty State
    @Published var countdownSeconds: Int = 5
    private var timerSubscription: AnyCancellable?
    
    let levels: [LevelData] = [
        LevelData(
            id: 1,
            name: "Level 1: Network Basics",
            description: "Click cables to rotate them and connect 2 PCs to the ROUTER to complete.",
            layout: [
                [.pc, .straight(0), .corner(90)],
                [.blank, .blank, .straight(90)],
                [.pc, .straight(0), .router]
            ]
        ),
        LevelData(
            id: 2,
            name: "Level 2: Switch and Stuck Cables",
            description: "Yellow cables are STUCK and cannot be rotated. Use the 3-way SWITCH (junction) to split connections. Connect 2 PCs to the ROUTER to complete.",
            layout: [
                [.pc,           .lockedStraight(90), .corner(90),   .blank,        .pc],
                [.blank,        .blank,              .straight(0),  .blank,        .straight(90)],
                [.blank,        .blank,              .junction(90), .straight(0),  .corner(0)],
                [.blank,        .blank,              .straight(90), .blank,        .straight(0)],
                [.blank,        .blank,              .corner(0),    .lockedStraight(90), .router]
            ]
        ),
        LevelData(
            id: 3,
            name: "Level 3: Tangled Networks",
            description: "Connect TWO PCs. Use Linked Wires (purple) which rotate together.",
            layout: [
                [.pc, .straight(90), .linkedCorner(0, 1), .straight(0), .corner(90), .pc],
                [.blank, .blank, .straight(0), .blank, .straight(0), .blank],
                [.blank, .blank, .linkedCorner(180, 1), .corner(90), .corner(180), .corner(0)],
                [.blank, .blank, .blank, .straight(0), .blank, .straight(0)],
                [.blank, .blank, .corner(0), .junction(0), .corner(270), .straight(90)],
                [.blank, .blank, .router, .blank, .corner(270), .corner(180)]
            ]
        ),
        LevelData(
            id: 4,
            name: "Level 4: System Bugs? Maintenance First!",
            description: "Oh no, there is a BUG in the PC network. Analyze and repair it by connecting to the service station. Connect 5 PCs, including the repaired bugged PCs.",
            layout: [
                [.blank, .pc, .straight(90), .linkedCorner(90, 1), .blank, .pc, .lockedCorner(180)],
                [.blank, .blank, .junction(90), .straight(90), .linkedStraight(0, 1), .straight(0), .straight(90)],
                [.malwarePc, .linkedCorner(90, 1), .corner(180), .junction(90), .straight(0), .junction(0), .malwarePc],
                [.blank, .corner(0), .junction(270), .router, .blank, .maintenanceGrid, .blank],
                [.pc, .lockedStraight(90), .corner(90), .junction(180), .corner(180), .straight(0), .blank],
                [.blank, .blank, .straight(0), .blank, .linkedStraight(0, 1), .blank, .blank],
                [.blank, .blank, .corner(270), .blank, .corner(0), .corner(270), .blank]
            ]
        ),
        LevelData(
            id: 5,
            name: "Level 5: Enterprise Server Grid",
            description: "Utilize all wire functions correctly. Connect all 7 PCs to the ROUTER.",
            layout: [
                [.pc, .straight(90), .junction(90), .straight(0), .pc, .straight(90), .lockedCorner(180), .pc],
                [.blank, .blank, .straight(0), .blank, .blank, .straight(90), .junction(270), .straight(0)],
                [.lockedCorner(90), .maintenanceGrid, .junction(0), .straight(90), .corner(90), .blank, .malwarePc, .linkedCorner(0, 1)],
                [.junction(90), .straight(0), .junction(180), .blank, .straight(0), .blank, .blank, .blank],
                [.pc, .linkedStraight(0, 1), .straight(90), .corner(0), .junction(90), .linkedCorner(0, 1), .straight(90), .blank],
                [.straight(90), .blank, .straight(0), .blank, .blank, .blank, .blank, .blank],
                [.malwarePc, .corner(270), .junction(180), .straight(0), .junction(180), .blank, .blank, .blank],
                [.straight(0), .junction(0), .corner(0), .blank, .lockedCorner(0), .straight(0), .junction(0), .router]
            ]
        )
    ]
    
    init() { loadLevel(index: 0) }
    
    func loadLevel(index: Int) {
        stopCountdown()
        currentLevelIndex = index
        let level = levels[index]
        
        self.isLevelComplete = false
        self.isSystemHacked = false
        
        grid = level.layout.enumerated().map { r, row in
            row.enumerated().map { c, template in
                let actualGroup = extractGroupId(from: template)
                
                var initialRotation: Double = 0
                switch template {
                case .straight(let rot), .corner(let rot), .junction(let rot), .lockedStraight(let rot), .lockedCorner(let rot), .linkedStraight(let rot, _), .linkedCorner(let rot, _):
                    initialRotation = rot
                default:
                    initialRotation = 0
                }
                
                return GridTile(
                    row: r,
                    col: c,
                    templateType: template,
                    rotationAngle: initialRotation,
                    linkGroupId: actualGroup
                )
            }
        }
        movesCount = 0
        tutorMessage = level.description
        evaluateConnections()
    }
    
    // FIXED: Modify the existing GridTile elements in-place instead of recreating them.
    // This preserves UUID structural identities so SwiftUI smoothly animates wire rotation angles back to default.
    func resetLevel() {
        stopCountdown()
        let level = levels[currentLevelIndex]
        self.isLevelComplete = false
        self.isSystemHacked = false
        
        for r in 0..<grid.count {
            for c in 0..<grid[r].count {
                let template = level.layout[r][c]
                var initialRotation: Double = 0
                switch template {
                case .straight(let rot), .corner(let rot), .junction(let rot), .lockedStraight(let rot), .lockedCorner(let rot), .linkedStraight(let rot, _), .linkedCorner(let rot, _):
                    initialRotation = rot
                default:
                    initialRotation = 0
                }
                
                grid[r][c].templateType = template
                grid[r][c].rotationAngle = initialRotation
                grid[r][c].isActive = false
                grid[r][c].isCured = false
            }
        }
        
        movesCount = 0
        evaluateConnections()
    }
    
    private func extractGroupId(from template: TileTemplateType) -> Int? {
        switch template {
        case .linkedStraight(_, let gID), .linkedCorner(_, let gID):
            return gID
        default:
            return nil
        }
    }
    
    func rotateTile(row: Int, col: Int) {
        guard !isLevelComplete else { return }
        let tile = grid[row][col]
        
        switch tile.templateType {
        case .straight(_), .corner(_), .junction(_), .linkedStraight(_, _), .linkedCorner(_, _):
            let rotateAngle: Double = 90
            movesCount += 1
            
            if let groupId = tile.linkGroupId {
                for r in 0..<grid.count {
                    for c in 0..<grid[r].count {
                        if grid[r][c].linkGroupId == groupId {
                            grid[r][c].rotationAngle = grid[r][c].rotationAngle + rotateAngle
                        }
                    }
                }
            } else {
                grid[row][col].rotationAngle = grid[row][col].rotationAngle + rotateAngle
            }
            evaluateConnections()
        default:
            return
        }
    }
    
    func evaluateConnections() {
        for r in 0..<grid.count {
            for c in 0..<grid[r].count {
                grid[r][c].isActive = false
                grid[r][c].isCured = false
            }
        }
        
        var queue: [(Int, Int)] = []
        var visited = Set<String>()
        
        for r in 0..<grid.count {
            for c in 0..<grid[r].count {
                if grid[r][c].templateType == .router {
                    queue.append((r, c))
                    visited.insert("\(r),\(c)")
                    grid[r][c].isActive = true
                }
            }
        }
        
        while !queue.isEmpty {
            let (r, c) = queue.removeFirst()
            let currentTile = grid[r][c]
            let currentExits = getExits(for: currentTile)
            
            let directions = [
                (rowOffset: -1, colOffset: 0, dirName: "UP"),
                (rowOffset: 1, colOffset: 0, dirName: "DOWN"),
                (rowOffset: 0, colOffset: -1, dirName: "LEFT"),
                (rowOffset: 0, colOffset: 1, dirName: "RIGHT")
            ]
            
            for d in directions {
                let nr = r + d.rowOffset
                let nc = c + d.colOffset
                
                guard nr >= 0, nr < grid.count, nc >= 0, nc < grid[nr].count else { continue }
                
                let neighborTile = grid[nr][nc]
                let coordKey = "\(nr),\(nc)"
                
                if !visited.contains(coordKey) {
                    let neighborExits = getExits(for: neighborTile)
                    let oppositeDir = getOppositeDirection(d.dirName)
                    
                    if currentExits.contains(d.dirName) && neighborExits.contains(oppositeDir) {
                        grid[nr][nc].isActive = true
                        visited.insert(coordKey)
                        queue.append((nr, nc))
                    }
                }
            }
        }
        
        var activeMaintenanceCoords: [(Int, Int)] = []
        for r in 0..<grid.count {
            for c in 0..<grid[r].count {
                if case .maintenanceGrid = grid[r][c].templateType, grid[r][c].isActive {
                    activeMaintenanceCoords.append((r, c))
                }
            }
        }
        
        for r in 0..<grid.count {
            for c in 0..<grid[r].count {
                if grid[r][c].templateType == .malwarePc && grid[r][c].isActive {
                    let cured = checkCurePath(startRow: r, startCol: c, activeMaintenance: activeMaintenanceCoords)
                    grid[r][c].isCured = cured
                }
            }
        }
        
        var reachedMalwareWithoutCure = false
        for r in 0..<grid.count {
            for c in 0..<grid[r].count {
                if grid[r][c].templateType == .malwarePc && grid[r][c].isActive && !grid[r][c].isCured {
                    reachedMalwareWithoutCure = true
                }
            }
        }
        
        self.isSystemHacked = reachedMalwareWithoutCure
        
        // Timer countdown management
        if isSystemHacked {
            startCountdown()
        } else {
            stopCountdown()
        }
        
        var totalCleanPCs = 0
        var activeCleanPCs = 0
        var totalMalwarePCs = 0
        var activeCuredMalwarePCs = 0
        
        for r in 0..<grid.count {
            for c in 0..<grid[r].count {
                if grid[r][c].templateType == .pc {
                    totalCleanPCs += 1
                    if grid[r][c].isActive {
                        activeCleanPCs += 1
                    }
                } else if grid[r][c].templateType == .malwarePc {
                    totalMalwarePCs += 1
                    if grid[r][c].isActive && grid[r][c].isCured {
                        activeCuredMalwarePCs += 1
                    }
                }
            }
        }
        
        if isSystemHacked {
            tutorMessage = "⚠️ MALWARE BREACHED! Route connections to the Maintenance station (Blue) to disinfect it!"
        } else if totalCleanPCs > 0 && activeCleanPCs == totalCleanPCs && activeCuredMalwarePCs == totalMalwarePCs && !isSystemHacked {
            isLevelComplete = true
            tutorMessage = "Success! The network is fully secured and operational!"
            
            // Mark the next level as unlocked
            let nextIndex = currentLevelIndex + 1
            if nextIndex < levels.count {
                _ = unlockedLevelIndices.insert(nextIndex)
            }
        } else {
            tutorMessage = levels[currentLevelIndex].description
        }
    }
    
    // MARK: - Countdown Mechanisms
    private func startCountdown() {
        guard timerSubscription == nil else { return }
        countdownSeconds = 5
        
        timerSubscription = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.countdownSeconds > 1 {
                    self.countdownSeconds -= 1
                    HapticHelper.triggerLight()
                } else {
                    // Trigger level reset penalty when timer expires
                    self.stopCountdown()
                    HapticHelper.triggerError()
                    
                    // FIXED: Animating the automatic countdown-based level reset cleanly back to zero!
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.75)) {
                        self.resetLevel()
                    }
                }
            }
    }
    
    private func stopCountdown() {
        timerSubscription?.cancel()
        timerSubscription = nil
        countdownSeconds = 5
    }
    
    private func checkCurePath(startRow: Int, startCol: Int, activeMaintenance: [(Int, Int)]) -> Bool {
        guard !activeMaintenance.isEmpty else { return false }
        
        var queue = [(startRow, startCol)]
        var visited = Set<String>(["\(startRow),\(startCol)"])
        
        while !queue.isEmpty {
            let (r, c) = queue.removeFirst()
            
            if activeMaintenance.contains(where: { $0.0 == r && $0.1 == c }) {
                return true
            }
            
            let exits = getExits(for: grid[r][c])
            let directions = [
                (rowOffset: -1, colOffset: 0, dirName: "UP"),
                (rowOffset: 1, colOffset: 0, dirName: "DOWN"),
                (rowOffset: 0, colOffset: -1, dirName: "LEFT"),
                (rowOffset: 0, colOffset: 1, dirName: "RIGHT")
            ]
            
            for d in directions {
                let nr = r + d.rowOffset
                let nc = c + d.colOffset
                
                guard nr >= 0, nr < grid.count, nc >= 0, nc < grid[nr].count else { continue }
                
                let neighborTile = grid[nr][nc]
                let coordKey = "\(nr),\(nc)"
                
                if neighborTile.isActive && !visited.contains(coordKey) {
                    let neighborExits = getExits(for: neighborTile)
                    let oppositeDir = getOppositeDirection(d.dirName)
                    
                    if exits.contains(d.dirName) && neighborExits.contains(oppositeDir) {
                        visited.insert(coordKey)
                        queue.append((nr, nc))
                    }
                }
            }
        }
        
        return false
    }
    
    private func getExits(for tile: GridTile) -> Set<String> {
        var exits = Set<String>()
        // Safely normalize degrees down to [0, 360) mathematically
        let angle = (Int(tile.rotationAngle) % 360 + 360) % 360
        
        switch tile.templateType {
        case .pc, .router, .malwarePc, .maintenanceGrid:
            exits.insert("UP")
            exits.insert("DOWN")
            exits.insert("LEFT")
            exits.insert("RIGHT")
            
        case .straight(_), .lockedStraight(_), .linkedStraight(_, _):
            if angle == 90 || angle == 270 {
                exits.insert("LEFT")
                exits.insert("RIGHT")
            } else {
                exits.insert("UP")
                exits.insert("DOWN")
            }
            
        case .corner(_), .lockedCorner(_), .linkedCorner(_, _):
            switch angle {
            case 0:
                exits.insert("UP")
                exits.insert("RIGHT")
            case 90:
                exits.insert("RIGHT")
                exits.insert("DOWN")
            case 180:
                exits.insert("DOWN")
                exits.insert("LEFT")
            case 270:
                exits.insert("LEFT")
                exits.insert("UP")
            default:
                break
            }
            
        case .junction(_):
            switch angle {
            case 0:
                exits.insert("LEFT")
                exits.insert("RIGHT")
                exits.insert("UP")
            case 90:
                exits.insert("UP")
                exits.insert("DOWN")
                exits.insert("RIGHT")
            case 180:
                exits.insert("LEFT")
                exits.insert("RIGHT")
                exits.insert("DOWN")
            case 270:
                exits.insert("UP")
                exits.insert("DOWN")
                exits.insert("LEFT")
            default:
                break
            }
            
        case .blank:
            break
        }
        return exits
    }
    
    private func getOppositeDirection(_ direction: String) -> String {
        switch direction {
        case "UP": return "DOWN"
        case "DOWN": return "UP"
        case "LEFT": return "RIGHT"
        case "RIGHT": return "LEFT"
        default: return ""
        }
    }
}

// MARK: - Navigation Control State
enum GameScreen {
    case mainMenu
    case activePuzzle
}

// MARK: - User Interface View
struct RotateTheRouteView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var activeScreen: GameScreen = .mainMenu
    
    var body: some View {
        ZStack {
            TVETTheme.creamBackground.ignoresSafeArea()
            
            switch activeScreen {
            case .mainMenu:
                MainMenuView(viewModel: viewModel, activeScreen: $activeScreen)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                
            case .activePuzzle:
                PuzzleSimulatorView(viewModel: viewModel, activeScreen: $activeScreen)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.8), value: activeScreen)
    }
}

// MARK: - Main Menu Screen
struct MainMenuView: View {
    @ObservedObject var viewModel: GameViewModel
    @Binding var activeScreen: GameScreen
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 10)
            
            // App Title Block
            VStack(spacing: 4) {
                Text("TVET IT ACADEMY")
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(TVETTheme.terracotta)
                    .tracking(2.5)
                
                Text("Byte-Sized Builder")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(TVETTheme.textDark)
                
                Text("Vocation Security Simulator")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(TVETTheme.textDark.opacity(0.5))
            }
            .padding(.top, 24)
            
            // Graphic Card Intro
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("👨‍🏫 Instructor Briefing")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(.white.opacity(0.85))
                        .tracking(1)
                    Spacer()
                }
                Text("Welcome to the Academy Lab! To graduate from the IT infrastructure courses, you must successfully restore routing terminals while isolating real-time malware breaches.")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .lineSpacing(4)
            }
            .padding(.all, 18)
            .background(TVETTheme.terracotta)
            .cornerRadius(18)
            .padding(.horizontal, 20)
            
            // Level Selector Title
            HStack {
                Text("Select Lab Assignment")
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundColor(TVETTheme.textDark)
                Spacer()
                Text("\(viewModel.unlockedLevelIndices.count)/\(viewModel.levels.count) Completed")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(TVETTheme.terracotta)
            }
            .padding(.horizontal, 24)
            
            // Level Selector List with Strict Lock Logic
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(0..<viewModel.levels.count, id: \.self) { idx in
                        let isUnlocked = viewModel.unlockedLevelIndices.contains(idx)
                        let level = viewModel.levels[idx]
                        
                        Button(action: {
                            if isUnlocked {
                                HapticHelper.triggerLight()
                                withAnimation {
                                    viewModel.loadLevel(index: idx)
                                    activeScreen = .activePuzzle
                                }
                            } else {
                                HapticHelper.triggerError()
                            }
                        }) {
                            HStack(spacing: 16) {
                                // Status Icon Indicator
                                ZStack {
                                    Circle()
                                        .fill(isUnlocked ? TVETTheme.terracotta.opacity(0.15) : Color.gray.opacity(0.1))
                                        .frame(width: 44, height: 44)
                                    
                                    if isUnlocked {
                                        Text("\(idx + 1)")
                                            .font(.system(size: 16, weight: .black, design: .rounded))
                                            .foregroundColor(TVETTheme.terracotta)
                                    } else {
                                        Image(systemName: "lock.fill")
                                            .font(.system(size: 15))
                                            .foregroundColor(TVETTheme.highlightLocked)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(level.name)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(isUnlocked ? TVETTheme.textDark : TVETTheme.textDark.opacity(0.4))
                                    Text(level.description)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(isUnlocked ? TVETTheme.textDark.opacity(0.6) : TVETTheme.textDark.opacity(0.3))
                                        .lineLimit(1)
                                }
                                
                                Spacer()
                                
                                if isUnlocked {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(TVETTheme.terracotta.opacity(0.7))
                                }
                            }
                            .padding(.all, 14)
                            .background(TVETTheme.cardWhite)
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(isUnlocked ? TVETTheme.tileBorder : Color.gray.opacity(0.15), lineWidth: 1)
                            )
                        }
                        .disabled(!isUnlocked)
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
    }
}

// MARK: - Puzzle Simulator View
struct PuzzleSimulatorView: View {
    @ObservedObject var viewModel: GameViewModel
    @Binding var activeScreen: GameScreen
    
    var body: some View {
        VStack(spacing: 16) {
            // Header bar containing Back to Menu and Active Status details
            HStack(alignment: .center) {
                Button(action: {
                    HapticHelper.triggerLight()
                    withAnimation {
                        activeScreen = .mainMenu
                    }
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 13, weight: .black))
                        Text("Menu")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .foregroundColor(TVETTheme.terracotta)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(TVETTheme.cardWhite)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(TVETTheme.tileBorder, lineWidth: 1)
                    )
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("ACTIVE LAB")
                        .font(.system(size: 9, weight: .heavy))
                        .foregroundColor(TVETTheme.terracotta)
                    Text("Assignment \(viewModel.currentLevelIndex + 1)/\(viewModel.levels.count)")
                        .font(.system(size: 12, weight: .black, design: .rounded))
                        .foregroundColor(TVETTheme.textDark)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            // Instructions / Tutor Banner with Integrated Warning Stack and Countdown
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("INSTRUCTOR DIRECTIVES")
                            .font(.system(size: 10, weight: .heavy))
                            .foregroundColor(.white.opacity(0.85))
                            .tracking(1.5)
                        
                        Text(viewModel.tutorMessage)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .lineSpacing(3)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                    Text("👨‍🏫")
                        .font(.system(size: 28))
                }
                
                // Display Warning with real-time 5s Countdown Penalty
                if viewModel.isSystemHacked {
                    VStack(alignment: .leading, spacing: 6) {
                        Divider()
                            .background(Color.white.opacity(0.4))
                            .padding(.vertical, 2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 6) {
                                Text("🚨")
                                    .font(.system(size: 14))
                                Text("BREACH NOTICE:")
                                    .font(.system(size: 11, weight: .black))
                                    .foregroundColor(.white)
                                    .tracking(1)
                            }
                            
                            // Countdown Display directly below the notification title
                            HStack(spacing: 4) {
                                Image(systemName: "timer")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.yellow)
                                Text("Resetting in: \(viewModel.countdownSeconds) seconds")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(.yellow)
                            }
                            .padding(.vertical, 2)
                        }
                        
                        Text("Malware connected without maintenance containment! Please connect the Maintenance station (Blue) immediately.")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.95))
                            .lineSpacing(2)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(.all, 16)
            .background(viewModel.isSystemHacked ? TVETTheme.dangerRed : TVETTheme.terracotta)
            .cornerRadius(20)
            .padding(.horizontal, 16)
            .animation(.easeInOut, value: viewModel.isSystemHacked)
            
            // Dashboard Info Panel
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "hand.tap.fill")
                        .foregroundColor(TVETTheme.terracotta)
                        .font(.system(size: 12))
                    Text("Moves: ")
                        .foregroundColor(TVETTheme.textDark.opacity(0.7))
                    Text("\(viewModel.movesCount)")
                        .fontWeight(.bold)
                        .foregroundColor(TVETTheme.textDark)
                }
                .font(.system(size: 12))
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(TVETTheme.cardWhite)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(TVETTheme.tileBorder, lineWidth: 1)
                )
                
                Spacer()
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(viewModel.isSystemHacked ? TVETTheme.dangerRed : (viewModel.isLevelComplete ? TVETTheme.activeGreen : Color.orange))
                        .frame(width: 8, height: 8)
                    Text(viewModel.isSystemHacked ? "BREACHED" : (viewModel.isLevelComplete ? "SECURED" : "PENDING"))
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(viewModel.isSystemHacked ? TVETTheme.dangerRed : (viewModel.isLevelComplete ? TVETTheme.activeGreen : Color.orange))
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(TVETTheme.cardWhite)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(TVETTheme.tileBorder, lineWidth: 1)
                )
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Level Title and Compact Reset Button positioned barely above the grid area
            HStack(alignment: .center) {
                Text(viewModel.levels[viewModel.currentLevelIndex].name)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(TVETTheme.textDark)
                    .lineLimit(1)
                
                Spacer()
                
                Button(action: {
                    // FIXED: Re-enabling modular clockwise/counter-clockwise unwinding instead of snap flash
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.75)) {
                        viewModel.resetLevel() // Restores directly with a clockwise spring rollback!
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 10, weight: .bold))
                        Text("Reset")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(TVETTheme.darkSlate)
                    .cornerRadius(8)
                    .shadow(color: TVETTheme.darkSlate.opacity(0.15), radius: 3)
                }
            }
            .padding(.horizontal, 20)
            
            // Interactive Sandbox Grid
            let gridCount = viewModel.grid.count
            let tileSize: CGFloat = {
                if gridCount == 3 { return 90 }
                else if gridCount == 5 { return 56 }
                else if gridCount == 6 { return 46 }
                else { return canvasGridMeasurement(size: gridCount) }
            }()
            
            VStack(spacing: 6) {
                ForEach(0..<viewModel.grid.count, id: \.self) { r in
                    HStack(spacing: 6) {
                        ForEach(0..<viewModel.grid[r].count, id: \.self) { c in
                            TileButton(tile: viewModel.grid[r][c], size: tileSize) {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                                    viewModel.rotateTile(row: r, col: c)
                                }
                            }
                            .id(viewModel.grid[r][c].id)
                        }
                    }
                }
            }
            .padding(12)
            .background(TVETTheme.cardWhite)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(TVETTheme.tileBorder, lineWidth: 1.5)
            )
            .padding(.horizontal, 16)
            
            Spacer()
            
            // Game Status Completion Banner
            if viewModel.isLevelComplete {
                VStack(spacing: 10) {
                    Text("🎉 LEVEL COMPLETED SUCCESSFULLY!")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(TVETTheme.activeGreen)
                        .tracking(1)
                    
                    HStack(spacing: 12) {
                        // Return to Menu Button
                        Button(action: {
                            HapticHelper.triggerLight()
                            withAnimation {
                                activeScreen = .mainMenu
                            }
                        }) {
                            Text("Main Menu")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(TVETTheme.textDark)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(Color.gray.opacity(0.15))
                                .cornerRadius(8)
                        }
                        
                        if viewModel.currentLevelIndex + 1 < viewModel.levels.count {
                            // Proceed to Next Unlocked Stage
                            Button(action: {
                                withAnimation {
                                    viewModel.loadLevel(index: viewModel.currentLevelIndex + 1)
                                }
                            }) {
                                Text("Next Level")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                    .background(TVETTheme.terracotta)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(TVETTheme.activeGreen.opacity(0.1))
                .cornerRadius(16)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            } else {
                Spacer().frame(height: 12)
            }
        }
    }
    
    // Helper function for responsive calculation
    private func canvasGridMeasurement(size: Int) -> CGFloat {
        if size == 7 { return 38 }
        return 30
    }
}

// MARK: - Grid Tile Component View
struct TileButton: View {
    let tile: GridTile
    let size: CGFloat
    let action: () -> Void
    
    private var isInteractable: Bool {
        switch tile.templateType {
        case .straight(_), .corner(_), .junction(_), .linkedStraight(_, _), .linkedCorner(_, _):
            return true
        default:
            return false
        }
    }
    
    private var isLinked: Bool {
        tile.linkGroupId != nil
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                let tileBg: Color = {
                    if case .blank = tile.templateType { return TVETTheme.obstacleSlate }
                    if case .maintenanceGrid = tile.templateType {
                        return tile.isActive ? TVETTheme.highlightMaintenance.opacity(0.2) : TVETTheme.darkSlate
                    }
                    return TVETTheme.darkSlate
                }()
                
                let tileBorderColor: Color = {
                    if case .blank = tile.templateType { return TVETTheme.obstacleSlate }
                    if isLinked { return TVETTheme.linkPurple }
                    if tile.templateType == .malwarePc && tile.isActive {
                        return tile.isCured ? TVETTheme.activeGreen : TVETTheme.highlightMalware
                    }
                    if tile.isActive { return TVETTheme.activeGreen }
                    
                    switch tile.templateType {
                    case .pc: return TVETTheme.highlightPC
                    case .maintenanceGrid: return TVETTheme.highlightMaintenance
                    case .malwarePc: return TVETTheme.highlightMalware
                    case .lockedStraight(_), .lockedCorner(_): return TVETTheme.highlightLocked
                    default: return TVETTheme.terracotta.opacity(0.3)
                    }
                }()
                
                RoundedRectangle(cornerRadius: size * 0.18)
                    .fill(tileBg)
                    .frame(width: size, height: size)
                    .overlay(
                        RoundedRectangle(cornerRadius: size * 0.18)
                            .stroke(tileBorderColor, lineWidth: isLinked ? 2.2 : 1.8)
                    )
                    .shadow(color: isLinked ? TVETTheme.linkPurple.opacity(0.3) : Color.black.opacity(0.08), radius: isLinked ? 3 : 0)
                
                switch tile.templateType {
                case .pc:
                    VStack(spacing: size * 0.04) {
                        Image(systemName: "desktopcomputer")
                            .font(.system(size: size * 0.35, weight: .bold))
                            .foregroundColor(TVETTheme.highlightPC)
                        if size > 32 {
                            Text("PC")
                                .font(.system(size: size * 0.12, weight: .bold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                case .router:
                    VStack(spacing: size * 0.04) {
                        Image(systemName: "wifi.router.fill")
                            .font(.system(size: size * 0.35, weight: .bold))
                            .foregroundColor(tile.isActive ? TVETTheme.activeGreen : .white)
                        if size > 32 {
                            Text("Router")
                                .font(.system(size: size * 0.11, weight: .bold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                case .straight(_), .lockedStraight(_), .linkedStraight(_, _):
                    ZStack {
                        let isLocked: Bool = {
                            if case .lockedStraight(_) = tile.templateType { return true }
                            return false
                        }()
                        
                        let wireColor: Color = {
                            if tile.isActive {
                                return isLocked ? TVETTheme.highlightLocked : TVETTheme.activeGreen
                            } else if isLocked {
                                return TVETTheme.highlightLocked
                            } else {
                                return Color.gray.opacity(0.5)
                            }
                        }()
                        
                        Rectangle()
                            .fill(wireColor)
                            .frame(width: size * 0.15, height: size)
                        
                        if isLocked {
                            Image(systemName: "lock.fill")
                                .font(.system(size: size * 0.22, weight: .bold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        if isLinked {
                            Image(systemName: "link")
                                .font(.system(size: size * 0.22, weight: .bold))
                                .foregroundColor(.white.opacity(0.9))
                                .shadow(color: .black, radius: 1)
                        }
                    }
                    .rotationEffect(.degrees(tile.rotationAngle))
                    
                case .corner(_), .lockedCorner(_), .linkedCorner(_, _):
                    ZStack {
                        let isLocked: Bool = {
                            if case .lockedCorner(_) = tile.templateType { return true }
                            return false
                        }()
                        
                        let wireColor: Color = {
                            if tile.isActive {
                                return isLocked ? TVETTheme.highlightLocked : TVETTheme.activeGreen
                            } else if isLocked {
                                return TVETTheme.highlightLocked
                            } else {
                                return Color.gray.opacity(0.5)
                            }
                        }()
                        
                        GeometryReader { geo in
                            Path { path in
                                path.move(to: CGPoint(x: geo.size.width / 2, y: 0))
                                path.addLine(to: CGPoint(x: geo.size.width / 2, y: geo.size.height / 2))
                                path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height / 2))
                            }
                            .stroke(wireColor, lineWidth: size * 0.15)
                        }
                        
                        if isLocked {
                            Image(systemName: "lock.fill")
                                .font(.system(size: size * 0.22, weight: .bold))
                                .foregroundColor(.white.opacity(0.8))
                                .offset(x: size * 0.12, y: -size * 0.12)
                        }
                        
                        if isLinked {
                            Image(systemName: "link")
                                .font(.system(size: size * 0.22, weight: .bold))
                                .foregroundColor(.white.opacity(0.9))
                                .shadow(color: .black, radius: 1)
                                .offset(x: size * 0.12, y: -size * 0.12)
                        }
                    }
                    .frame(width: size, height: size)
                    .rotationEffect(.degrees(tile.rotationAngle))
                    
                case .junction(_):
                    ZStack {
                        Rectangle()
                            .fill(tile.isActive ? TVETTheme.activeGreen : Color.gray.opacity(0.5))
                            .frame(width: size, height: size * 0.15)
                        Rectangle()
                            .fill(tile.isActive ? TVETTheme.activeGreen : Color.gray.opacity(0.5))
                            .frame(width: size * 0.15, height: size * 0.5)
                            .offset(y: -size * 0.25)
                    }
                    .frame(width: size, height: size)
                    .rotationEffect(.degrees(tile.rotationAngle))
                    
                case .blank:
                    ZStack {
                        GeometryReader { geo in
                            Path { p in
                                let steps = Int(geo.size.width / 8)
                                for i in 0...steps {
                                    let offset = CGFloat(i * 8)
                                    p.move(to: CGPoint(x: offset, y: 0))
                                    p.addLine(to: CGPoint(x: 0, y: offset))
                                    p.move(to: CGPoint(x: geo.size.width, y: offset))
                                    p.addLine(to: CGPoint(x: offset, y: geo.size.height))
                                }
                            }
                            .stroke(Color.yellow.opacity(0.2), lineWidth: 1.5)
                        }
                        Image(systemName: "square.slash.fill")
                            .font(.system(size: size * 0.28, weight: .bold))
                            .foregroundColor(TVETTheme.terracotta.opacity(0.7))
                    }
                    .frame(width: size, height: size)
                    
                case .malwarePc:
                    VStack(spacing: size * 0.04) {
                        Image(systemName: tile.isCured ? "checkmark.shield.fill" : (tile.isActive ? "ladybug.fill" : "ladybug"))
                            .font(.system(size: size * 0.35, weight: .bold))
                            .foregroundColor(tile.isCured ? TVETTheme.activeGreen : TVETTheme.highlightMalware)
                        if size > 32 {
                            Text(tile.isCured ? "SECURED" : "BUGGED")
                                .font(.system(size: size * 0.09, weight: .black))
                                .foregroundColor(tile.isCured ? TVETTheme.activeGreen : TVETTheme.highlightMalware)
                        }
                    }
                    .scaleEffect((tile.isActive && !tile.isCured) ? 1.05 : 1.0)
                    
                case .maintenanceGrid:
                    ZStack {
                        VStack(spacing: size * 0.04) {
                            Image(systemName: "wrench.and.screwdriver.fill")
                                .font(.system(size: size * 0.32, weight: .bold))
                                .foregroundColor(TVETTheme.darkSlate)
                            if size > 32 {
                                Text("MAINTENANCE")
                                    .font(.system(size: size * 0.09, weight: .bold))
                                    .foregroundColor(TVETTheme.darkSlate)
                            }
                        }
                        Circle()
                            .stroke(tile.isActive ? TVETTheme.activeGreen : TVETTheme.highlightMaintenance.opacity(0.5), lineWidth: size * 0.06)
                            .frame(width: size * 0.7, height: size * 0.7)
                    }
                }
            }
        }
        .disabled(!isInteractable)
    }
}

// MARK: - Xcode Preview
struct RotateTheRouteView_Previews: PreviewProvider {
    static var previews: some View {
        RotateTheRouteView()
    }
}
