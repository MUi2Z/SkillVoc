import SwiftUI
import Combine
import UniformTypeIdentifiers

// MARK: - Volt Quest Theme
// Renamed from "Theme" to "VoltTheme" to avoid clashing with other game themes
struct VoltTheme {
    static let backgroundGray = Color(hex: "F1EFE8")
    static let powerCoral = Color(hex: "D85A30")
    static let textDark = Color(hex: "2C2C2E")
    static let white = Color.white
}

// MARK: - 1. DATA MODELS
enum VoltComponentType: String, CaseIterable {
    case battery = "battery"
    case led = "led"
    case switchComp = "switch"
    case wire = "wire"
}

enum VoltTerminalType: String {
    case positive = "+"
    case negative = "-"
    case input = "in"
    case output = "out"
}

struct VoltTerminal: Identifiable, Hashable {
    let id = UUID()
    var componentId: UUID
    let type: VoltTerminalType
    var position: CGPoint
    var connectedTo: UUID?
}

struct VoltPlacedComponent: Identifiable {
    let id = UUID()
    let type: VoltComponentType
    var location: CGPoint
    var terminals: [VoltTerminal]
    var isSwitchOn: Bool = false

    init(type: VoltComponentType, location: CGPoint) {
        self.type = type
        self.location = location
        self.terminals = VoltPlacedComponent.createTerminals(for: type, location: location)
    }

    static func createTerminals(for type: VoltComponentType, location: CGPoint) -> [VoltTerminal] {
        switch type {
        case .battery:
            return [
                VoltTerminal(componentId: UUID(), type: .positive, position: CGPoint(x: 30, y: -20), connectedTo: nil),
                VoltTerminal(componentId: UUID(), type: .negative, position: CGPoint(x: 30, y: 20), connectedTo: nil)
            ]
        case .led:
            return [
                VoltTerminal(componentId: UUID(), type: .positive, position: CGPoint(x: -25, y: -15), connectedTo: nil),
                VoltTerminal(componentId: UUID(), type: .negative, position: CGPoint(x: -25, y: 15), connectedTo: nil)
            ]
        case .switchComp:
            return [
                VoltTerminal(componentId: UUID(), type: .input, position: CGPoint(x: -25, y: 0), connectedTo: nil),
                VoltTerminal(componentId: UUID(), type: .output, position: CGPoint(x: 25, y: 0), connectedTo: nil)
            ]
        case .wire:
            return [
                VoltTerminal(componentId: UUID(), type: .input, position: CGPoint(x: -30, y: 0), connectedTo: nil),
                VoltTerminal(componentId: UUID(), type: .output, position: CGPoint(x: 30, y: 0), connectedTo: nil)
            ]
        }
    }
}

// Renamed from "GameLevel" to "VoltGameLevel" to avoid clashing with Game3's GameLevel
struct VoltGameLevel: Identifiable {
    let id: Int
    let title: String
    let objective: String
    let requiredComponents: [VoltComponentType]
    let initialComponents: [VoltComponentType]

    static let levels: [VoltGameLevel] = [
        VoltGameLevel(id: 1, title: "First Light", objective: "Connect the Battery to the LED to light it up!", requiredComponents: [.battery, .led], initialComponents: [.battery]),
        VoltGameLevel(id: 2, title: "Switch It On", objective: "Add a Switch to control the power flow!", requiredComponents: [.battery, .led, .switchComp], initialComponents: [.battery]),
        VoltGameLevel(id: 3, title: "Bridge the Gap", objective: "Use a Wire to connect the Battery and LED!", requiredComponents: [.battery, .led, .wire], initialComponents: [.battery, .led]),
        VoltGameLevel(id: 4, title: "Double Trouble", objective: "Light up 2 LEDs in a series circuit!", requiredComponents: [.battery, .led, .led], initialComponents: [.battery]),
        VoltGameLevel(id: 5, title: "Circuit Master", objective: "Build a complex circuit using a Switch and 2 LEDs!", requiredComponents: [.battery, .led, .led, .switchComp], initialComponents: [.battery])
    ]
}

// MARK: - 2. TUTORIAL SYSTEM
struct VoltTutorialPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
}

class VoltTutorialManager: ObservableObject {
    @Published var showTutorial: Bool = false
    @Published var currentPage: Int = 0

    let pages: [VoltTutorialPage] = [
        VoltTutorialPage(title: "Welcome to Volt Quest!", description: "Learn how to build circuits and power LEDs. Let's get started!", iconName: "bolt.fill"),
        VoltTutorialPage(title: "Drag Components", description: "Drag items from the toolbox at the bottom onto the breadboard.", iconName: "hand.tap.fill"),
        VoltTutorialPage(title: "Connect Terminals", description: "Tap an orange dot (terminal), then tap another dot to connect them with a wire.", iconName: "link"),
        VoltTutorialPage(title: "Use the Switch", description: "Tap a switch to toggle it ON or OFF.", iconName: "power"),
        VoltTutorialPage(title: "Delete Items", description: "Long press any component to remove it from the board.", iconName: "trash"),
        VoltTutorialPage(title: "Complete the Circuit", description: "Connect Battery (+) to LED (+), and LED (-) to Battery (-) to power it up!", iconName: "lightbulb.fill")
    ]

    func nextPage() {
        if currentPage < pages.count - 1 { currentPage += 1 } else { closeTutorial() }
    }

    func previousPage() {
        if currentPage > 0 { currentPage -= 1 }
    }

    func closeTutorial() {
        showTutorial = false
        currentPage = 0
        UserDefaults.standard.set(true, forKey: "voltquest_hasSeenTutorial")
    }

    func shouldShowTutorial() -> Bool {
        return !UserDefaults.standard.bool(forKey: "voltquest_hasSeenTutorial")
    }
}

// MARK: - 3. LEVEL MANAGER
// Renamed from "LevelManager" to "VoltLevelManager" to avoid clashing with other games
class VoltLevelManager: ObservableObject {
    @Published var currentLevelIndex: Int = 0
    @Published var isLevelComplete: Bool = false
    @Published var showObjective: Bool = true

    var currentLevel: VoltGameLevel { VoltGameLevel.levels[currentLevelIndex] }
    var isLastLevel: Bool { currentLevelIndex >= VoltGameLevel.levels.count - 1 }

    func nextLevel() {
        if !isLastLevel {
            currentLevelIndex += 1
            isLevelComplete = false
            showObjective = true
        }
    }

    func resetGame() {
        currentLevelIndex = 0
        isLevelComplete = false
        showObjective = true
    }

    func checkWinCondition(engine: VoltCircuitEngine) {
        if engine.isPowered {
            let usedTypes = engine.placedComponents.map { $0.type }
            let allRequiredUsed = currentLevel.requiredComponents.allSatisfy { usedTypes.contains($0) }
            if allRequiredUsed { isLevelComplete = true; showObjective = false }
        }
    }
}

// MARK: - 4. CIRCUIT ENGINE
// Renamed from "CircuitEngine" to "VoltCircuitEngine"
class VoltCircuitEngine: ObservableObject {
    @Published var placedComponents: [VoltPlacedComponent] = []
    @Published var isPowered: Bool = false
    @Published var selectedTerminal: VoltTerminal?
    @Published var connections: [(from: UUID, to: UUID)] = []

    func addComponent(_ type: VoltComponentType, at location: CGPoint) {
        var component = VoltPlacedComponent(type: type, location: location)
        component.terminals = component.terminals.map { terminal in
            var updated = terminal
            updated.componentId = component.id
            return updated
        }
        self.placedComponents.append(component)
        validateCircuit()
    }

    func removeComponent(_ id: UUID) {
        self.placedComponents.removeAll { $0.id == id }
        self.connections.removeAll { $0.from == id || $0.to == id }
        validateCircuit()
    }

    func toggleSwitch(_ id: UUID) {
        if let index = placedComponents.firstIndex(where: { $0.id == id }) {
            placedComponents[index].isSwitchOn.toggle()
            validateCircuit()
        }
    }

    func getComponent(for terminalId: UUID) -> VoltPlacedComponent? {
        return placedComponents.first { $0.terminals.contains { $0.id == terminalId } }
    }

    func getTerminal(byId id: UUID) -> VoltTerminal? {
        for component in placedComponents {
            if let terminal = component.terminals.first(where: { $0.id == id }) { return terminal }
        }
        return nil
    }

    func connectTerminals(_ terminal1: UUID, to terminal2: UUID) {
        if connections.contains(where: { ($0.from == terminal1 && $0.to == terminal2) || ($0.from == terminal2 && $0.to == terminal1) }) { return }
        connections.append((from: terminal1, to: terminal2))
        validateCircuit()
    }

    func validateCircuit() {
        guard let battery = placedComponents.first(where: { $0.type == .battery }),
              let led = placedComponents.first(where: { $0.type == .led }) else { isPowered = false; return }

        let batteryPos = battery.terminals.first { $0.type == .positive }
        let ledPos = led.terminals.first { $0.type == .positive }
        let ledNeg = led.terminals.first { $0.type == .negative }
        let batteryNeg = battery.terminals.first { $0.type == .negative }

        isPowered = hasPath(from: batteryPos?.id, to: ledPos?.id) && hasPath(from: ledNeg?.id, to: batteryNeg?.id)
    }

    func hasPath(from startId: UUID?, to endId: UUID?) -> Bool {
        guard let start = startId, let end = endId else { return false }
        if start == end { return true }
        var visited: Set<UUID> = [start]
        var queue: [UUID] = [start]

        while !queue.isEmpty {
            let current = queue.removeFirst()
            let wireNeighbors = connections.compactMap { c in c.from == current ? c.to : (c.to == current ? c.from : nil) }
            var internalNeighbor: UUID? = nil
            if let comp = getComponent(for: current) {
                if comp.type == .wire { internalNeighbor = comp.terminals.first { $0.id != current }?.id }
                else if comp.type == .switchComp && comp.isSwitchOn { internalNeighbor = comp.terminals.first { $0.id != current }?.id }
            }
            for next in wireNeighbors + (internalNeighbor != nil ? [internalNeighbor!] : []) {
                if next == end { return true }
                if !visited.contains(next) { visited.insert(next); queue.append(next) }
            }
        }
        return false
    }

    func getTerminalWorldPosition(_ terminal: VoltTerminal) -> CGPoint {
        guard let component = placedComponents.first(where: { $0.id == terminal.componentId }) else { return .zero }
        return CGPoint(x: component.location.x + terminal.position.x, y: component.location.y + terminal.position.y)
    }
}

// MARK: - 5. MAIN VIEWS
// Renamed from "HomeView" to "VoltHomeView" — this is the entry screen for Volt Quest
struct VoltQuestView: View {
    @StateObject var levelManager = VoltLevelManager()
    @StateObject var tutorialManager = VoltTutorialManager()
    @State private var showGame = false

    var body: some View {
        ZStack {
            VoltTheme.backgroundGray.ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                VStack(spacing: 4) {
                    Text("⚡ VOLT QUEST")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(VoltTheme.powerCoral)
                    Text("CIRCUIT MASTER")
                        .font(.title3)
                        .foregroundColor(VoltTheme.textDark.opacity(0.6))
                }

                VStack(spacing: 10) {
                    Text("CURRENT PROGRESS")
                        .font(.caption)
                        .tracking(2)
                        .foregroundColor(VoltTheme.textDark.opacity(0.5))
                    Text("Level \(levelManager.currentLevelIndex + 1) / \(VoltGameLevel.levels.count)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(VoltTheme.textDark)
                    HStack(spacing: 6) {
                        ForEach(0..<3) { i in
                            Image(systemName: i <= levelManager.currentLevelIndex ? "star.fill" : "star")
                                .foregroundColor(VoltTheme.powerCoral)
                                .font(.title3)
                        }
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(VoltTheme.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)

                Spacer()

                VStack(spacing: 16) {
                    Button(action: { showGame = true }) {
                        Text("▶️ PLAY")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(VoltTheme.powerCoral)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(color: VoltTheme.powerCoral.opacity(0.3), radius: 8, x: 0, y: 4)
                    }

                    Button(action: {
                        tutorialManager.showTutorial = true
                        tutorialManager.currentPage = 0
                    }) {
                        Text("❓ HOW TO PLAY")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(VoltTheme.white)
                            .foregroundColor(VoltTheme.textDark)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showGame) { VoltGameplayView(levelManager: levelManager) }
        .overlay(
            Group {
                if tutorialManager.showTutorial {
                    VoltTutorialOverlay(manager: tutorialManager) { tutorialManager.closeTutorial() }
                }
            }
        )
        .onAppear {
            if tutorialManager.shouldShowTutorial() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    tutorialManager.showTutorial = true
                }
            }
        }
    }
}

// Renamed from "GameplayView" to "VoltGameplayView" to avoid clashing with Game3's GameplayView
struct VoltGameplayView: View {
    @ObservedObject var levelManager: VoltLevelManager
    @StateObject var engine = VoltCircuitEngine()
    @State private var dragStartPosition: CGPoint?
    @State private var currentDragPosition: CGPoint?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            VoltTheme.backgroundGray.ignoresSafeArea()

            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(VoltTheme.powerCoral)
                            .padding(8)
                            .background(VoltTheme.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }

                    Text("Level \(levelManager.currentLevel.id)")
                        .font(.headline)
                        .foregroundColor(VoltTheme.textDark)

                    Spacer()
                    VoltStatusBadge(isPowered: engine.isPowered)
                }
                .padding()

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(VoltTheme.white)
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                        .overlay(
                            VStack(spacing: 20) {
                                ForEach(0..<5) { _ in
                                    HStack(spacing: 20) {
                                        ForEach(0..<8) { _ in
                                            Circle().fill(.gray.opacity(0.2)).frame(width: 6, height: 6)
                                        }
                                    }
                                }
                            }
                        )
                        .opacity(engine.placedComponents.isEmpty ? 1 : 0.05)

                    VoltConnectionLinesView(connections: engine.connections, engine: engine)

                    ForEach(engine.placedComponents) { component in
                        ZStack {
                            VoltComponentView(component: component, isLit: engine.isPowered && component.type == .led)
                                .position(component.location)
                                .onLongPressGesture { withAnimation(.spring()) { engine.removeComponent(component.id) } }
                                .onTapGesture { if component.type == .switchComp { engine.toggleSwitch(component.id) } }

                            ForEach(component.terminals) { terminal in
                                let worldPos = engine.getTerminalWorldPosition(terminal)
                                let isSelected = engine.selectedTerminal?.id == terminal.id
                                VoltTerminalView(terminal: terminal, worldPosition: worldPos, isSelected: isSelected)
                                    .onTapGesture {
                                        if let selected = engine.selectedTerminal {
                                            if selected.id != terminal.id { engine.connectTerminals(selected.id, to: terminal.id) }
                                            engine.selectedTerminal = nil
                                        } else { engine.selectedTerminal = terminal }
                                    }
                            }
                        }
                    }

                    if let start = dragStartPosition, let current = currentDragPosition {
                        Path { path in path.move(to: start); path.addLine(to: current) }
                            .stroke(VoltTheme.powerCoral, style: StrokeStyle(lineWidth: 3, dash: [5]))
                    }
                }
                .frame(height: 300)
                .padding()
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged { value in if dragStartPosition == nil { dragStartPosition = value.location }; currentDragPosition = value.location }
                    .onEnded { _ in dragStartPosition = nil; currentDragPosition = nil })
                .onDrop(of: [UTType.utf8PlainText], delegate: VoltCircuitDropDelegate(engine: engine))

                Spacer()
                VoltToolboxView()
                    .padding(.bottom, 30)
            }
        }
        .onAppear { loadLevelComponents() }
        .onChange(of: engine.isPowered) { newValue in if newValue { levelManager.checkWinCondition(engine: engine) } }
        .overlay(levelOverlay)
        .overlay(completeOverlay)
    }

    private func loadLevelComponents() {
        engine.placedComponents.removeAll()
        engine.connections.removeAll()
        engine.selectedTerminal = nil
        engine.isPowered = false
        let level = levelManager.currentLevel
        for type in level.initialComponents {
            let loc = CGPoint(x: 100 + CGFloat.random(in: 0...100), y: 100 + CGFloat.random(in: 0...100))
            engine.addComponent(type, at: loc)
        }
    }

    private var levelOverlay: some View {
        Group {
            if levelManager.showObjective {
                VStack(spacing: 20) {
                    Text("Level \(levelManager.currentLevel.id)")
                        .font(.largeTitle).bold().foregroundColor(VoltTheme.powerCoral)
                    Text(levelManager.currentLevel.title)
                        .font(.title2).foregroundColor(VoltTheme.textDark)
                    Text(levelManager.currentLevel.objective)
                        .padding().frame(maxWidth: 300).background(VoltTheme.backgroundGray).cornerRadius(12).foregroundColor(VoltTheme.textDark).multilineTextAlignment(.center)
                    Button("Start Building") { withAnimation { levelManager.showObjective = false } }
                        .padding().background(VoltTheme.powerCoral).foregroundColor(.white).cornerRadius(12)
                }
                .padding().background(VoltTheme.white).cornerRadius(24).shadow(color: .black.opacity(0.1), radius: 20).transition(.scale)
            }
        }
    }

    private var completeOverlay: some View {
        Group {
            if levelManager.isLevelComplete {
                VStack(spacing: 20) {
                    if levelManager.isLastLevel {
                        Text("🏆 GAME COMPLETE! 🏆").font(.largeTitle).bold().foregroundColor(VoltTheme.powerCoral)
                        Text("You've mastered all circuits!").font(.title3).fontWeight(.medium).foregroundColor(VoltTheme.textDark).multilineTextAlignment(.center)
                    } else {
                        Text("LEVEL COMPLETE! 🎉").font(.largeTitle).bold().foregroundColor(VoltTheme.powerCoral)
                    }
                    Text("⭐⭐⭐").font(.system(size: 50))
                    if levelManager.isLastLevel {
                        Button("Play Again 🔄") { levelManager.resetGame(); loadLevelComponents() }
                            .padding().frame(maxWidth: 200).background(VoltTheme.powerCoral).foregroundColor(.white).cornerRadius(12)
                        Button("Replay Level 1") { levelManager.currentLevelIndex = 0; levelManager.isLevelComplete = false; loadLevelComponents() }
                            .padding().frame(maxWidth: 200).background(VoltTheme.backgroundGray).foregroundColor(VoltTheme.textDark).cornerRadius(12)
                    } else {
                        Button("Next Level ▶️") { levelManager.nextLevel(); loadLevelComponents() }
                            .padding().frame(maxWidth: 200).background(VoltTheme.powerCoral).foregroundColor(.white).cornerRadius(12)
                    }
                }
                .padding(30).background(VoltTheme.white).cornerRadius(25).shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10).transition(.scale)
            }
        }
    }
}

// MARK: - 6. TUTORIAL OVERLAY
// Renamed from "TutorialOverlay" to "VoltTutorialOverlay"
struct VoltTutorialOverlay: View {
    @ObservedObject var manager: VoltTutorialManager
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea().onTapGesture { manager.nextPage() }

            VStack(spacing: 24) {
                Image(systemName: manager.pages[manager.currentPage].iconName)
                    .font(.system(size: 60))
                    .foregroundColor(VoltTheme.powerCoral)
                    .padding(20)
                    .background(VoltTheme.powerCoral.opacity(0.1))
                    .clipShape(Circle())

                Text(manager.pages[manager.currentPage].title)
                    .font(.title).fontWeight(.bold).foregroundColor(VoltTheme.textDark).multilineTextAlignment(.center)

                Text(manager.pages[manager.currentPage].description)
                    .font(.body).foregroundColor(VoltTheme.textDark.opacity(0.8)).multilineTextAlignment(.center).padding(.horizontal)

                Spacer()

                HStack(spacing: 8) {
                    ForEach(0..<manager.pages.count, id: \.self) { index in
                        Circle().fill(index == manager.currentPage ? VoltTheme.powerCoral : Color.gray.opacity(0.3)).frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 20)

                HStack(spacing: 16) {
                    if manager.currentPage > 0 {
                        Button("Back") { manager.previousPage() }
                            .padding().frame(maxWidth: .infinity).background(VoltTheme.backgroundGray).foregroundColor(VoltTheme.textDark).cornerRadius(12)
                    }
                    Button(manager.currentPage == manager.pages.count - 1 ? "Start Playing" : "Next") {
                        if manager.currentPage == manager.pages.count - 1 { onDismiss() } else { manager.nextPage() }
                    }
                    .padding().frame(maxWidth: .infinity).background(VoltTheme.powerCoral).foregroundColor(.white).cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding(30).background(VoltTheme.white).cornerRadius(24).shadow(color: .black.opacity(0.2), radius: 20).padding(.horizontal, 40).transition(.scale)
        }
    }
}

// MARK: - 7. SUPPORTING VIEWS
// All renamed with "Volt" prefix to avoid clashing with other games' supporting views
struct VoltTerminalView: View {
    let terminal: VoltTerminal
    let worldPosition: CGPoint
    let isSelected: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(isSelected ? VoltTheme.powerCoral : (terminal.type == .positive ? VoltTheme.powerCoral : terminal.type == .negative ? .gray : .orange))
                .frame(width: 24, height: 24)
                .position(worldPosition)
                .overlay(Circle().fill(.white).frame(width: 10, height: 10).position(worldPosition))
                .shadow(color: isSelected ? VoltTheme.powerCoral : .black.opacity(0.2), radius: 2, x: 0, y: 1)

            if terminal.type == .positive || terminal.type == .negative {
                Text(terminal.type == .positive ? "+" : "-")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(VoltTheme.textDark)
                    .position(x: worldPosition.x, y: worldPosition.y - 22)
            }
        }
    }
}

struct VoltConnectionLinesView: View {
    let connections: [(from: UUID, to: UUID)]
    let engine: VoltCircuitEngine

    var body: some View {
        GeometryReader { geo in
            ForEach(Array(connections.enumerated()), id: \.offset) { _, conn in
                if let f = engine.getTerminal(byId: conn.from), let t = engine.getTerminal(byId: conn.to) {
                    Path { p in p.move(to: engine.getTerminalWorldPosition(f)); p.addLine(to: engine.getTerminalWorldPosition(t)) }
                        .stroke(engine.isPowered ? VoltTheme.powerCoral : .gray.opacity(0.4), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .shadow(color: engine.isPowered ? VoltTheme.powerCoral.opacity(0.4) : .clear, radius: 4)
                }
            }
        }
    }
}

struct VoltComponentView: View {
    let component: VoltPlacedComponent
    let isLit: Bool

    var body: some View {
        Group {
            switch component.type {
            case .battery: VStack { Rectangle().fill(VoltTheme.textDark).frame(height: 40).cornerRadius(8); Text("9V").font(.caption).foregroundColor(.white).bold() }
            case .led: Circle().fill(isLit ? VoltTheme.powerCoral : .gray.opacity(0.2)).overlay(Circle().stroke(.white, lineWidth: 3)).shadow(color: isLit ? VoltTheme.powerCoral : .clear, radius: isLit ? 30 : 0)
            case .switchComp: ZStack { Capsule().fill(component.isSwitchOn ? VoltTheme.powerCoral : .gray.opacity(0.3)); Circle().fill(.white).frame(width: 24, height: 24).offset(x: component.isSwitchOn ? 15 : -15).shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1) }.frame(width: 55, height: 35)
            case .wire: Capsule().fill(VoltTheme.powerCoral).frame(width: 65, height: 12)
            }
        }.frame(width: 65, height: 65)
    }
}

struct VoltStatusBadge: View {
    let isPowered: Bool

    var body: some View {
        Text(isPowered ? "⚡ POWERED" : "NO POWER").font(.caption).fontWeight(.bold)
            .foregroundColor(isPowered ? .white : VoltTheme.textDark.opacity(0.6))
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background(isPowered ? VoltTheme.powerCoral : VoltTheme.backgroundGray).cornerRadius(12)
    }
}

struct VoltToolboxView: View {
    var body: some View {
        HStack(spacing: 20) {
            VoltDraggableItem(type: .battery, icon: "battery.100", label: "Battery")
            VoltDraggableItem(type: .led, icon: "lightbulb.fill", label: "LED")
            VoltDraggableItem(type: .switchComp, icon: "power", label: "Switch")
            VoltDraggableItem(type: .wire, icon: "cable.coaxial", label: "Wire")
        }
        .padding()
        .background(VoltTheme.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

struct VoltDraggableItem: View {
    let type: VoltComponentType
    let icon: String
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon).font(.title).foregroundColor(VoltTheme.powerCoral)
            Text(label).font(.caption).fontWeight(.semibold).foregroundColor(VoltTheme.textDark)
        }
        .padding(12).frame(width: 70)
        .background(VoltTheme.backgroundGray).cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(VoltTheme.powerCoral.opacity(0.3), lineWidth: 2))
        .onDrag { NSItemProvider(item: type.rawValue.data(using: .utf8)! as NSSecureCoding, typeIdentifier: UTType.utf8PlainText.identifier) }
    }
}

struct VoltCircuitDropDelegate: DropDelegate {
    @ObservedObject var engine: VoltCircuitEngine

    func performDrop(info: DropInfo) -> Bool {
        let providers = info.itemProviders(for: [UTType.utf8PlainText])
        for provider in providers {
            provider.loadDataRepresentation(forTypeIdentifier: UTType.utf8PlainText.identifier) { data, _ in
                if let data = data, let str = String(data: data, encoding: .utf8), let type = VoltComponentType(rawValue: str) {
                    DispatchQueue.main.async { self.engine.addComponent(type, at: info.location) }
                }
            }
        }
        return true
    }
}

// MARK: - Preview
struct VoltQuestView_Previews: PreviewProvider {
    static var previews: some View { VoltQuestView() }
}
