import SwiftUI
import AVFoundation
import Foundation
import Combine



extension Color {
    static let fashionBrandOrange = Color(red: 216/255, green: 90/255, blue: 48/255)
    static let fashionBrandCream  = Color(red: 241/255, green: 239/255, blue: 232/255)
}

enum FashionSewingTool: String, CaseIterable, Equatable, Identifiable {
    
    case measuringTape
    case lRuler
    case curvedRuler
    case patternPaper
    case fabricScissors
    
    
    case threadSnipper
    case cuttingMachine
    case tailorChalk
    case tracingWheel
    case carbonPaper
    case rotaryCutter
    case pinkingShears
    case dressForm
    case frenchCurve
    case seamGauge
    
    
    case seamRipper
    case safetyPin
    case steamIron
    case magneticHolder
    case needle
    case thimble
    case bobbin
    case pressingHam
    case clapper
    case hemMarker
    case patternNotcher
    case pointPresser
    case sleeveBoard
    case awl
    case buttons
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        // Level 1
        case .measuringTape: return "Measuring Tape"
        case .lRuler: return "L Ruler"
        case .curvedRuler: return "Curved Ruler"
        case .patternPaper: return "Pattern Paper"
        case .fabricScissors: return "Fabric Scissors"
        // Level 2
        case .threadSnipper: return "Thread Snipper"
        case .cuttingMachine: return "Cutting Machine"
        case .tailorChalk: return "Tailor Chalk"
        case .tracingWheel: return "Tracing Wheel"
        case .carbonPaper: return "Carbon Paper"
        case .rotaryCutter: return "Rotary Cutter"
        case .pinkingShears: return "Pinking Shears"
        case .dressForm: return "Dress Form"
        case .frenchCurve: return "French Curve"
        case .seamGauge: return "Seam Gauge"
        // Level 3
        case .seamRipper: return "Seam Ripper"
        case .safetyPin: return "Safety Pin"
        case .steamIron: return "Steam Iron"
        case .magneticHolder: return "Magnetic Holder"
        case .needle: return "Needle"
        case .thimble: return "Thimble"
        case .bobbin: return "Bobbin"
        case .pressingHam: return "Pressing Ham"
        case .clapper: return "Clapper"
        case .hemMarker: return "Hem Marker"
        case .patternNotcher: return "Pattern Notcher"
        case .pointPresser: return "Point Presser"
        case .sleeveBoard: return "Sleeve Board"
        case .awl: return "Awl"
        case .buttons: return "Buttons"
        }
    }
    
    var imageName: String {
        switch self {
        // Level 1
        case .measuringTape: return "measuring_tape"
        case .lRuler: return "l_ruler"
        case .curvedRuler: return "curved_ruler"
        case .patternPaper: return "pattern_paper"
        case .fabricScissors: return "fabric_scissors"
        // Level 2
        case .threadSnipper: return "thread_snipper"
        case .cuttingMachine: return "cutting_machine"
        case .tailorChalk: return "tailor_chalk"
        case .tracingWheel: return "tracing_wheel"
        case .carbonPaper: return "carbon_paper"
        case .rotaryCutter: return "rotary_cutter"
        case .pinkingShears: return "pinking_shears"
        case .dressForm: return "dress_form"
        case .frenchCurve: return "french_curve"
        case .seamGauge: return "seam_gauge"
        // Level 3
        case .seamRipper: return "seam_ripper"
        case .safetyPin: return "safety_pin"
        case .steamIron: return "steam_iron"
        case .magneticHolder: return "magnetic_holder"
        case .needle: return "needle"
        case .thimble: return "thimble"
        case .bobbin: return "bobbin"
        case .pressingHam: return "pressing_ham"
        case .clapper: return "clapper"
        case .hemMarker: return "hem_marker"
        case .patternNotcher: return "pattern_notcher"
        case .pointPresser: return "point_presser"
        case .sleeveBoard: return "sleeve_board"
        case .awl: return "awl"
        case .buttons: return "buttons"
        }
    }
    
}

struct FashionQuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let answer: FashionSewingTool
    let targetCollect: Int
}

let fashionAllQuizBank: [FashionQuizQuestion] = [
    // LEVEL 1 (5 soalan - 5 tools unik)
    FashionQuizQuestion(question: "What tool is used to measure the body?", answer: .measuringTape, targetCollect: 15),
    FashionQuizQuestion(question: "What L-shaped tool is used for right angles?", answer: .lRuler, targetCollect: 15),
    FashionQuizQuestion(question: "What tool is used to draw curved lines?", answer: .curvedRuler, targetCollect: 15),
    FashionQuizQuestion(question: "What paper is used to make patterns?", answer: .patternPaper, targetCollect: 15),
    FashionQuizQuestion(question: "What large scissors are used for cutting fabric?", answer: .fabricScissors, targetCollect: 15),
    
    // LEVEL 2 (10 soalan - 10 tools unik)
    FashionQuizQuestion(question: "What small scissors cut threads?", answer: .threadSnipper, targetCollect: 15),
    FashionQuizQuestion(question: "What machine cuts multiple fabric layers?", answer: .cuttingMachine, targetCollect: 15),
    FashionQuizQuestion(question: "What tool marks fabric temporarily?", answer: .tailorChalk, targetCollect: 15),
    FashionQuizQuestion(question: "What toothed tool traces patterns?", answer: .tracingWheel, targetCollect: 15),
    FashionQuizQuestion(question: "What paper transfers patterns?", answer: .carbonPaper, targetCollect: 15),
    FashionQuizQuestion(question: "What circular blade cuts fabric smoothly?", answer: .rotaryCutter, targetCollect: 15),
    FashionQuizQuestion(question: "What scissors create zigzag edges?", answer: .pinkingShears, targetCollect: 15),
    FashionQuizQuestion(question: "What form is used for fitting garments?", answer: .dressForm, targetCollect: 15),
    FashionQuizQuestion(question: "What curved ruler helps draw armholes?", answer: .frenchCurve, targetCollect: 15),
    FashionQuizQuestion(question: "What tool measures seam allowances?", answer: .seamGauge, targetCollect: 15),
    
    // LEVEL 3 (15 soalan - 15 tools unik)
    FashionQuizQuestion(question: "What tool removes stitches?", answer: .seamRipper, targetCollect: 15),
    FashionQuizQuestion(question: "What pin holds fabric?", answer: .safetyPin, targetCollect: 15),
    FashionQuizQuestion(question: "What presses fabric with steam?", answer: .steamIron, targetCollect: 15),
    FashionQuizQuestion(question: "What holds needles automatically?", answer: .magneticHolder, targetCollect: 15),
    FashionQuizQuestion(question: "What tool does hand sewing?", answer: .needle, targetCollect: 15),
    FashionQuizQuestion(question: "What protects fingers while sewing?", answer: .thimble, targetCollect: 15),
    FashionQuizQuestion(question: "What holds lower thread in machine?", answer: .bobbin, targetCollect: 15),
    FashionQuizQuestion(question: "What curved cushion presses seams?", answer: .pressingHam, targetCollect: 15),
    FashionQuizQuestion(question: "What wooden tool flattens seams after pressing?", answer: .clapper, targetCollect: 15),
    FashionQuizQuestion(question: "What tool marks hem lines evenly?", answer: .hemMarker, targetCollect: 15),
    FashionQuizQuestion(question: "What tool cuts notches in pattern edges?", answer: .patternNotcher, targetCollect: 15),
    FashionQuizQuestion(question: "What tool presses small areas and points?", answer: .pointPresser, targetCollect: 15),
    FashionQuizQuestion(question: "What narrow board is used for pressing sleeves?", answer: .sleeveBoard, targetCollect: 15),
    FashionQuizQuestion(question: "What pointed tool punches holes in leather?", answer: .awl, targetCollect: 15),
    FashionQuizQuestion(question: "What small discs are used to fasten fabric?", answer: .buttons, targetCollect: 15)
]

enum FashionGameLevel: Int, CaseIterable {
    case easy = 1, medium, hard
    
    var gridSize: Int {
        switch self {
        case .easy: return 6
        case .medium: return 7
        case .hard: return 8
        }
    }
    
    var levelColor: Color {
        switch self {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .blue
        }
    }
    
    var questionsCount: Int {
        switch self {
        case .easy: return 5
        case .medium: return 10
        case .hard: return 15
        }
    }
    
    //Masa bagi collect jawapan
    var timePerQuestion: Int {
        switch self {
        case .easy:
            return 35      // Level 1
            
        case .medium:
            return 60      // Level 2
            
        case .hard:
            return 70      // Level 3
        }
    }
    
    var targetScore: Int { return questionsCount * 15 * 10 }
    
    var toolsInLevel: [FashionSewingTool] {
        switch self {
        case .easy:
            return [.measuringTape, .lRuler, .curvedRuler, .patternPaper, .fabricScissors]
        case .medium:
            return [.threadSnipper, .cuttingMachine, .tailorChalk, .tracingWheel, .carbonPaper,
                    .rotaryCutter, .pinkingShears, .dressForm, .frenchCurve, .seamGauge]
        case .hard:
            return [.seamRipper, .safetyPin, .steamIron, .magneticHolder, .needle,
                    .thimble, .bobbin, .pressingHam, .clapper, .hemMarker,
                    .patternNotcher, .pointPresser, .sleeveBoard, .awl, .buttons]
        }
    }
    
    var questionsForLevel: [FashionQuizQuestion] {
        switch self {
        case .easy:
            return fashionAllQuizBank.filter { [.measuringTape, .lRuler, .curvedRuler, .patternPaper, .fabricScissors].contains($0.answer) }
        case .medium:
            return fashionAllQuizBank.filter { [.threadSnipper, .cuttingMachine, .tailorChalk, .tracingWheel, .carbonPaper,
                                         .rotaryCutter, .pinkingShears, .dressForm, .frenchCurve, .seamGauge].contains($0.answer) }
        case .hard:
            return fashionAllQuizBank.filter { [.seamRipper, .safetyPin, .steamIron, .magneticHolder, .needle,
                                         .thimble, .bobbin, .pressingHam, .clapper, .hemMarker,
                                         .patternNotcher, .pointPresser, .sleeveBoard, .awl, .buttons].contains($0.answer) }
        }
    }
    
    var title: String {
        switch self {
        case .easy: return "Level 1 - Beginner"
        case .medium: return "Level 2 - Intermediate"
        case .hard: return "Level 3 - Expert"
        }
    }
}

struct FashionGridPosition: Hashable {
    let row: Int
    let col: Int
}



class FashionAudioManager: ObservableObject {
    static let shared = FashionAudioManager()
    
    // SFX Sounds
    private var matchSound: AVAudioPlayer?
    private var collectSound: AVAudioPlayer?
    private var winSound: AVAudioPlayer?
    private var wrongSound: AVAudioPlayer?
    private var swapSound: AVAudioPlayer?
    
    // Background Music
    private var bgMusic: AVAudioPlayer?
    
    @Published var isMuted: Bool = false
    @Published var musicVolume: Float = 0.3
    @Published var sfxVolume: Float = 0.7
    
    private init() {
        setupAudio()
    }
    
    func setupAudio() {
        loadSound(name: "correct", player: &matchSound)
        loadSound(name: "collect", player: &collectSound)
        loadSound(name: "win", player: &winSound)
        loadSound(name: "wrong", player: &wrongSound)
        loadSound(name: "swap", player: &swapSound)
        loadMusic(name: "bgmusic", player: &bgMusic)
    }
    
    // MARK: - Background Music Functions
    func playBackgroundMusic() {
        guard !isMuted else { return }
        guard let music = bgMusic else { return }
        
        music.numberOfLoops = -1
        music.volume = musicVolume
        music.currentTime = 0
        music.play()
    }
    
    func stopBackgroundMusic() {
        bgMusic?.stop()
        bgMusic?.currentTime = 0
    }
    
    func pauseBackgroundMusic() {
        bgMusic?.pause()
    }
    
    func resumeBackgroundMusic() {
        guard !isMuted else { return }
        bgMusic?.play()
    }
    
    func toggleMute() {
        isMuted.toggle()
        if isMuted {
            stopBackgroundMusic()
        } else {
            playBackgroundMusic()
        }
    }
    
    func setMusicVolume(_ volume: Float) {
        musicVolume = volume
        bgMusic?.volume = isMuted ? 0 : volume
    }
    
    // MARK: - Load Functions
    private func loadSound(name: String, player: inout AVAudioPlayer?) {
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else { return }
        let url = URL(filePath: path)
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = sfxVolume
            player?.prepareToPlay()
        } catch {
            print("❌ Failed to load sound \(name): \(error)")
        }
    }
    
    private func loadMusic(name: String, player: inout AVAudioPlayer?) {
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            print("❌ Music file \(name).mp3 not found!")
            return
        }
        let url = URL(filePath: path)
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.volume = musicVolume
            player?.prepareToPlay()
            print("✅ Music \(name) loaded successfully")
        } catch {
            print("❌ Failed to load music \(name): \(error)")
        }
    }
    
    // MARK: - SFX Functions
    func playSwap() {
        guard !isMuted else { return }
        swapSound?.currentTime = 0
        swapSound?.volume = sfxVolume
        swapSound?.play()
    }
    
    func playCorrect() {
        guard !isMuted else { return }
        matchSound?.currentTime = 0
        matchSound?.volume = sfxVolume
        matchSound?.play()
    }
    
    func playCollect() {
        guard !isMuted else { return }
        collectSound?.currentTime = 0
        collectSound?.volume = sfxVolume
        collectSound?.play()
    }
    
    func playWin() {
        guard !isMuted else { return }
        winSound?.currentTime = 0
        winSound?.volume = sfxVolume
        winSound?.play()
    }
    
    func playWrong() {
        guard !isMuted else { return }
        wrongSound?.currentTime = 0
        wrongSound?.volume = sfxVolume
        wrongSound?.play()
    }
}



struct FashionSewingView: View {
    @State private var showLevels = false
    @State private var animateLogo = false
    
    var body: some View {
        ZStack {
            Color.fashionBrandCream.ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // LOGO
                VStack(spacing: 10) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                    Text("FASHION AND SEWING")
                        .font(.system(size: 25, weight: .black, design: .rounded))
                        .foregroundColor(.black)
                    
    
                    Text("The Creative Atelier")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 6)

                }
                .scaleEffect(animateLogo ? 1 : 0.5)
                .opacity(animateLogo ? 1 : 0)
                
                Spacer()
                
                // BUTANG START
                Button(action: {
                    withAnimation(.spring()) { showLevels = true }
                }) {
                    Text("START")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.fashionBrandOrange)
                                .shadow(color: .fashionBrandOrange.opacity(0.4), radius: 10, y: 5)
                        )
                }
                .padding(.horizontal, 40)
                .offset(y: -150)
                
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                animateLogo = true
            }
        }
        .fullScreenCover(isPresented: $showLevels) {
            FashionLevelSelectView()
        }
    }
}




struct FashionLevelSelectView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedLevel: FashionGameLevel?
    @State private var navigateToQuiz = false
    @StateObject private var audioManager = FashionAudioManager.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.fashionBrandCream.ignoresSafeArea()
                
                VStack(spacing: 30) {
                    HStack {
                        
                        // Left: Back Button
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2.bold())
                                .foregroundColor(.fashionBrandOrange)
                                .padding(10)
                                .background(Circle().fill(Color.white))
                        }
                        
                        Spacer()
                        // Center: Title
                        Text("CHOOSE LEVEL")
                            .font(.system(size: 22, weight: .black, design: .rounded))
                            .foregroundColor(.fashionBrandOrange)
                        Spacer()
                        
                        // Right: Mute Button
                        Button(action: {
                            audioManager.toggleMute()
                        }) {
                            Image(systemName: audioManager.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                .font(.title2)
                                .foregroundColor(.fashionBrandOrange)
                                .padding(10)
                                .background(Circle().fill(Color.white))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Text("Choose Your Level To Start! 🎮")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.black.opacity(0.6))
                    
                    VStack(spacing: 20) {
                        FashionLevelCard(level: .easy) {
                            selectedLevel = .easy
                            navigateToQuiz = true
                        }
                        
                        FashionLevelCard(level: .medium) {
                            selectedLevel = .medium
                            navigateToQuiz = true
                        }
                        
                        FashionLevelCard(level: .hard) {
                            selectedLevel = .hard
                            navigateToQuiz = true
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $navigateToQuiz) {
                if let level = selectedLevel {
                    FashionQuizView(level: level)
                }
            }
            
        }
    }
}

struct FashionLevelCard: View {
    let level: FashionGameLevel
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(level.title)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    HStack(spacing: 15) {
                        Label("\(level.gridSize)×\(level.gridSize)", systemImage: "square.grid.3x3")
                        Label("\(level.questionsCount) question", systemImage: "questionmark.circle")
                        Label("\(level.timePerQuestion)s", systemImage: "clock")
                    }
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.title2.bold())
                    .foregroundColor(.white)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [level.levelColor, level.levelColor.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: level.levelColor.opacity(0.3), radius: 8, y: 4)
            )
        }
    }
}




struct FashionQuizView: View {
    let level: FashionGameLevel
    @Environment(\.dismiss) var dismiss
    @State private var startGame = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.fashionBrandCream.ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.title3.bold())
                                .foregroundColor(.fashionBrandOrange)
                                .padding(10)
                                .background(Circle().fill(Color.white))
                        }
                        Spacer()
                        Text("INSTRUCTIONS")
                            .font(.system(size: 25, weight: .black, design: .rounded))
                            .foregroundColor(.fashionBrandOrange)
                        Spacer()
                        Color.clear.frame(width: 44, height: 44)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Icon besar
                    VStack(spacing: 15) {
                        Text("")
                            .font(.system(size: 80))
                        
                        Text("How To Play")
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .foregroundColor(.fashionBrandOrange)
                    }
                    .padding(.top, 20)
                    
                    // Arahan
                    VStack(alignment: .leading, spacing: 15) {
                        FashionInstructionRow(number: "1", text: "Read the question above the grid")
                        FashionInstructionRow(number: "2", text: "Find & click the correct tool")
                        FashionInstructionRow(number: "3", text: "Collect all the tools on the grid")
                        FashionInstructionRow(number: "4", text: "Done!")
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.08), radius: 6)
                    )
                    .padding(.horizontal)
                    
                    // Contoh
                    VStack(spacing: 10) {
                        Text("EXAMPLE")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text(" Question : Tool to hold fabric")
                            .font(.system(size: 15))
                        Text(" Answer : Pin")
                            .font(.system(size: 15))
                        

                        .font(.system(size: 15))
                        
                        Text("→ Click all pins in the grid!")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black.opacity(0.6))
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.fashionBrandOrange.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.fashionBrandOrange, lineWidth: 2)
                            )
                    )
                    .padding(.horizontal)
                    

                    
                    // Butang Mula
                    Button(action: { startGame = true }) {
                        Text("START PLAYING 🎮")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.fashionBrandOrange)
                                    .shadow(color: .fashionBrandOrange.opacity(0.4), radius: 10, y: 5)
                            )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationDestination(isPresented: $startGame) {
                FashionGameView(level: level)
            }
        }
    }
}

struct FashionInstructionRow: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Text(number)
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(Circle().fill(Color.fashionBrandOrange))
            
            Text(text)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.black.opacity(0.8))
            
            Spacer()
        }
    }
}




struct FashionGameView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: FashionGameViewModel
    
    init(level: FashionGameLevel) {
        _vm = StateObject(wrappedValue: FashionGameViewModel(level: level))
    }
    
    var body: some View {
        ZStack {
            Color.fashionBrandCream.ignoresSafeArea()
            
            VStack(spacing: 10) {
                headerView
                questionCard
                statsView
                collectAnimation
                gridView
                instructionText
                Spacer()
            }
            .padding(.top, 10)
            .overlay(newQuestionOverlay)
        }
        .fullScreenCover(isPresented: .constant(vm.gameOver)) {
            endGameView
        }
    }
    
    // MARK: - Extracted Sub-Views
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.title3.bold())
                    .foregroundColor(vm.level.levelColor)
                    .padding(10)
                    .background(Circle().fill(Color.white))
            }
            Spacer()
            Text(vm.level.title)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(vm.level.levelColor)
            Spacer()
            Button(action: { vm.restart() }) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.title3.bold())
                    .foregroundColor(vm.level.levelColor)
                    .padding(10)
                    .background(Circle().fill(Color.white))
            }
        }
        .padding(.horizontal)
    }
    
    private var questionCard: some View {
        VStack(spacing: 10) {
            questionHeader
            if let currentQuestion = getCurrentQuestion() {
                questionContent(question: currentQuestion)
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [vm.level.levelColor, vm.level.levelColor.opacity(0.85)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .shadow(color: vm.level.levelColor.opacity(0.3), radius: 6, y: 3)
        .padding(.horizontal)
    }
    
    private var questionHeader: some View {
        HStack {
            Text("Question \(vm.currentQuestionIndex + 1)/\(vm.questions.count)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white.opacity(0.9))
            Spacer()
            Text("⏰ \(vm.timeRemaining)s")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white.opacity(0.9))
        }
    }
    
    private func questionContent(question: FashionQuizQuestion) -> some View {
        VStack(spacing: 8) {
            Text(question.question)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            collectProgressView(question: question)
        }
        .padding(.horizontal, 12)
    }
    
    private func collectProgressView(question: FashionQuizQuestion) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 10) {
                Text("Collect:")
                    .font(.system(size: 13, weight: .semibold))
                Image(question.answer.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .font(.system(size: 22))
                Text(question.answer.name)
                    .font(.system(size: 14, weight: .bold))
                Spacer()
                Text("\(vm.collected)/\(question.targetCollect)")
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .foregroundColor(vm.collected >= question.targetCollect ? .green : .white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.white.opacity(0.3)))
            }
            .foregroundColor(.white)
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white.opacity(0.3))
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white)
                        .frame(width: geo.size.width * CGFloat(min(vm.collected, question.targetCollect)) / CGFloat(question.targetCollect))
                }
            }
            .frame(height: 10)
        }
    }
    
    private var statsView: some View {
        VStack(spacing: 8) {
            scoreAndTimeStats
            questionProgressStat
        }
        .padding(.horizontal)
    }
    
    private var scoreAndTimeStats: some View {
        HStack(spacing: 10) {
            statBox(title: "SCORE", value: "\(vm.score)/\(vm.level.targetScore)", icon: "star.fill", color: .orange)
            statBox(title: "TIME", value: "\(vm.timeRemaining)s", icon: "clock.fill", color: vm.level.levelColor)
        }
    }
    
    private func statBox(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon).font(.system(size: 12, weight: .bold))
                Text(title).font(.system(size: 11, weight: .bold))
                Spacer()
                Text(value).font(.system(size: 11, weight: .semibold))
            }
            .foregroundColor(.white.opacity(0.9))
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4).fill(Color.white.opacity(0.3))
                    RoundedRectangle(cornerRadius: 4).fill(Color.white)
                        .frame(width: geo.size.width * getProgressWidth(title: title))
                }
            }
            .frame(height: 8)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 12).fill(color))
        .frame(maxWidth: .infinity)
    }

    private func getProgressWidth(title: String) -> CGFloat {
        switch title {
        case "SCORE":
            return CGFloat(min(vm.score, vm.level.targetScore)) / CGFloat(max(vm.level.targetScore, 1))
        case "TIME":
            return CGFloat(vm.timeRemaining) / CGFloat(vm.level.timePerQuestion)
        default:
            return 0.7
        }
    }
    
    private var questionProgressStat: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill").font(.system(size: 12, weight: .bold))
            Text("QUESTION").font(.system(size: 11, weight: .bold))
            Spacer()
            Text("\(vm.currentQuestionIndex + 1)/\(vm.questions.count)").font(.system(size: 11, weight: .semibold))
        }
        .foregroundColor(.white.opacity(0.9))
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.purple))
        .frame(maxWidth: .infinity)
    }
    
    private var collectAnimation: some View {
        Group {
            if vm.showCollectAnimation, let currentQuestion = getCurrentQuestion() {
                HStack(spacing: 10) {
                    Text("✅ +\(vm.collectCount)").font(.system(size: 16, weight: .bold, design: .rounded))
                    Image(currentQuestion.answer.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    Text(currentQuestion.answer.name).font(.system(size: 14, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Capsule().fill(Color.green))
                .shadow(color: .green.opacity(0.3), radius: 4, y: 2)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    private var gridView: some View {
        GeometryReader { geo in
            let size = vm.level.gridSize
            let spacing: CGFloat = 4
            let cellSize = (min(geo.size.width, geo.size.height) - (spacing * CGFloat(size - 1)) - 16) / CGFloat(size)
            
            VStack(spacing: spacing) {
                ForEach(0..<size, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<size, id: \.self) { col in
                            gridCell(row: row, col: col, size: cellSize)
                        }
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.width)
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(color: .black.opacity(0.1), radius: 8))
        .padding(.horizontal, 10)
    }
    
    private func gridCell(row: Int, col: Int, size: CGFloat) -> some View {
        Group {
            if let tool = vm.grid[row][col] {
                FashionTileView(
                    tool: tool,
                    isSelected: vm.selectedPosition == FashionGridPosition(row: row, col: col),
                    isMatched: vm.matchedPositions.contains(FashionGridPosition(row: row, col: col)),
                    size: size
                )
                .onTapGesture {
                    vm.tap(row: row, col: col)
                }
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.clear)
                    .frame(width: size, height: size)
            }
        }
    }
    
    private var instructionText: some View {
        Text("Tap 2 items next to each other to swap")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.black.opacity(0.5))
    }
    
    private var newQuestionOverlay: some View {
        Group {
            if vm.showNewQuestionNotice, let currentQuestion = getCurrentQuestion() {
                ZStack {
                    Color.black.opacity(0.7).ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Text("📝").font(.system(size: 60))
                        Text("QUESTION!").font(.system(size: 28, weight: .black, design: .rounded)).foregroundColor(.white)
                        Text(vm.newQuestionText)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        newQuestionContent(question: currentQuestion)
                    }
                    .padding(30)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    colors: [vm.level.levelColor, vm.level.levelColor.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .black.opacity(0.3), radius: 10)
                    )
                    .padding(.horizontal, 30)
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
    
    private func newQuestionContent(question: FashionQuizQuestion) -> some View {
        VStack(spacing: 8) {
            Text("Collect:").font(.system(size: 14, weight: .bold)).foregroundColor(.white)
            HStack(spacing: 10) {
                Image(question.answer.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text(question.answer.name).font(.system(size: 18, weight: .bold)).foregroundColor(.white)
            }
            Text("Target: \(question.targetCollect) items")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(15)
        .background(
            Rectangle()
                .fill(Color.white.opacity(0.2))
        )
    }
    
    private var endGameView: some View {
        FashionEndGameView(
            won: vm.gameWon,
            score: vm.score,
            targetScore: vm.level.targetScore,
            collectionHistory: vm.collectionHistory,
            onRestart: { vm.restart() },
            onQuit: { dismiss() }
        )
    }
    
    private func getCurrentQuestion() -> FashionQuizQuestion? {
        guard vm.currentQuestionIndex < vm.questions.count else { return nil }
        return vm.questions[vm.currentQuestionIndex]
    }
}

// MARK: - FashionTileView
struct FashionTileView: View {
    let tool: FashionSewingTool
    let isSelected: Bool
    let isMatched: Bool
    let size: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.fashionBrandCream)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.fashionBrandOrange : Color.gray.opacity(0.3), lineWidth: isSelected ? 3 : 1)
                )
                .shadow(color: .black.opacity(0.1), radius: isSelected ? 4 : 1)
            
            Image(tool.imageName)
                .resizable()
                .scaledToFit()
                .padding(size * 0.1)
        }
        .frame(width: size, height: size)
        .scaleEffect(isMatched ? 0.1 : (isSelected ? 1.1 : 1.0))
        .opacity(isMatched ? 0 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        .animation(.easeInOut(duration: 0.3), value: isMatched)
    }
}

// MARK: - FashionEndGameView
struct FashionEndGameView: View {
    let won: Bool
    let score: Int
    let targetScore: Int
    let collectionHistory: [(question: String, collected: Int, target: Int)]
    let onRestart: () -> Void
    let onQuit: () -> Void
    
    var totalCollected: Int {
        collectionHistory.reduce(0) { $0 + $1.collected }
    }
    
    var body: some View {
        ZStack {
            Color.fashionBrandCream.ignoresSafeArea()
            
            ScrollView {  //  WRAP DALAM SCROLLVIEW
                VStack(spacing: 20) {
                    Spacer().frame(height: 20)
                    
                    Text(won ? "🏆" : "⏰")
                        .font(.system(size: 80))
                    
                    Text(won ? "CONGRATULATIONS!" : "TIME'S UP!")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(won ? .green : .red)
                    
                    Text(won ? "All Questions Are Finished" : "Try Again!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black.opacity(0.7))
                    
                    // Score Card
                    VStack(spacing: 12) {
                        Text("Items Collected")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black.opacity(0.5))
                        
                        Text("\(totalCollected) / \(targetScore/10)")
                            .font(.system(size: 48, weight: .black, design: .rounded))
                            .foregroundColor(.orange)
                        
                        Text("Score: \(score) score")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.green)
                        
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.orange.opacity(0.2))
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(score >= targetScore ? Color.green : Color.orange)
                                    .frame(width: geo.size.width * CGFloat(min(score, targetScore)) / CGFloat(max(targetScore, 1)))
                            }
                        }
                        .frame(height: 12)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.08), radius: 6)
                    )
                    .padding(.horizontal, 20)
                    
                    // Markah semua soalan
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "chart.pie.fill")
                                .foregroundColor(.blue)
                            Text("MY COLLECTION")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black.opacity(0.7))
                            Spacer()
                        }
                        
                        if collectionHistory.isEmpty {
                            // Kalau tiada collection
                            Text("No Collection Data")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black.opacity(0.5))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                        } else {
                            // Show kalau ada data
                            VStack(spacing: 8) {
                                ForEach(Array(collectionHistory.enumerated()), id: \.offset) { index, item in
                                    HStack(spacing: 10) {
                                        Text("\(index + 1).")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.black.opacity(0.5))
                                            .frame(width: 30, alignment: .leading)
                                        
                                        Text(item.question)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(.black.opacity(0.8))
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\(item.collected)/\(item.target)")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(item.collected >= item.target ? .green : .orange)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(
                                                Capsule()
                                                    .fill(item.collected >= item.target ? Color.green.opacity(0.15) : Color.orange.opacity(0.15))
                                            )
                                    }
                                    .padding(10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white.opacity(0.7))
                                    )
                                }
                            }
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.08), radius: 6)
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer().frame(height: 20)
                    
                    // Buttons
                    VStack(spacing: 12) {
                        Button(action: onRestart) {
                            Text("RESTART")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        colors: [Color.fashionBrandOrange, Color.fashionBrandOrange.opacity(0.8)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .shadow(color: .fashionBrandOrange.opacity(0.3), radius: 6, y: 3)
                        }
                        
                        Button(action: onQuit) {
                            Text("QUIT")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.fashionBrandOrange)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(Color.fashionBrandOrange, lineWidth: 2)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}




@MainActor
class FashionGameViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var grid: [[FashionSewingTool?]] = []
    @Published var score: Int = 0
    @Published var timeRemaining: Int = 0
    @Published var currentQuestionIndex: Int = 0
    @Published var questions: [FashionQuizQuestion] = []
    @Published var collected: Int = 0
    @Published var selectedPosition: FashionGridPosition?
    @Published var matchedPositions: Set<FashionGridPosition> = []
    @Published var isProcessing: Bool = false
    @Published var gameOver: Bool = false
    @Published var gameWon: Bool = false
    @Published var combo: Int = 0
    @Published var showCollectAnimation: Bool = false
    @Published var collectCount: Int = 0
    @Published var showNewQuestionNotice: Bool = false
    @Published var newQuestionText: String = ""
    
    @Published var collectionHistory: [(question: String, collected: Int, target: Int)] = []
    
    let level: FashionGameLevel
    private var questionTimer: Timer?
    
    // MARK: - Init
    init(level: FashionGameLevel) {
        self.level = level
        setupGame()
    }
    
    // MARK: - Setup
    func setupGame() {
        score = 0
        currentQuestionIndex = 0
        collected = 0
        gameOver = false
        gameWon = false
        selectedPosition = nil
        matchedPositions = []
        combo = 0
        collectionHistory.removeAll()
        
        questions = level.questionsForLevel.shuffled()
        
        startQuestionTimer()
        loadCurrentQuestion()
    }
    
    // MARK: - Grid Generation
     func generateGrid() {
        let size = level.gridSize
        let totalCells = size * size
        
        guard currentQuestionIndex < questions.count else { return }
        let targetAnswer = questions[currentQuestionIndex].answer
        let levelTools = level.toolsInLevel
        
        //Pilih subset tools
        let otherTools = levelTools.filter { $0 != targetAnswer }
        let selectedOthers = otherTools.shuffled().prefix(5)  // 5 tools lain
        let activeTools = [targetAnswer] + selectedOthers  // Total 6 tools
        
        print("🎯 Question \(currentQuestionIndex + 1): \(targetAnswer.name)")
        print("🎮 Active tools: \(activeTools.map { $0.name }.joined(separator: ", "))")
        
        var allTools: [FashionSewingTool] = []
        
        // 25% dari grid
        let targetCount = Int(Double(totalCells) * 0.25)
        for _ in 0..<targetCount {
            allTools.append(targetAnswer)
        }
        
        // Seimbangkan tools lain
        let remainingCells = totalCells - targetCount
        let perTool = remainingCells / activeTools.count  // 6 tools share baki
        let extra = remainingCells % activeTools.count
        
        for (index, tool) in activeTools.enumerated() {
            if tool == targetAnswer { continue }  // Target dah ditambah atas
            let count = perTool + (index < extra ? 1 : 0)
            for _ in 0..<count {
                allTools.append(tool)
            }
        }
        
        // Pastikan cukup
        while allTools.count < totalCells {
            allTools.append(activeTools.randomElement()!)
        }
        if allTools.count > totalCells {
            allTools = Array(allTools.prefix(totalCells))
        }
        
        allTools.shuffle()
        
        // Fill grid
        var newGrid: [[FashionSewingTool?]] = []
        var idx = 0
        for _ in 0..<size {
            var row: [FashionSewingTool?] = []
            for _ in 0..<size {
                if idx < allTools.count {
                    row.append(allTools[idx])
                    idx += 1
                }
            }
            newGrid.append(row)
        }
        grid = newGrid
        
        // Sure ada 1 match
        if findMatches().isEmpty {
            print("⚠️ No initial matches, regenerating...")
            generateGrid()
        }
    }
    
    // MARK: - Question Management
    func loadCurrentQuestion() {
        guard currentQuestionIndex < questions.count else {
            endGame(won: true)
            return
        }
        collected = 0
        timeRemaining = level.timePerQuestion
        
        generateGrid()
        
        let question = questions[currentQuestionIndex]
        newQuestionText = "Question \(currentQuestionIndex + 1): \(question.question)"
        
        withAnimation(.spring()) {
            showNewQuestionNotice = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            withAnimation {
                self?.showNewQuestionNotice = false
            }
        }
    }
    
    func startQuestionTimer() {
        questionTimer?.invalidate()
        questionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.tick()
            }
        }
    }
    
    func tick() {
        guard !gameOver else {
            questionTimer?.invalidate()
            return
        }
        
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            Task { @MainActor in
                self.nextQuestion()
            }
        }
    }
    
    func nextQuestion() {
        // Save current question history
        if currentQuestionIndex < questions.count {
            let currentQ = questions[currentQuestionIndex]
            collectionHistory.append((
                question: currentQ.question,
                collected: collected,
                target: currentQ.targetCollect
            ))
        }
        
        currentQuestionIndex += 1
        
        if currentQuestionIndex >= questions.count {
            endGame(won: true)
            FashionAudioManager.shared.playWin()
        } else {
            collected = 0
            loadCurrentQuestion()
        }
    }
    
    // MARK: - Tap & Swap
    func tap(row: Int, col: Int) {
        guard !gameOver, !isProcessing else { return }
        guard grid[row][col] != nil else { return }
        
        let position = FashionGridPosition(row: row, col: col)
        
        if let selected = selectedPosition {
            if selected == position {
                withAnimation { self.selectedPosition = nil }
                return
            }
            
            if isAdjacent(selected, position) {
                //swap kanan kiri atas bawah
                FashionAudioManager.shared.playSwap()
                
                withAnimation { self.selectedPosition = nil }
                Task { await trySwap(from: selected, to: position) }
            } else {
                withAnimation { self.selectedPosition = position }
            }
        } else {
            withAnimation { self.selectedPosition = position }
        }
    }
    
    func isAdjacent(_ a: FashionGridPosition, _ b: FashionGridPosition) -> Bool {
        let dr = abs(a.row - b.row)
        let dc = abs(a.col - b.col)
        return (dr == 1 && dc == 0) || (dr == 0 && dc == 1)
    }
    
    func trySwap(from a: FashionGridPosition, to b: FashionGridPosition) async {
        isProcessing = true
        
        swap(a, b)
        try? await Task.sleep(nanoseconds: 250_000_000)
        
        let matches = findMatches()
        if matches.isEmpty {
            FashionAudioManager.shared.playWrong()
            swap(a, b)
            try? await Task.sleep(nanoseconds: 250_000_000)
            isProcessing = false
            return
        }
        
        await processMatches(matches)
        isProcessing = false
    }
    
    func swap(_ a: FashionGridPosition, _ b: FashionGridPosition) {
        let temp = grid[a.row][a.col]
        grid[a.row][a.col] = grid[b.row][b.col]
        grid[b.row][b.col] = temp
    }
    
    // MARK: - Match Finding
    func findMatches() -> Set<FashionGridPosition> {
        var matches: Set<FashionGridPosition> = []
        let size = level.gridSize
        
        for row in 0..<size {
            var count = 1
            for col in 1..<size {
                if grid[row][col] == grid[row][col-1], grid[row][col] != nil {
                    count += 1
                } else {
                    if count >= 3 {
                        for k in (col-count)..<col {
                            matches.insert(FashionGridPosition(row: row, col: k))
                        }
                    }
                    count = 1
                }
            }
            if count >= 3 {
                for k in (size-count)..<size {
                    matches.insert(FashionGridPosition(row: row, col: k))
                }
            }
        }
        
        for col in 0..<size {
            var count = 1
            for row in 1..<size {
                if grid[row][col] == grid[row-1][col], grid[row][col] != nil {
                    count += 1
                } else {
                    if count >= 3 {
                        for k in (row-count)..<row {
                            matches.insert(FashionGridPosition(row: k, col: col))
                        }
                    }
                    count = 1
                }
            }
            if count >= 3 {
                for k in (size-count)..<size {
                    matches.insert(FashionGridPosition(row: k, col: col))
                }
            }
        }
        
        return matches
    }
    
    // MARK: - Process Matches
    func processMatches(_ matches: Set<FashionGridPosition>) async {
        guard !gameOver, currentQuestionIndex < questions.count else { return }
        
        combo += 1
        
        let currentAnswer = questions[currentQuestionIndex].answer
        var targetMatchCount = 0
        
        for pos in matches {
            if let tool = grid[pos.row][pos.col], tool == currentAnswer {
                targetMatchCount += 1
            }
        }
        
        score += targetMatchCount * 10
        
        if targetMatchCount > 0 {
            FashionAudioManager.shared.playCollect()
            withAnimation(.spring()) {
                collected += targetMatchCount
                showCollectAnimation = true
                collectCount = targetMatchCount
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                withAnimation {
                    self?.showCollectAnimation = false
                }
            }
            
            if collected >= questions[currentQuestionIndex].targetCollect {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                nextQuestion()
                return
            }
        }
        
        withAnimation { matchedPositions = matches }
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        for pos in matches {
            grid[pos.row][pos.col] = nil
        }
        
        withAnimation { matchedPositions = [] }
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        applyGravity()
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        guard !gameOver, currentQuestionIndex < questions.count else { return }
        
        let newMatches = findMatches()
        if !newMatches.isEmpty {
            await processMatches(newMatches)
        } else {
            combo = 0
        }
    }
    
    // MARK: - Gravity
    func applyGravity() {
        let size = level.gridSize
        
        guard currentQuestionIndex < questions.count else { return }
        let targetAnswer = questions[currentQuestionIndex].answer
        let levelTools = level.toolsInLevel
        
        // Guna subset sama
        let otherTools = levelTools.filter { $0 != targetAnswer }
        let selectedOthers = otherTools.shuffled().prefix(5)
        let activeTools = [targetAnswer] + selectedOthers
        
        for col in 0..<size {
            var writeRow = size - 1
            for row in stride(from: size - 1, through: 0, by: -1) {
                if grid[row][col] != nil {
                    grid[writeRow][col] = grid[row][col]
                    if writeRow != row {
                        grid[row][col] = nil
                    }
                    writeRow -= 1
                }
            }
            
            if writeRow >= 0 {
                for row in 0...writeRow {
                    // 25% chance item lain jatuh
                    if Double.random(in: 0...1) < 0.25 {
                        grid[row][col] = targetAnswer
                    } else {
                        // 75% random dari active tools
                        grid[row][col] = activeTools.randomElement()
                    }
                }
            }
        }
    }
    
    // MARK: - Game End
    func endGame(won: Bool) {
        guard !gameOver else { return }
        gameOver = true
        gameWon = won
        questionTimer?.invalidate()
    }
    
    func restart() {
        questionTimer?.invalidate()
        collectionHistory.removeAll()
        setupGame()
    }
}
