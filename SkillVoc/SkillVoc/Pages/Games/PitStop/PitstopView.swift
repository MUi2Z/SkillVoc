import SwiftUI



enum GameLevel: Int, CaseIterable {
    case easy   = 0
    case medium = 1
    case hard   = 2

    var title: String {
        switch self {
        case .easy:   return "Easy"
        case .medium: return "Medium"
        case .hard:   return "Hard"
        }
    }

    var subtitle: String {
        switch self {
        case .easy:   return "Rookie Technician"
        case .medium: return "Pit Crew Member"
        case .hard:   return "Pro Crew Chief"
        }
    }

    var emoji: String {
        switch self {
        case .easy:   return "🟢"
        case .medium: return "🟡"
        case .hard:   return "🔴"
        }
    }

    var color: Color {
        switch self {
        case .easy:   return .okGreen
        case .medium: return .warnAmber
        case .hard:   return .dangerRed
        }
    }

    
    var timerDuration: Double {
        switch self {
        case .easy:   return 120
        case .medium: return 90
        case .hard:   return 60
        }
    }

    
    var loostenTapCount: Int {
        switch self {
        case .easy:   return 3
        case .medium: return 4
        case .hard:   return 6
        }
    }

    
    var swipeDistance: CGFloat {
        switch self {
        case .easy:   return 30
        case .medium: return 40
        case .hard:   return 60
        }
    }

    
    var longPressDuration: Double {
        switch self {
        case .easy:   return 0.6
        case .medium: return 1.0
        case .hard:   return 1.5
        }
    }

    
    var eventChance: Double {
        switch self {
        case .easy:   return 0.0
        case .medium: return 0.30
        case .hard:   return 0.50  
        }
    }

    // Muscle memory mode
    var musclememoryAlwaysOn: Bool {
        switch self {
        case .easy:   return false
        case .medium: return false
        case .hard:   return true   // always on in hard
        }
    }

    // Pro crew target time
    var proTime: Double {
        switch self {
        case .easy:   return 70
        case .medium: return 45
        case .hard:   return 30
        }
    }

    // Rookie target time
    var rookieTime: Double {
        switch self {
        case .easy:   return 100
        case .medium: return 70
        case .hard:   return 50
        }
    }

    // UserDefaults key for personal best per level
    var bestTimeKey: String {
        switch self {
        case .easy:   return "pitstop_best_easy"
        case .medium: return "pitstop_best_medium"
        case .hard:   return "pitstop_best_hard"
        }
    }

    var perks: [String] {
        switch self {
        case .easy:
            return ["120 seconds", "Tap 3x to loosen", "No random events", "Full instructions"]
        case .medium:
            return ["90 seconds", "Tap 4x to loosen", "30% random events", "Full instructions"]
        case .hard:
            return ["60 seconds", "Tap 6x to loosen", "50% random events", "No instructions"]
        }
    }
}

// MARK: - Game Screen State Machine
enum PitStopScreen: Equatable {
    case start
    case levelSelect
    case tutorial
    case countdown(Int)
    case gameplay
    case pitLaneExit
    case result(Double)
}

// MARK: - Tyre State
enum TyreState: Equatable {
    case idle
    case active
    case complete
}

// MARK: - Tyre Step
enum TyreStep: Int, CaseIterable {
    case loostenNut  = 0
    case removeTyre  = 1
    case fitNewTyre  = 2
    case tightenNut  = 3

    var instruction: String {
        switch self {
        case .loostenNut: return "Loosen the wheel nut"
        case .removeTyre: return "Swipe Left — Remove the old tyre"
        case .fitNewTyre: return "Swipe Right — Fit the new tyre"
        case .tightenNut: return "Hold — Tighten the nut back"
        }
    }

    func instruction(for level: GameLevel) -> String {
        switch self {
        case .loostenNut: return "Tap \(level.loostenTapCount)x — Loosen the wheel nut"
        case .removeTyre: return "Swipe Left — Remove the old tyre"
        case .fitNewTyre: return "Swipe Right — Fit the new tyre"
        case .tightenNut: return "Hold — Tighten the nut back"
        }
    }

    var label: String {
        switch self {
        case .loostenNut: return "Loosen"
        case .removeTyre: return "Remove"
        case .fitNewTyre: return "Fit"
        case .tightenNut: return "Tighten"
        }
    }

    var systemIcon: String {
        switch self {
        case .loostenNut: return "wrench.adjustable"
        case .removeTyre: return "arrow.left.circle"
        case .fitNewTyre: return "arrow.right.circle"
        case .tightenNut: return "checkmark.seal"
        }
    }
}

// MARK: - Crew Rank (level-aware)
enum CrewRank {
    case pro
    case rookie
    case trainee

    init(time: Double, level: GameLevel) {
        if time < level.proTime        { self = .pro }
        else if time < level.rookieTime { self = .rookie }
        else                            { self = .trainee }
    }

    var title: String {
        switch self {
        case .pro:     return "Pro Crew 🏆"
        case .rookie:  return "Rookie Crew"
        case .trainee: return "Trainee"
        }
    }

    var color: Color {
        switch self {
        case .pro:     return .powerCoral
        case .rookie:  return .warnAmber
        case .trainee: return .midGray
        }
    }

    var message: String {
        switch self {
        case .pro:     return "Outstanding! Your time rivals a professional pit crew!"
        case .rookie:  return "Good effort! Keep practising to reach Pro Crew level."
        case .trainee: return "Keep going! Speed comes with practice."
        }
    }
}

// MARK: - Random Mid-Game Event
enum PitEvent: CaseIterable {
    case strippedNut
    case wrongTyre
    case safetyCar

    var title: String {
        switch self {
        case .strippedNut: return "⚠️ Stripped Nut!"
        case .wrongTyre:   return "🚨 Wrong Tyre Delivered!"
        case .safetyCar:   return "🟡 Safety Car Out!"
        }
    }

    var description: String {
        switch self {
        case .strippedNut: return "The nut is damaged — tap 8 times to remove it!"
        case .wrongTyre:   return "That's the wrong compound — swipe left to send it back!"
        case .safetyCar:   return "Safety car on track — pit lane speed limit in effect. Wait 4 seconds!"
        }
    }

    var accentColor: Color {
        switch self {
        case .strippedNut: return .warnAmber
        case .wrongTyre:   return .dangerRed
        case .safetyCar:   return .warnAmber
        }
    }

    static func roll(afterTyre index: Int, level: GameLevel) -> PitEvent? {
        guard index >= 1 else { return nil }
        guard level.eventChance > 0 else { return nil }
        guard Double.random(in: 0...1) < level.eventChance else { return nil }
        return PitEvent.allCases.randomElement()
    }
}

// MARK: - Muscle Memory Manager
struct MusclememoryManager {
    private static let key = "pitstop_play_count"

    static var playCount: Int {
        UserDefaults.standard.integer(forKey: key)
    }

    static func incrementPlayCount() {
        UserDefaults.standard.set(playCount + 1, forKey: key)
    }

    static func isMusclememoryMode(for level: GameLevel) -> Bool {
        if level.musclememoryAlwaysOn { return true }
        return playCount >= 2
    }
}

// MARK: - Personal Best Manager
struct PersonalBestManager {
    static func getBest(for level: GameLevel) -> Double {
        UserDefaults.standard.double(forKey: level.bestTimeKey)
    }

    static func saveBest(_ time: Double, for level: GameLevel) {
        UserDefaults.standard.set(time, forKey: level.bestTimeKey)
    }

    static func isNewBest(_ time: Double, for level: GameLevel) -> Bool {
        let saved = getBest(for: level)
        return saved == 0 || time < saved
    }
}

// MARK: - TVET Facts
struct TVETFact: Identifiable {
    let id = UUID()
    let category: String
    let content: String
    let highlight: String

    // Returns 4 random facts shuffled — different every game
    static func randomSelection(count: Int = 4) -> [TVETFact] {
        Array(all.shuffled().prefix(count))
    }

    static let all: [TVETFact] = [

        // ── Speed & Records ───────────────────────────────
        TVETFact(
            category: "World Record",
            content: "A real F1 pit crew changes 4 tyres in just 2.4 seconds — they are certified automotive engineers trained for thousands of hours.",
            highlight: "2.4 seconds"
        ),
        TVETFact(
            category: "Speed Record",
            content: "The fastest F1 pit stop ever was recorded at 1.82 seconds by Red Bull Racing — a result of years of precision engineering training.",
            highlight: "1.82 seconds"
        ),
        TVETFact(
            category: "Pit Crew Size",
            content: "A full F1 pit crew consists of up to 20 mechanics working simultaneously — each with a specialised role requiring technical TVET-level training.",
            highlight: "20 mechanics"
        ),
        TVETFact(
            category: "Motorsport Engineering",
            content: "F1 cars generate up to 1,000 horsepower and reach speeds of over 350 km/h. Every bolt, tyre, and component is engineered and maintained by trained technicians.",
            highlight: "1,000 horsepower"
        ),
        TVETFact(
            category: "Precision Engineering",
            content: "Modern engine components are manufactured to tolerances of just 0.01mm — thinner than a human hair. Automotive engineers must master this level of precision.",
            highlight: "0.01mm"
        ),

        // ── Career & Salary ───────────────────────────────
        TVETFact(
            category: "Career & Salary",
            content: "TVET Automotive graduates in Malaysia can earn RM3,500–RM7,000 per month as a certified Automotive Engineer.",
            highlight: "RM3,500–RM7,000"
        ),
        TVETFact(
            category: "Career Growth",
            content: "An automotive technician with 5 years of experience can advance to a Service Manager role earning over RM8,000 per month in Malaysia.",
            highlight: "RM8,000 per month"
        ),
        TVETFact(
            category: "Apprenticeship",
            content: "Many TVET automotive graduates begin as apprentices earning RM1,800/month and are promoted to senior technician within 3 years — with salary doubling.",
            highlight: "salary doubling"
        ),
        TVETFact(
            category: "Job Demand",
            content: "Malaysia's automotive industry employs over 700,000 workers — and skilled TVET graduates are among the most in-demand across all sectors.",
            highlight: "700,000 workers"
        ),

        // ── Modern Technology ─────────────────────────────
        TVETFact(
            category: "Modern Technology",
            content: "Today's automotive industry involves digital diagnostics, electric vehicles, and AI systems — far beyond just spanners and grease.",
            highlight: "digital diagnostics"
        ),
        TVETFact(
            category: "Electric Vehicles",
            content: "Electric vehicles now make up over 14% of global car sales. TVET automotive engineers are the key workforce driving this EV revolution.",
            highlight: "14% of global car sales"
        ),
        TVETFact(
            category: "Smart Diagnostics",
            content: "Modern cars have over 100 electronic control units (ECUs). Automotive technicians today use AI-powered scanners to diagnose faults in minutes.",
            highlight: "100 electronic control units"
        ),
        TVETFact(
            category: "Autonomous Tech",
            content: "Self-driving technology requires engineers who understand both mechanics and software. TVET programmes now include robotics and automation modules.",
            highlight: "robotics and automation"
        ),
        TVETFact(
            category: "Workshop Technology",
            content: "Modern workshops use computerised diagnostic tools that can read over 5,000 fault codes — TVET technicians are trained to interpret and fix every one.",
            highlight: "5,000 fault codes"
        ),

        // ── Global Opportunities ──────────────────────────
        TVETFact(
            category: "Global Opportunities",
            content: "Certified Malaysian automotive engineers can work in Germany, Japan, and South Korea — the world's top automotive hubs.",
            highlight: "Germany, Japan, and South Korea"
        ),
        TVETFact(
            category: "Global Demand",
            content: "The global automotive technician shortage is expected to reach 1.2 million unfilled positions by 2030 — creating massive opportunities for TVET graduates.",
            highlight: "1.2 million unfilled positions"
        ),
        TVETFact(
            category: "F1 Careers",
            content: "Formula 1 teams recruit automotive engineers from TVET and technical institutes worldwide. Your pit stop skills today could lead to an F1 career tomorrow.",
            highlight: "F1 teams recruit"
        ),

        // ── TVET Malaysia ─────────────────────────────────
        TVETFact(
            category: "TVET Malaysia",
            content: "Malaysia has over 1,000 TVET institutions offering automotive programmes — including ADTEC, ILP, Politeknik, and community colleges nationwide.",
            highlight: "1,000 TVET institutions"
        ),
        TVETFact(
            category: "TVET Recognition",
            content: "Malaysian SKM (Sijil Kemahiran Malaysia) automotive certifications are recognised in ASEAN countries, the UK, and Australia.",
            highlight: "recognised in ASEAN"
        ),
        TVETFact(
            category: "Study Duration",
            content: "A full automotive TVET diploma takes just 2.5 years to complete — compared to 4 years for a university degree — getting you into the workforce faster.",
            highlight: "2.5 years"
        ),
        TVETFact(
            category: "Safety First",
            content: "Automotive engineers are responsible for vehicle safety systems including ABS, airbags, and electronic stability control — technology that saves thousands of lives yearly.",
            highlight: "saves thousands of lives"
        ),

        // ── Fun Facts ─────────────────────────────────────
        TVETFact(
            category: "Fun Fact",
            content: "The average modern car has over 30,000 individual parts. Knowing how they all work together is what makes a TVET automotive engineer truly valuable.",
            highlight: "30,000 individual parts"
        ),
        TVETFact(
            category: "Fun Fact",
            content: "Ferrari's pit crew practices tyre changes over 50,000 times a year to achieve their sub-3-second pit stops — the same dedication TVET trains you for.",
            highlight: "50,000 times a year"
        )
    ]
}

// MARK: - Timer Formatter
extension Double {
    var timerString: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}



// MARK: ============================================================
// MARK: - START SCREEN
// MARK: ============================================================

// MARK: - Start Screen
struct StartScreenView: View {

    var onStart: () -> Void
    var onHowToPlay: () -> Void

    @State private var carPulse: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // ── Hero Card ──────────────────────────────
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 90, height: 90)
                            .scaleEffect(carPulse ? 1.08 : 1.0)
                            .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: carPulse)
                        F1CarShape().frame(width: 64, height: 44)
                    }
                    .onAppear { carPulse = true }

                    Text("F1 Pit Stop")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    Text("Tyre Changer")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    Text("Engineering Department — Automotive & Mechanical")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.65))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .background(Color.powerCoral)
                .cornerRadius(24)
                .padding(.horizontal, 20)
                .padding(.top, 24)

                // ── Level Preview Row ──────────────────────
                HStack(spacing: 8) {
                    ForEach(GameLevel.allCases, id: \.rawValue) { level in
                        VStack(spacing: 4) {
                            Text(level.emoji)
                                .font(.system(size: 20))
                            Text(level.title)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.darkBase)
                            Text("\(Int(level.timerDuration))s")
                                .font(.system(size: 10))
                                .foregroundColor(.midGray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.softGray3, lineWidth: 0.5))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Text("Automotive mechanical skills are about speed, precision and modern technology.")
                    .font(.system(size: 13))
                    .foregroundColor(.midGray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.top, 14)

                VStack(spacing: 10) {
                    Button(action: onStart) {
                        Text("Select Difficulty & Play")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.powerCoral)
                            .cornerRadius(16)
                    }
                    Button(action: onHowToPlay) {
                        Text("How to Play")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.midGray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.softGray2)
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 40)
            }
        }
        .background(Color.softGray.ignoresSafeArea())
    }
}

// MARK: - F1 Car Shape
struct F1CarShape: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6).fill(Color.white).frame(width: 60, height: 22)
            RoundedRectangle(cornerRadius: 4).fill(Color.white.opacity(0.85)).frame(width: 28, height: 14).offset(y: -6)
            Rectangle().fill(Color.powerCoral2.opacity(0.6)).frame(width: 60, height: 3).offset(y: 4)
            Group {
                TyreCircle().offset(x: -22, y: -13)
                TyreCircle().offset(x:  22, y: -13)
                TyreCircle().offset(x: -22, y:  13)
                TyreCircle().offset(x:  22, y:  13)
            }
        }
    }
}

private struct TyreCircle: View {
    var body: some View {
        Circle().fill(Color.darkBase).frame(width: 12, height: 12)
    }
}

// MARK: - Tutorial View (level-aware)
struct TutorialView: View {
    let level: GameLevel
    var onBegin: () -> Void
    var onBack: () -> Void

    let steps: [(icon: String, gesture: String, description: String)] = [
        ("wrench.adjustable",  "Tap",          "Loosen the wheel nut"),
        ("arrow.left.circle",  "Swipe Left",   "Remove the old tyre from the rim"),
        ("arrow.right.circle", "Swipe Right",  "Fit the new tyre onto the rim"),
        ("checkmark.seal",     "Hold",         "Tighten the wheel nut back on"),
    ]

    var body: some View {
        VStack(spacing: 0) {

            // Back button
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left").font(.system(size: 13, weight: .semibold))
                        Text("Back").font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(.midGray)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            VStack(spacing: 4) {
                Text("How to Play")
                    .font(.system(size: 22, weight: .bold)).foregroundColor(.darkBase)

                // Level badge
                HStack(spacing: 6) {
                    Text(level.emoji)
                    Text(level.title)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(level.color)
                    Text("— \(Int(level.timerDuration))s timer")
                        .font(.system(size: 12))
                        .foregroundColor(.midGray)
                }
                .padding(.horizontal, 12).padding(.vertical, 5)
                .background(level.color.opacity(0.1))
                .cornerRadius(20)
            }
            .padding(.top, 16)
            .padding(.bottom, 20)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(steps.indices, id: \.self) { i in
                        TutorialStepRow(
                            number:      i + 1,
                            icon:        steps[i].icon,
                            gesture:     i == 0 ? "Tap \(level.loostenTapCount)x" : steps[i].gesture,
                            description: steps[i].description
                        )
                    }

                    // Level-specific notes
                    if level == .hard {
                        HStack(spacing: 10) {
                            Image(systemName: "brain.head.profile").foregroundColor(.dangerRed)
                            Text("Hard Mode: No instructions shown during gameplay. Memorise the gestures now!")
                                .font(.system(size: 12)).foregroundColor(.dangerRed)
                        }
                        .padding(14)
                        .background(Color.dangerRed.opacity(0.08))
                        .cornerRadius(12)
                    }

                    if level != .easy {
                        HStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.warnAmber)
                            Text("Watch out for random pit events — stripped nuts, wrong tyres, and safety cars!")
                                .font(.system(size: 12)).foregroundColor(Color(hex: "#8B6914"))
                        }
                        .padding(14)
                        .background(Color.warnAmber.opacity(0.1))
                        .cornerRadius(12)
                    }

                    HStack(spacing: 10) {
                        Image(systemName: "lightbulb.fill").foregroundColor(.powerCoral)
                        Text("Pro Crew target: under \(Int(level.proTime)) seconds. Can you beat it?")
                            .font(.system(size: 12)).foregroundColor(.powerCoral2)
                    }
                    .padding(14)
                    .background(Color.coralLight)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
            }

            Spacer()

            Button(action: onBegin) {
                HStack {
                    Text(level.emoji)
                    Text("Start \(level.title) Mode")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(level.color)
                .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(Color.softGray.ignoresSafeArea())
    }
}

private struct TutorialStepRow: View {
    let number: Int
    let icon: String
    let gesture: String
    let description: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(Color.powerCoral).frame(width: 36, height: 36)
                Text("\(number)").font(.system(size: 15, weight: .bold)).foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Image(systemName: icon).font(.system(size: 13, weight: .medium)).foregroundColor(.powerCoral)
                    Text(gesture).font(.system(size: 14, weight: .semibold)).foregroundColor(.darkBase)
                }
                Text(description).font(.system(size: 12)).foregroundColor(.midGray)
            }
            Spacer()
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.softGray3, lineWidth: 0.5))
    }
}

// MARK: - Countdown View
struct CountdownView: View {
    let number: Int
    @State private var scale: CGFloat = 0.3
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            Color.softGray.ignoresSafeArea()
            VStack(spacing: 16) {
                Text(number == 0 ? "Go!" : "\(number)")
                    .font(.system(size: 96, weight: .black))
                    .foregroundColor(number == 0 ? .okGreen : .powerCoral)
                    .scaleEffect(scale).opacity(opacity)
                Text(number > 0 ? "Get ready..." : "Change the tyres!")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.midGray).opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                scale = 1.0; opacity = 1.0
            }
        }
    }
}




// MARK: ============================================================
// MARK: - LEVEL SELECT
// MARK: ============================================================

// MARK: - Level Select Screen
struct LevelSelectView: View {

    var onSelect: (GameLevel) -> Void
    var onBack: () -> Void

    @State private var selectedLevel: GameLevel = .medium
    @State private var showDetail: Bool = false

    var body: some View {
        VStack(spacing: 0) {

            // ── Header ─────────────────────────────────────
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundColor(.midGray)
                }
                Spacer()
                Text("Select Difficulty")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.darkBase)
                Spacer()
                // Invisible spacer to center title
                Text("Back")
                    .font(.system(size: 15))
                    .opacity(0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 20)

            // ── Personal Bests Row ─────────────────────────
            HStack(spacing: 8) {
                ForEach(GameLevel.allCases, id: \.rawValue) { level in
                    PersonalBestBadge(level: level)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)

            // ── Level Cards ────────────────────────────────
            VStack(spacing: 12) {
                ForEach(GameLevel.allCases, id: \.rawValue) { level in
                    LevelCard(
                        level:      level,
                        isSelected: selectedLevel == level,
                        onTap:      { withAnimation(.spring()) { selectedLevel = level } }
                    )
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            // ── Start Button ───────────────────────────────
            VStack(spacing: 8) {
                Button(action: { onSelect(selectedLevel) }) {
                    HStack(spacing: 8) {
                        Text(selectedLevel.emoji)
                        Text("Start \(selectedLevel.title)")
                            .font(.system(size: 16, weight: .bold))
                        Spacer()
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(selectedLevel.color)
                    .cornerRadius(16)
                }

                Text(selectedLevel.subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.midGray)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 36)
        }
        .background(Color.softGray.ignoresSafeArea())
    }
}

// MARK: - Level Card
struct LevelCard: View {
    let level: GameLevel
    let isSelected: Bool
    let onTap: () -> Void

    @State private var expanded: Bool = false

    var body: some View {
        VStack(spacing: 0) {

            // Main row
            Button(action: {
                onTap()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    expanded.toggle()
                }
            }) {
                HStack(spacing: 14) {

                    // Level icon
                    ZStack {
                        Circle()
                            .fill(isSelected ? level.color : level.color.opacity(0.15))
                            .frame(width: 48, height: 48)
                        Text(level.emoji)
                            .font(.system(size: 22))
                    }

                    // Title + subtitle
                    VStack(alignment: .leading, spacing: 3) {
                        Text(level.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(isSelected ? level.color : .darkBase)
                        Text(level.subtitle)
                            .font(.system(size: 12))
                            .foregroundColor(.midGray)
                    }

                    Spacer()

                    // Timer badge
                    VStack(spacing: 2) {
                        Text("\(Int(level.timerDuration))s")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(isSelected ? level.color : .midGray)
                        Text("timer")
                            .font(.system(size: 9))
                            .foregroundColor(.midGray)
                    }

                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.midGray)
                }
                .padding(14)
            }
            .buttonStyle(.plain)

            // Expanded detail
            if expanded {
                Divider().padding(.horizontal, 14)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(level.perks, id: \.self) { perk in
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 13))
                                .foregroundColor(level.color)
                            Text(perk)
                                .font(.system(size: 12))
                                .foregroundColor(.darkBase)
                        }
                    }

                    // Pro crew target
                    HStack(spacing: 8) {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 13))
                            .foregroundColor(level.color)
                        Text("Pro Crew target: under \(Int(level.proTime)) seconds")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(level.color)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? level.color : Color.softGray3, lineWidth: isSelected ? 2 : 0.5)
        )
        .shadow(color: isSelected ? level.color.opacity(0.15) : Color.clear, radius: 8, y: 4)
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Personal Best Badge
struct PersonalBestBadge: View {
    let level: GameLevel

    private var best: Double { PersonalBestManager.getBest(for: level) }

    var body: some View {
        VStack(spacing: 4) {
            Text(level.emoji)
                .font(.system(size: 16))
            Text(best == 0 ? "--:--" : best.timerString)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(best == 0 ? .midGray : level.color)
            Text("Best")
                .font(.system(size: 9))
                .foregroundColor(.midGray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.softGray3, lineWidth: 0.5)
        )
    }
}




// MARK: ============================================================
// MARK: - GAMEPLAY
// MARK: ============================================================

// MARK: - Gameplay View
struct GameplayView: View {

    let level: GameLevel

    @Binding var timeRemaining: Double
    @Binding var currentTyreIndex: Int
    @Binding var currentStep: Int
    @Binding var tyreStates: [TyreState]
    @Binding var tapCount: Int
    @Binding var tyreJustCompleted: Int
    @Binding var activePitEvent: PitEvent?
    @Binding var isHandlingEvent: Bool

    var onStepComplete: () -> Void
    var onEventResolved: (Int) -> Void
    var onQuit: () -> Void

    // Animation states
    @State private var tyreScale: CGFloat = 1.0
    @State private var tyreOffset: CGFloat = 0
    @State private var showFlash: Bool = false
    @State private var instructionShake: Bool = false
    @State private var tapRingScale: CGFloat = 1.0
    @State private var tapRingOpacity: Double = 0
    @State private var longPressProgress: Double = 0
    @State private var isLongPressing: Bool = false
    @State private var showQuitConfirm: Bool = false
    @State private var completedTyreOnCar: Int = -1
    @State private var carBounce: CGFloat = 0
    @State private var carWiggle: Double = 0
    @State private var tyreSpinAngle: Double = 0
    @State private var showTyreCompleteFlash: Bool = false
    @State private var eventTapCount: Int = 0

    private var isMusclememory: Bool {
        MusclememoryManager.isMusclememoryMode(for: level)
    }

    private var timerColor: Color {
        if timeRemaining > (level.timerDuration * 0.33) { return level.color }
        if timeRemaining > (level.timerDuration * 0.16) { return .warnAmber }
        return .dangerRed
    }

    var body: some View {
        ZStack {
            Color.softGray.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar.padding(.horizontal, 20).padding(.top, 12).padding(.bottom, 8)
                timerBar.padding(.horizontal, 20).padding(.bottom, 12)
                animatedCarSection.padding(.horizontal, 20).padding(.bottom, 12)
                tyreInteractionArea.padding(.horizontal, 20).padding(.bottom, 12)
                stepChips.padding(.horizontal, 20).padding(.bottom, 10)

                if !isMusclememory {
                    instructionBox.padding(.horizontal, 20)
                } else {
                    musclememoryHint.padding(.horizontal, 20)
                }
                Spacer()
            }

            if showFlash {
                Color.okGreen.opacity(0.2).ignoresSafeArea().allowsHitTesting(false)
            }

            if let event = activePitEvent {
                PitEventOverlay(
                    event: event,
                    eventTapCount: $eventTapCount,
                    onResolved: { onEventResolved(-1) }
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            if showQuitConfirm { quitConfirmOverlay }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: activePitEvent != nil)
        .onAppear {
            withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                tyreSpinAngle = 360
            }
        }
        .onChange(of: tyreJustCompleted) { _, newVal in
            guard newVal >= 0 else { return }
            triggerCarTyreComplete(tyreIndex: newVal)
        }
    }

    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            Button(action: { showQuitConfirm = true }) {
                Image(systemName: "xmark.circle.fill").font(.system(size: 22)).foregroundColor(.midGray)
            }
            Spacer()
            VStack(spacing: 1) {
                Text("Tyre \(currentTyreIndex + 1) of 4")
                    .font(.system(size: 13, weight: .medium)).foregroundColor(.midGray)
                HStack(spacing: 4) {
                    Text(level.emoji).font(.system(size: 10))
                    Text(level.title).font(.system(size: 10, weight: .semibold)).foregroundColor(level.color)
                    if isMusclememory {
                        Text("• 🧠 Muscle Memory").font(.system(size: 10)).foregroundColor(.powerCoral)
                    }
                }
            }
            Spacer()
            Text(timeRemaining.timerString)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .padding(.horizontal, 12).padding(.vertical, 6)
                .background(timerColor).cornerRadius(10)
        }
    }

    // MARK: - Timer Bar
    private var timerBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4).fill(Color.softGray2).frame(height: 8)
                RoundedRectangle(cornerRadius: 4)
                    .fill(timerColor)
                    .frame(width: geo.size.width * CGFloat(timeRemaining / level.timerDuration), height: 8)
                    .animation(.linear(duration: 0.1), value: timeRemaining)
            }
        }
        .frame(height: 8)
    }

    // MARK: - Animated Car
    private var animatedCarSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4).fill(Color.softGray3).frame(height: 3).offset(y: 38)
            AnimatedF1Car(
                tyreStates: tyreStates,
                currentTyreIndex: currentTyreIndex,
                bounceOffset: carBounce,
                wiggleAngle: carWiggle,
                tyreSpinAngle: tyreSpinAngle,
                completedTyreIndex: completedTyreOnCar
            )
            .frame(width: 160, height: 70)
            .offset(y: carBounce)
            .rotationEffect(.degrees(carWiggle))
            .animation(.spring(response: 0.3, dampingFraction: 0.4), value: carBounce)

            if showTyreCompleteFlash {
                Text("Tyre Changed! ✓")
                    .font(.system(size: 12, weight: .bold)).foregroundColor(.okGreen)
                    .padding(.horizontal, 12).padding(.vertical, 5)
                    .background(Color.white).cornerRadius(20)
                    .shadow(color: Color.okGreen.opacity(0.3), radius: 6)
                    .offset(y: -42)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(height: 80).frame(maxWidth: .infinity)
        .background(Color.white).cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.softGray3, lineWidth: 0.5))
    }

    // MARK: - Tyre Interaction Area
    private var tyreInteractionArea: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20).fill(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.softGray3, lineWidth: 0.5))
                .frame(height: 180)
            VStack(spacing: 12) {
                tyreGraphic
                Text("Touch the tyre to interact").font(.system(size: 11)).foregroundColor(.midGray)
            }
        }
        .opacity(isHandlingEvent ? 0.4 : 1.0)
        .allowsHitTesting(!isHandlingEvent)
        .animation(.easeInOut(duration: 0.3), value: isHandlingEvent)
    }

    // MARK: - Tyre Graphic
    private var tyreGraphic: some View {
        ZStack {
            Circle().stroke(Color.darkBase, lineWidth: 18).frame(width: 108, height: 108)
            Circle().fill(Color.softGray2).frame(width: 72, height: 72)
            ForEach(0..<5, id: \.self) { i in
                Circle().fill(Color.midGray).frame(width: 8, height: 8)
                    .offset(y: -22)
                    .rotationEffect(.degrees(Double(i) * 72 + tyreSpinAngle))
            }
            Circle().fill(Color.powerCoral).frame(width: 18, height: 18)
            Circle().stroke(Color.powerCoral, lineWidth: 2).frame(width: 108, height: 108)
                .scaleEffect(tapRingScale).opacity(tapRingOpacity)
            if currentStep == TyreStep.tightenNut.rawValue {
                Circle()
                    .trim(from: 0, to: longPressProgress)
                    .stroke(Color.okGreen, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .frame(width: 134, height: 134)
                    .rotationEffect(.degrees(-90))
            }
        }
        .scaleEffect(tyreScale)
        .offset(x: tyreOffset)
        .onTapGesture {
            guard currentStep == TyreStep.loostenNut.rawValue, !isHandlingEvent else { return }
            animateTapRing()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            tapCount += 1
            if tapCount >= level.loostenTapCount { animateTyreComplete(); onStepComplete() }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: level.swipeDistance).onEnded { val in
                guard !isHandlingEvent else { return }
                if currentStep == TyreStep.removeTyre.rawValue {
                    guard val.translation.width < -level.swipeDistance else { shakeInstruction(); return }
                    withAnimation(.easeIn(duration: 0.25)) { tyreOffset = -200 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { tyreOffset = 0; onStepComplete() }
                } else if currentStep == TyreStep.fitNewTyre.rawValue {
                    guard val.translation.width > level.swipeDistance else { shakeInstruction(); return }
                    withAnimation(.spring()) { tyreOffset = 200 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) { tyreOffset = 0; tyreScale = 1.1 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.spring()) { tyreScale = 1.0 }
                            onStepComplete()
                        }
                    }
                }
            }
        )
        .simultaneousGesture(
            LongPressGesture(minimumDuration: level.longPressDuration)
                .onChanged { (value: LongPressGesture.Value) in
                    guard currentStep == TyreStep.tightenNut.rawValue, !isHandlingEvent else { return }
                    withAnimation(.linear(duration: level.longPressDuration)) { longPressProgress = 1.0 }
                }
                .onEnded { _ in
                    guard currentStep == TyreStep.tightenNut.rawValue, !isHandlingEvent else { return }
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    withAnimation(.spring()) { showFlash = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showFlash = false; longPressProgress = 0; onStepComplete()
                    }
                }
        )
    }

    // MARK: - Step Chips
    private var stepChips: some View {
        HStack(spacing: 8) {
            ForEach(TyreStep.allCases, id: \.rawValue) { step in
                HStack(spacing: isMusclememory ? 0 : 4) {
                    Image(systemName: step.systemIcon).font(.system(size: isMusclememory ? 14 : 10, weight: .medium))
                    if !isMusclememory {
                        Text(step.label).font(.system(size: 10, weight: .semibold))
                    }
                }
                .padding(.horizontal, isMusclememory ? 12 : 10)
                .padding(.vertical, 6)
                .background(chipBg(for: step.rawValue))
                .foregroundColor(chipFg(for: step.rawValue))
                .cornerRadius(20)
            }
        }
    }

    private func chipBg(for index: Int) -> Color {
        if index < currentStep  { return .okGreen }
        if index == currentStep { return level.color }
        return .softGray2
    }

    private func chipFg(for index: Int) -> Color { index <= currentStep ? .white : .midGray }

    // MARK: - Instruction Box
    private var instructionBox: some View {
        let step = TyreStep(rawValue: currentStep) ?? .loostenNut
        return HStack(spacing: 10) {
            Image(systemName: step.systemIcon).font(.system(size: 18, weight: .medium)).foregroundColor(level.color)
            VStack(alignment: .leading, spacing: 2) {
                Text("Step \(currentStep + 1) of 4").font(.system(size: 10, weight: .medium)).foregroundColor(level.color)
                Text(step.instruction(for: level)).font(.system(size: 13, weight: .semibold)).foregroundColor(.darkBase)
                if currentStep == TyreStep.loostenNut.rawValue {
                    HStack(spacing: 4) {
                        ForEach(0..<level.loostenTapCount, id: \.self) { i in
                            Circle()
                                .fill(i < tapCount ? level.color : Color.softGray3)
                                .frame(width: 8, height: 8)
                        }
                    }.padding(.top, 2)
                }
            }
            Spacer()
        }
        .padding(14)
        .background(level.color.opacity(0.1))
        .cornerRadius(14)
        .offset(x: instructionShake ? -6 : 0)
    }

    // MARK: - Muscle Memory Hint
    private var musclememoryHint: some View {
        HStack(spacing: 8) {
            Image(systemName: "brain.head.profile").font(.system(size: 14)).foregroundColor(level.color)
            Text("Muscle Memory Mode — no instructions. Trust your training!")
                .font(.system(size: 12, weight: .medium)).foregroundColor(.midGray)
            Spacer()
        }
        .padding(12).background(level.color.opacity(0.08)).cornerRadius(14)
    }

    // MARK: - Quit Overlay
    private var quitConfirmOverlay: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Quit the game?").font(.system(size: 17, weight: .semibold)).foregroundColor(.darkBase)
                Text("Your current progress will be lost.").font(.system(size: 13)).foregroundColor(.midGray).multilineTextAlignment(.center)
                HStack(spacing: 12) {
                    Button("Keep Playing") { showQuitConfirm = false }
                        .font(.system(size: 15, weight: .medium)).foregroundColor(.midGray)
                        .frame(maxWidth: .infinity).padding(.vertical, 14).background(Color.softGray2).cornerRadius(14)
                    Button("Quit") { showQuitConfirm = false; onQuit() }
                        .font(.system(size: 15, weight: .semibold)).foregroundColor(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 14).background(Color.powerCoral).cornerRadius(14)
                }
            }
            .padding(24).background(Color.white).cornerRadius(20).padding(.horizontal, 32)
        }
    }

    // MARK: - Car Bounce
    func triggerCarTyreComplete(tyreIndex: Int) {
        completedTyreOnCar = tyreIndex
        withAnimation(.spring(response: 0.2, dampingFraction: 0.3)) { carBounce = -10; carWiggle = -2 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) { carBounce = 0; carWiggle = 0 }
        }
        withAnimation(.spring()) { showTyreCompleteFlash = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeOut(duration: 0.3)) { showTyreCompleteFlash = false }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) { carBounce = -5 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { withAnimation(.spring()) { carBounce = 0 } }
        }
    }

    private func animateTapRing() {
        tapRingScale = 1.0; tapRingOpacity = 0.8
        withAnimation(.easeOut(duration: 0.4)) { tapRingScale = 1.5; tapRingOpacity = 0 }
    }

    private func animateTyreComplete() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { tyreScale = 1.2 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { withAnimation(.spring()) { tyreScale = 1.0 } }
    }

    private func shakeInstruction() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        withAnimation(.default) { instructionShake = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { withAnimation(.default) { instructionShake = false } }
    }
}

// MARK: - Pit Event Overlay
struct PitEventOverlay: View {
    let event: PitEvent
    @Binding var eventTapCount: Int
    var onResolved: () -> Void

    @State private var safetyCar_timeLeft: Int = 4
    @State private var safetyCarTimer: Timer? = nil
    @State private var pulse: Bool = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.55).ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text(event.title).font(.system(size: 16, weight: .black)).foregroundColor(.white)
                    Spacer()
                }
                .padding(.vertical, 14).background(event.accentColor)

                VStack(spacing: 16) {
                    Text(event.description).font(.system(size: 13)).foregroundColor(.darkBase).multilineTextAlignment(.center)
                    switch event {
                    case .strippedNut: strippedNutInteraction
                    case .wrongTyre:   wrongTyreInteraction
                    case .safetyCar:   safetyCarWait
                    }
                }
                .padding(20).background(Color.white)
            }
            .cornerRadius(20).padding(.horizontal, 28)
            .scaleEffect(pulse ? 1.01 : 1.0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) { pulse = true }
                if event == .safetyCar { startSafetyCarCountdown() }
            }
            .onDisappear { safetyCarTimer?.invalidate() }
        }
    }

    private var strippedNutInteraction: some View {
        VStack(spacing: 12) {
            HStack(spacing: 6) {
                ForEach(0..<8, id: \.self) { i in
                    Circle().fill(i < eventTapCount ? Color.warnAmber : Color.softGray3).frame(width: 10, height: 10)
                }
            }
            Text("\(eventTapCount)/8 taps").font(.system(size: 12, weight: .medium)).foregroundColor(.midGray)
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                eventTapCount += 1
                if eventTapCount >= 8 {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    eventTapCount = 0; onResolved()
                }
            }) {
                Text("TAP HERE").font(.system(size: 15, weight: .bold)).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                    .background(Color.warnAmber).cornerRadius(14)
            }
        }
    }

    private var wrongTyreInteraction: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12).fill(Color.dangerRed.opacity(0.1)).frame(height: 60)
                HStack(spacing: 10) {
                    Image(systemName: "arrow.left").font(.system(size: 18, weight: .bold)).foregroundColor(.dangerRed)
                    Text("Swipe LEFT to reject").font(.system(size: 13, weight: .semibold)).foregroundColor(.dangerRed)
                }
            }
            .gesture(DragGesture(minimumDistance: 40).onEnded { val in
                guard val.translation.width < -40 else { return }
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                onResolved()
            })
        }
    }

    private var safetyCarWait: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle().stroke(Color.warnAmber.opacity(0.3), lineWidth: 6).frame(width: 70, height: 70)
                Circle()
                    .trim(from: 0, to: CGFloat(safetyCar_timeLeft) / 4.0)
                    .stroke(Color.warnAmber, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 70, height: 70).rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: safetyCar_timeLeft)
                Text("\(safetyCar_timeLeft)").font(.system(size: 28, weight: .black, design: .monospaced)).foregroundColor(.warnAmber)
            }
            Text("Timer paused. Resume in \(safetyCar_timeLeft)s").font(.system(size: 11)).foregroundColor(.midGray)
        }
    }

    private func startSafetyCarCountdown() {
        safetyCar_timeLeft = 4
        safetyCarTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            if safetyCar_timeLeft > 1 { safetyCar_timeLeft -= 1 } else { t.invalidate() }
        }
    }
}

// MARK: - Animated F1 Car
struct AnimatedF1Car: View {
    let tyreStates: [TyreState]
    let currentTyreIndex: Int
    let bounceOffset: CGFloat
    let wiggleAngle: Double
    let tyreSpinAngle: Double
    let completedTyreIndex: Int

    private let tyreOffsets: [(x: CGFloat, y: CGFloat)] = [(-52,-22),(52,-22),(-52,22),(52,22)]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3).fill(Color.powerCoral).frame(width: 6, height: 52).offset(x: 65)
            RoundedRectangle(cornerRadius: 10).fill(Color.darkBase).frame(width: 110, height: 36)
            RoundedRectangle(cornerRadius: 8).fill(Color(hex: "#2C2C2E")).frame(width: 44, height: 24).offset(x: -6)
            RoundedRectangle(cornerRadius: 5).fill(Color(hex: "#1A6B8A").opacity(0.7)).frame(width: 28, height: 14).offset(x: -8)
            Rectangle().fill(Color.powerCoral).frame(width: 110, height: 4).offset(y: -8)
            RoundedRectangle(cornerRadius: 4).fill(Color(hex: "#2C2C2E")).frame(width: 60, height: 10).offset(x: -8, y: -22)
            RoundedRectangle(cornerRadius: 4).fill(Color(hex: "#2C2C2E")).frame(width: 60, height: 10).offset(x: -8, y: 22)
            RoundedRectangle(cornerRadius: 3).fill(Color.powerCoral).frame(width: 8, height: 46).offset(x: -64)
            ForEach(0..<4, id: \.self) { i in
                CarTyreView(index: i, state: tyreStates[i], isActive: i == currentTyreIndex, spinAngle: tyreSpinAngle, justChanged: i == completedTyreIndex)
                    .offset(x: tyreOffsets[i].x, y: tyreOffsets[i].y)
            }
        }
    }
}

// MARK: - Car Tyre View
struct CarTyreView: View {
    let index: Int
    let state: TyreState
    let isActive: Bool
    let spinAngle: Double
    let justChanged: Bool
    @State private var glowPulse: Bool = false

    private var tyreColor: Color {
        switch state {
        case .complete: return .okGreen
        case .active:   return .powerCoral
        case .idle:     return Color(hex: "#1C1C1E")
        }
    }

    var body: some View {
        ZStack {
            Circle().fill(tyreColor).frame(width: 18, height: 18)
            Circle().fill(state == .complete ? Color.white.opacity(0.3) : Color.softGray3).frame(width: 9, height: 9)
            if state != .complete {
                Rectangle().fill(Color.softGray3.opacity(0.6)).frame(width: 1.5, height: 7).offset(y: -1.5)
                    .rotationEffect(.degrees(spinAngle))
            } else {
                Image(systemName: "checkmark").font(.system(size: 6, weight: .black)).foregroundColor(.white)
            }
            if isActive {
                Circle().stroke(Color.powerCoral, lineWidth: 2).frame(width: 24, height: 24)
                    .scaleEffect(glowPulse ? 1.3 : 1.0).opacity(glowPulse ? 0 : 0.8)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: false)) { glowPulse = true }
                    }
            }
        }
        .scaleEffect(justChanged ? 1.25 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.4), value: justChanged)
        .animation(.easeInOut(duration: 0.3), value: state)
    }
}

// MARK: - Pit Lane Exit
struct PitLaneExitView: View {
    var onComplete: () -> Void
    @State private var carX: CGFloat = 0
    @State private var carScale: CGFloat = 1.0
    @State private var carOpacity: Double = 1.0
    @State private var speedLines: Bool = false
    @State private var showMessage: Bool = false

    var body: some View {
        ZStack {
            Color.softGray.ignoresSafeArea()
            if speedLines { SpeedLinesView().opacity(0.4).transition(.opacity) }
            VStack(spacing: 20) {
                Text("Pit Stop Complete!").font(.system(size: 22, weight: .black)).foregroundColor(.darkBase)
                    .opacity(showMessage ? 1 : 0).offset(y: showMessage ? 0 : 10)
                ZStack {
                    Rectangle().fill(Color.softGray3).frame(height: 3).padding(.horizontal, 20)
                    AnimatedF1Car(tyreStates: [.complete,.complete,.complete,.complete], currentTyreIndex: -1, bounceOffset: 0, wiggleAngle: 0, tyreSpinAngle: 0, completedTyreIndex: -1)
                        .frame(width: 160, height: 70).scaleEffect(carScale).offset(x: carX).opacity(carOpacity)
                }
                .frame(height: 100)
                Text("All 4 tyres changed!").font(.system(size: 14, weight: .medium)).foregroundColor(.midGray)
                    .opacity(showMessage ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.4).delay(0.2)) { showMessage = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeIn(duration: 0.2)) { speedLines = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(.easeIn(duration: 0.6)) { carX = 400; carScale = 0.6; carOpacity = 0 }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { onComplete() }
        }
    }
}

// MARK: - Speed Lines
struct SpeedLinesView: View {
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<12, id: \.self) { i in
                let yPos = CGFloat(i) * (geo.size.height / 12)
                let width = CGFloat.random(in: 60...180)
                let xPos = CGFloat.random(in: 0...geo.size.width * 0.6)
                Rectangle().fill(Color.softGray3).frame(width: width, height: 1.5).position(x: xPos + width/2, y: yPos)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Previews



// MARK: ============================================================
// MARK: - RESULT SCREEN
// MARK: ============================================================

// MARK: - Result Screen
struct ResultScreenView: View {

    let elapsedTime: Double
    let level: GameLevel
    var onPlayAgain: () -> Void
    var onMainMenu: () -> Void

    @State private var showContent: Bool = false
    @State private var factIndex: Int = 0
    @State private var starsShown: Int = 0
    @State private var isNewRecord: Bool = false
    @State private var previousBest: Double = 0

    private var rank: CrewRank { CrewRank(time: elapsedTime, level: level) }
    private var facts: [TVETFact] { TVETFact.all }
    private var starCount: Int {
        switch rank {
        case .pro:     return 3
        case .rookie:  return 2
        case .trainee: return 1
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // ── Level Badge ────────────────────────────
                HStack(spacing: 6) {
                    Text(level.emoji)
                    Text(level.title + " Mode")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(level.color)
                }
                .padding(.horizontal, 14).padding(.vertical, 6)
                .background(level.color.opacity(0.1))
                .cornerRadius(20)
                .padding(.top, 20)

                // ── Star Rating ────────────────────────────
                starRatingView.padding(.top, 16).padding(.bottom, 8)

                // ── Result Hero Card ───────────────────────
                VStack(spacing: 12) {
                    if isNewRecord {
                        HStack(spacing: 6) {
                            Image(systemName: "trophy.fill").font(.system(size: 12))
                            Text("NEW PERSONAL BEST!")
                                .font(.system(size: 11, weight: .bold)).tracking(0.5)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 14).padding(.vertical, 6)
                        .background(Color.white.opacity(0.25)).cornerRadius(20)
                        .scaleEffect(showContent ? 1 : 0.5).opacity(showContent ? 1 : 0)
                    }

                    Text("Congratulations! 🎉")
                        .font(.system(size: 14, weight: .medium)).foregroundColor(.white.opacity(0.85))

                    Text(elapsedTime.timerString)
                        .font(.system(size: 52, weight: .black, design: .monospaced)).foregroundColor(.white)

                    if previousBest > 0 && !isNewRecord {
                        let diff = elapsedTime - previousBest
                        HStack(spacing: 4) {
                            Image(systemName: "clock.arrow.circlepath").font(.system(size: 11))
                            Text("Best: \(previousBest.timerString)  (+\(String(format: "%.1f", diff))s)")
                                .font(.system(size: 11))
                        }
                        .foregroundColor(.white.opacity(0.7))
                    } else if previousBest > 0 && isNewRecord {
                        let diff = previousBest - elapsedTime
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.down.circle.fill").font(.system(size: 11))
                            Text("\(String(format: "%.1f", diff))s faster than your best!")
                                .font(.system(size: 11))
                        }
                        .foregroundColor(.white.opacity(0.85))
                    }

                    Text(rank.message)
                        .font(.system(size: 12)).foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center).padding(.horizontal, 8)
                }
                .padding(.vertical, 24).padding(.horizontal, 20).frame(maxWidth: .infinity)
                .background(rank.color).cornerRadius(24)
                .padding(.horizontal, 20)
                .scaleEffect(showContent ? 1 : 0.88).opacity(showContent ? 1 : 0)

                // ── Ranking Guide ──────────────────────────
                rankingGuide.padding(.horizontal, 20).padding(.top, 16).opacity(showContent ? 1 : 0)

                // ── TVET Facts ─────────────────────────────
                VStack(alignment: .leading, spacing: 10) {
                    Text("Automotive TVET Facts")
                        .font(.system(size: 13, weight: .semibold)).foregroundColor(.midGray)
                        .padding(.horizontal, 20)
                    TabView(selection: $factIndex) {
                        ForEach(facts.indices, id: \.self) { i in
                            TVETFactCard(fact: facts[i]).padding(.horizontal, 20).tag(i)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always)).frame(height: 130).tint(.powerCoral)
                }
                .padding(.top, 20).opacity(showContent ? 1 : 0)

                // ── Buttons ────────────────────────────────
                VStack(spacing: 10) {
                    Button(action: onPlayAgain) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Try Again (\(level.title))")
                        }
                        .font(.system(size: 15, weight: .semibold)).foregroundColor(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 16)
                        .background(level.color).cornerRadius(16)
                    }
                    Button(action: onMainMenu) {
                        Text("Change Level")
                            .font(.system(size: 15, weight: .medium)).foregroundColor(.midGray)
                            .frame(maxWidth: .infinity).padding(.vertical, 14)
                            .background(Color.softGray2).cornerRadius(16)
                    }
                }
                .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 40)
                .opacity(showContent ? 1 : 0)
            }
        }
        .background(Color.softGray.ignoresSafeArea())
        .onAppear { checkAndSavePersonalBest(); animateEntrance() }
    }

    // MARK: - Star Rating
    private var starRatingView: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                ForEach(0..<3, id: \.self) { i in
                    StarView(filled: i < starsShown, size: i == 1 ? 64 : 52, color: starColor(for: i))
                }
            }
            Text(rank.title).font(.system(size: 15, weight: .bold)).foregroundColor(rank.color)
                .opacity(showContent ? 1 : 0)
        }
    }

    private func starColor(for index: Int) -> Color {
        switch rank {
        case .pro:     return index == 1 ? level.color : level.color.opacity(0.85)
        case .rookie:  return .warnAmber
        case .trainee: return .softGray3
        }
    }

    // MARK: - Ranking Guide
    private var rankingGuide: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ranking Table — \(level.title) Mode")
                .font(.system(size: 12, weight: .medium)).foregroundColor(.midGray)
            HStack(spacing: 8) {
                RankRow(title: "Pro Crew",  range: "< \(Int(level.proTime))s",    color: level.color,  isActive: rank == .pro)
                RankRow(title: "Rookie",    range: "\(Int(level.proTime))–\(Int(level.rookieTime))s", color: .warnAmber, isActive: rank == .rookie)
                RankRow(title: "Trainee",   range: "> \(Int(level.rookieTime))s", color: .midGray,     isActive: rank == .trainee)
            }
        }
    }

    // MARK: - Personal Best
    private func checkAndSavePersonalBest() {
        let saved = PersonalBestManager.getBest(for: level)
        if saved == 0 {
            PersonalBestManager.saveBest(elapsedTime, for: level)
            isNewRecord = true; previousBest = 0
        } else if elapsedTime < saved {
            PersonalBestManager.saveBest(elapsedTime, for: level)
            isNewRecord = true; previousBest = saved
        } else {
            isNewRecord = false; previousBest = saved
        }
    }

    // MARK: - Entrance Animation
    private func animateEntrance() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1)) { showContent = true }
        for i in 0..<starCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 + Double(i) * 0.22) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) { starsShown = i + 1 }
                UIImpactFeedbackGenerator(style: i == starCount - 1 ? .heavy : .medium).impactOccurred()
            }
        }
        if isNewRecord {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 + Double(starCount) * 0.22 + 0.1) {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        }
    }
}

// MARK: - Star View
struct StarView: View {
    let filled: Bool; let size: CGFloat; let color: Color
    @State private var appeared: Bool = false

    var body: some View {
        Image(systemName: filled ? "star.fill" : "star")
            .font(.system(size: size)).foregroundColor(filled ? color : Color.softGray3)
            .shadow(color: filled ? color.opacity(0.4) : .clear, radius: 8, y: 4)
            .scaleEffect(appeared ? 1.0 : 0.1).rotationEffect(.degrees(appeared ? 0 : -30))
            .onAppear {
                if filled { withAnimation(.spring(response: 0.35, dampingFraction: 0.5)) { appeared = true } }
                else { appeared = true }
            }
            .onChange(of: filled) { _, newVal in
                if newVal { appeared = false; withAnimation(.spring(response: 0.35, dampingFraction: 0.5)) { appeared = true } }
            }
    }
}

// MARK: - Rank Row
private struct RankRow: View {
    let title: String; let range: String; let color: Color; let isActive: Bool
    var body: some View {
        VStack(spacing: 4) {
            Text(title).font(.system(size: 11, weight: .semibold)).foregroundColor(isActive ? .white : color)
            Text(range).font(.system(size: 10)).foregroundColor(isActive ? .white.opacity(0.8) : .midGray)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 10)
        .background(isActive ? color : color.opacity(0.1)).cornerRadius(12)
    }
}

// MARK: - TVET Fact Card
struct TVETFactCard: View {
    let fact: TVETFact
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 2).fill(Color.powerCoral).frame(width: 3)
            VStack(alignment: .leading, spacing: 6) {
                Text(fact.category.uppercased())
                    .font(.system(size: 10, weight: .semibold)).foregroundColor(.powerCoral).tracking(0.5)
                HighlightedText(fullText: fact.content, highlight: fact.highlight,
                    baseFont: .system(size: 12), baseColor: .darkBase, highlightColor: .powerCoral)
                    .lineLimit(nil).fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(14).background(Color.white).cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.softGray3, lineWidth: 0.5))
    }
}

// MARK: - Highlighted Text
struct HighlightedText: View {
    let fullText: String; let highlight: String
    let baseFont: Font; let baseColor: Color; let highlightColor: Color
    var body: some View {
        let parts = fullText.components(separatedBy: highlight)
        return parts.indices.reduce(Text("")) { result, i in
            let part = result + Text(parts[i]).font(baseFont).foregroundColor(baseColor)
            if i < parts.count - 1 {
                return part + Text(highlight).font(baseFont).foregroundColor(highlightColor).bold()
            }
            return part
        }
    }
}




// MARK: ============================================================
// MARK: - ROOT VIEW (entry point)
// MARK: ============================================================

// MARK: - Root Game View
struct PitStopView: View {

    @State private var screen: PitStopScreen = .start
    @State private var selectedLevel: GameLevel = .medium

    // Gameplay state
    @State private var timeRemaining: Double = 90
    @State private var currentTyreIndex: Int = 0
    @State private var currentStep: Int = 0
    @State private var tyreStates: [TyreState] = Array(repeating: .idle, count: 4)
    @State private var tapCount: Int = 0
    @State private var timer: Timer? = nil
    @State private var tyreJustCompleted: Int = -1

    // Event state
    @State private var activePitEvent: PitEvent? = nil
    @State private var isHandlingEvent: Bool = false

    var body: some View {
        ZStack {
            Color.softGray.ignoresSafeArea()
            currentScreenView
        }
        .animation(.easeInOut(duration: 0.35), value: screen)
    }

    @ViewBuilder
    private var currentScreenView: some View {
        if case .start = screen {
            StartScreenView(
                onStart:     { withAnimation(.easeInOut(duration: 0.35)) { screen = .levelSelect } },
                onHowToPlay: { withAnimation(.easeInOut(duration: 0.35)) { screen = .tutorial } }
            )
            .transition(.opacity)
        } else if case .levelSelect = screen {
            LevelSelectView(
                onSelect: { chosenLevel in
                    selectedLevel = chosenLevel
                    withAnimation(.easeInOut(duration: 0.35)) { screen = .tutorial }
                },
                onBack: { withAnimation(.easeInOut(duration: 0.35)) { screen = .start } }
            )
            .transition(.move(edge: .trailing).combined(with: .opacity))
        } else if case .tutorial = screen {
            TutorialView(
                level:   selectedLevel,
                onBegin: { startCountdown() },
                onBack:  { withAnimation(.easeInOut(duration: 0.35)) { screen = .levelSelect } }
            )
            .transition(.move(edge: .bottom).combined(with: .opacity))
        } else if case .countdown(let num) = screen {
            CountdownView(number: num)
                .transition(.scale.combined(with: .opacity))
        } else if case .gameplay = screen {
            GameplayView(
                level:             selectedLevel,
                timeRemaining:     $timeRemaining,
                currentTyreIndex:  $currentTyreIndex,
                currentStep:       $currentStep,
                tyreStates:        $tyreStates,
                tapCount:          $tapCount,
                tyreJustCompleted: $tyreJustCompleted,
                activePitEvent:    $activePitEvent,
                isHandlingEvent:   $isHandlingEvent,
                onStepComplete:    { handleStepComplete() },
                onEventResolved:   { nextTyre in handleEventResolved(nextTyre: nextTyre) },
                onQuit:            { resetGame() }
            )
            .transition(.opacity)
        } else if case .pitLaneExit = screen {
            PitLaneExitView(onComplete: {
                let elapsed = selectedLevel.timerDuration - timeRemaining
                withAnimation(.easeInOut(duration: 0.35)) { screen = .result(elapsed) }
            })
            .transition(.opacity)
        } else if case .result(let elapsed) = screen {
            ResultScreenView(
                elapsedTime: elapsed,
                level:       selectedLevel,
                onPlayAgain: { resetGame(goToLevel: true) },
                onMainMenu:  { resetGame(goToLevel: false) }
            )
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    // MARK: - Flow

    private func startCountdown() {
        runCountdown(from: 3)
    }

    private func runCountdown(from count: Int) {
        guard count > 0 else {
            withAnimation(.easeInOut(duration: 0.35)) { screen = .gameplay }
            startTimer()
            return
        }
        withAnimation(.easeInOut(duration: 0.35)) { screen = .countdown(count) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            runCountdown(from: count - 1)
        }
    }

    private func startTimer() {
        timeRemaining = selectedLevel.timerDuration
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            guard !isHandlingEvent || activePitEvent != .safetyCar else { return }
            timeRemaining -= 0.1
            if timeRemaining <= 0 {
                timeRemaining = 0
                endGame()
            }
        }
    }

    // MARK: - Step / Tyre Logic

    func handleStepComplete() {
        let nextStep = currentStep + 1
        if nextStep >= TyreStep.allCases.count {
            completeTyre()
        } else {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) { currentStep = nextStep }
        }
        tapCount = 0
    }

    private func completeTyre() {
        var updated = tyreStates
        updated[currentTyreIndex] = .complete
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) { tyreStates = updated }

        tyreJustCompleted = currentTyreIndex
        UINotificationFeedbackGenerator().notificationOccurred(.success)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            tyreJustCompleted = -1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let nextTyre = currentTyreIndex + 1
            if nextTyre >= 4 { endGame(); return }

            if let event = PitEvent.roll(afterTyre: currentTyreIndex, level: selectedLevel) {
                triggerEvent(event, nextTyre: nextTyre)
            } else {
                advanceToNextTyre(nextTyre)
            }
        }
    }

    // MARK: - Random Event

    private func triggerEvent(_ event: PitEvent, nextTyre: Int) {
        activePitEvent = event
        isHandlingEvent = true

        if event == .safetyCar {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                handleEventResolved(nextTyre: nextTyre)
            }
        }
    }

    func handleEventResolved(nextTyre: Int = -1) {
        let target = nextTyre == -1 ? currentTyreIndex + 1 : nextTyre
        withAnimation(.easeOut(duration: 0.3)) {
            activePitEvent = nil
            isHandlingEvent = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            advanceToNextTyre(target)
        }
    }

    private func advanceToNextTyre(_ nextTyre: Int) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            currentTyreIndex = nextTyre
            currentStep = 0
            var s = tyreStates
            s[nextTyre] = .active
            tyreStates = s
        }
    }

    private func endGame() {
        timer?.invalidate()
        timer = nil
        MusclememoryManager.incrementPlayCount()
        withAnimation(.easeInOut(duration: 0.35)) { screen = .pitLaneExit }
    }

    private func resetGame(goToLevel: Bool = false) {
        timer?.invalidate()
        timer = nil
        timeRemaining = selectedLevel.timerDuration
        currentTyreIndex = 0
        currentStep = 0
        tapCount = 0
        tyreJustCompleted = -1
        activePitEvent = nil
        isHandlingEvent = false
        tyreStates = Array(repeating: .idle, count: 4)
        withAnimation(.easeInOut(duration: 0.35)) { screen = goToLevel ? .levelSelect : .start }
    }
}

#Preview {
    PitStopView()
}
