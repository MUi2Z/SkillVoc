import SwiftUI

// MARK: - Module Model
// Letak dalam folder: Models/Module.swift (atau simpan dalam file ni dulu)

struct Module: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let iconBgColor: Color
    let iconColor: Color
    let moduleCount: Int
    let simulationCount: Int
    let xpReward: Int
    let progress: Double
    let progressColor: Color
    let department: String
}

// MARK: - Dummy Data
let sampleModules: [Module] = [
    Module(title: "Automotive Technology",
           icon: "wrench.and.screwdriver.fill",
           iconBgColor: Color(hex: "#FFF0E6"), iconColor: Color(hex: "#E8472A"),
           moduleCount: 8, simulationCount: 4, xpReward: 500,
           progress: 0.65, progressColor: Color(hex: "#E8472A"),
           department: "Mechanical"),

    Module(title: "Programming Software",
           icon: "laptopcomputer",
           iconBgColor: Color(hex: "#E8F5E9"), iconColor: Color(hex: "#34C759"),
           moduleCount: 10, simulationCount: 5, xpReward: 600,
           progress: 0.80, progressColor: Color(hex: "#34C759"),
           department: "ICT"),

    Module(title: "Network Systems",
           icon: "network",
           iconBgColor: Color(hex: "#E3F0FF"), iconColor: Color(hex: "#2196F3"),
           moduleCount: 6, simulationCount: 3, xpReward: 400,
           progress: 0.30, progressColor: Color(hex: "#2196F3"),
           department: "ICT"),

    Module(title: "Culinary Arts",
           icon: "fork.knife",
           iconBgColor: Color(hex: "#FCE4EC"), iconColor: Color(hex: "#E91E63"),
           moduleCount: 7, simulationCount: 4, xpReward: 450,
           progress: 0.50, progressColor: Color(hex: "#E91E63"),
           department: "Hospitality"),

    Module(title: "Electrical Systems",
           icon: "bolt.fill",
           iconBgColor: Color(hex: "#FFFDE7"), iconColor: Color(hex: "#FFC107"),
           moduleCount: 9, simulationCount: 3, xpReward: 550,
           progress: 0.20, progressColor: Color(hex: "#FFC107"),
           department: "Mechanical"),

    Module(title: "Graphic Design",
           icon: "paintbrush.fill",
           iconBgColor: Color(hex: "#F3E5F5"), iconColor: Color(hex: "#9C27B0"),
           moduleCount: 5, simulationCount: 2, xpReward: 350,
           progress: 0.90, progressColor: Color(hex: "#9C27B0"),
           department: "Creative"),
]

// MARK: - Modules View
// Letak dalam folder: Views/UserFlow/Modules/ModulesView.swift

struct ModulesView: View {

    @State private var searchText = ""
    @State private var selectedDept = "All"

    let departments = ["All", "Mechanical", "ICT", "Hospitality", "Creative"]

    var filtered: [Module] {
        let byDept = selectedDept == "All"
            ? sampleModules
            : sampleModules.filter { $0.department == selectedDept }
        if searchText.isEmpty { return byDept }
        return byDept.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F5F0EB").ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {

                        // ── Search Bar ─────────────────────────────
                        HStack(spacing: 10) {
                            HStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Color(hex: "#6C6C70"))
                                    .font(.system(size: 15))
                                TextField("Search courses...", text: $searchText)
                                    .font(.system(size: 15))
                                    .foregroundColor(Color(hex: "#1C1C1E"))
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .cornerRadius(14)

                            Button(action: {}) {
                                Image(systemName: "slider.horizontal.3")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color(hex: "#6C6C70"))
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(14)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 16)

                        // ── Filter Chips ───────────────────────────
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(departments, id: \.self) { dept in
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedDept = dept
                                        }
                                    }) {
                                        Text(dept)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(selectedDept == dept ? .white : Color(hex: "#3C3C43"))
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .background(
                                                selectedDept == dept
                                                    ? Color(hex: "#E8472A")
                                                    : Color.white
                                            )
                                            .cornerRadius(20)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 20)

                        // ── Module List ────────────────────────────
                        VStack(spacing: 14) {
                            ForEach(filtered) { module in
                                NavigationLink(destination: ModuleDetailView(module: module)) {
                                    ModuleCardView(module: module)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Courses")
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

// MARK: - Module Card
struct ModuleCardView: View {
    let module: Module

    var body: some View {
        HStack(spacing: 14) {

            // Icon box
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(module.iconBgColor)
                    .frame(width: 62, height: 62)
                Image(systemName: module.icon)
                    .font(.system(size: 24))
                    .foregroundColor(module.iconColor)
            }

            // Info
            VStack(alignment: .leading, spacing: 5) {
                Text(module.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: "#1C1C1E"))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)

                Text("\(module.moduleCount) modules · \(module.simulationCount) simulations")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#6C6C70"))

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "#E0DDD8"))
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(module.progressColor)
                            .frame(width: geo.size.width * module.progress, height: 6)
                    }
                }
                .frame(height: 6)
                .padding(.top, 2)
            }

            Spacer(minLength: 0)

            // XP
            Text("+\(module.xpReward) XP")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(module.progressColor)
                .fixedSize()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
    }
}

// MARK: - Module Detail View
struct ModuleDetailView: View {
    let module: Module
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color(hex: "#F5F0EB").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // Hero banner
                    ZStack {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(module.iconBgColor)
                            .frame(height: 200)
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.6))
                                    .frame(width: 90, height: 90)
                                Image(systemName: module.icon)
                                    .font(.system(size: 44))
                                    .foregroundColor(module.iconColor)
                            }
                            Text(module.title)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                                .multilineTextAlignment(.center)
                        }
                    }

                    VStack(spacing: 16) {

                        // Stats row
                        HStack(spacing: 10) {
                            ModuleStatBox(value: "\(module.moduleCount)", label: "Modules", icon: "book.fill", color: module.iconColor)
                            ModuleStatBox(value: "\(module.simulationCount)", label: "Simulations", icon: "gamecontroller.fill", color: module.iconColor)
                            ModuleStatBox(value: "+\(module.xpReward)", label: "XP Reward", icon: "star.fill", color: Color(hex: "#F5A623"))
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        // Progress card
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Your Progress")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "#1C1C1E"))
                                Spacer()
                                Text("\(Int(module.progress * 100))%")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(module.progressColor)
                            }
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(hex: "#E0DDD8"))
                                        .frame(height: 10)
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(module.progressColor)
                                        .frame(width: geo.size.width * module.progress, height: 10)
                                }
                            }
                            .frame(height: 10)
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)

                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About This Course")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                            Text("Master the fundamentals and advanced techniques in \(module.title). This course includes hands-on simulations and real-world applications to prepare you for a TVET career.")
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "#6C6C70"))
                                .lineSpacing(4)
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)

                        // CTA Button
                        Button(action: {}) {
                            Text("Continue Learning")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(hex: "#E8472A"))
                                .cornerRadius(16)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(module.title)
    }
}

private struct ModuleStatBox: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon).font(.system(size: 16)).foregroundColor(color)
            Text(value).font(.system(size: 15, weight: .bold)).foregroundColor(Color(hex: "#1C1C1E"))
            Text(label).font(.system(size: 10)).foregroundColor(Color(hex: "#6C6C70"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(14)
    }
}

#Preview { ModulesView() }
