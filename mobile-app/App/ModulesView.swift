import SwiftUI

struct Module: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let iconBgColor: Color
    let iconColor: Color
    let duration: String
    let department: String
}

let sampleModules: [Module] = [

    Module(title: "Introduction to Automotive",
           description: "Fundamentals of automotive technology, vehicle systems and basic maintenance.",
           icon: "wrench.and.screwdriver.fill",
           iconBgColor: Color(hex: "#FFF0E6"), iconColor: Color(hex: "#E8472A"),
           duration: "25 min", department: "Engineering"),
    Module(title: "F1 Pit Stop Techniques",
           description: "Formula 1 pit stop procedures — speed, precision and tyre changing.",
           icon: "flag.checkered",
           iconBgColor: Color(hex: "#FFF0E6"), iconColor: Color(hex: "#E8472A"),
           duration: "30 min", department: "Engineering"),
    Module(title: "Basic Electrical Concepts",
           description: "Electrical fundamentals — voltage, current, resistance and Ohm's Law in circuits.",
           icon: "bolt.fill",
           iconBgColor: Color(hex: "#FFFDE7"), iconColor: Color(hex: "#FFC107"),
           duration: "25 min", department: "Engineering"),
    Module(title: "Circuit Design & Analysis",
           description: "Design and analyse series, parallel and combination circuits.",
           icon: "alternatingcurrent",
           iconBgColor: Color(hex: "#FFFDE7"), iconColor: Color(hex: "#FFC107"),
           duration: "35 min", department: "Engineering"),

    Module(title: "Computer Networking Fundamentals",
           description: "Introduction to computer networks, topologies, protocols and core functions.",
           icon: "network",
           iconBgColor: Color(hex: "#E3F0FF"), iconColor: Color(hex: "#2196F3"),
           duration: "20 min", department: "IT"),
    Module(title: "Network Routing & Switching",
           description: "Routing and switching concepts, and data path configuration in networks.",
           icon: "arrow.triangle.swap",
           iconBgColor: Color(hex: "#E3F0FF"), iconColor: Color(hex: "#2196F3"),
           duration: "35 min", department: "IT"),
    Module(title: "LAN & WAN Configuration",
           description: "Configuration of Local Area Networks (LAN) and Wide Area Networks (WAN).",
           icon: "wifi",
           iconBgColor: Color(hex: "#E3F0FF"), iconColor: Color(hex: "#2196F3"),
           duration: "40 min", department: "IT"),
    Module(title: "Network Security Basics",
           description: "Common network threats, firewalls and best practices to secure a network.",
           icon: "lock.shield.fill",
           iconBgColor: Color(hex: "#E3F0FF"), iconColor: Color(hex: "#2196F3"),
           duration: "30 min", department: "IT"),

    Module(title: "Kitchen Safety & Hygiene",
           description: "Safe handling of kitchen equipment, hygiene standards and emergency procedures.",
           icon: "fork.knife",
           iconBgColor: Color(hex: "#FCE4EC"), iconColor: Color(hex: "#E91E63"),
           duration: "20 min", department: "Home Science"),
    Module(title: "Food Preparation Techniques",
           description: "Techniques for measuring, cutting and preparing a variety of food ingredients.",
           icon: "takeoutbag.and.cup.and.straw.fill",
           iconBgColor: Color(hex: "#FCE4EC"), iconColor: Color(hex: "#E91E63"),
           duration: "30 min", department: "Home Science"),
    Module(title: "Culinary Arts & Baking",
           description: "Professional cooking, baking and food decoration techniques.",
           icon: "birthday.cake.fill",
           iconBgColor: Color(hex: "#FCE4EC"), iconColor: Color(hex: "#E91E63"),
           duration: "35 min", department: "Home Science"),
    Module(title: "Sewing & Fabric Care",
           description: "Basic sewing techniques, fabric types and proper garment care.",
           icon: "scissors",
           iconBgColor: Color(hex: "#FCE4EC"), iconColor: Color(hex: "#E91E63"),
           duration: "25 min", department: "Home Science"),
]

let moduleDepartments = ["All", "Engineering", "IT", "Home Science"]

func moduleDeptEmoji(_ dept: String) -> String {
    switch dept {
    case "Engineering": return "🔧"
    case "IT":           return "💻"
    case "Home Science":           return "🍽️"
    default:              return "📚"
    }
}

func statusColor(_ status: ModuleStatus) -> Color {
    switch status {
    case .completed:  return Color(hex: "#34C759")
    case .inProgress: return Color(hex: "#E8472A")
    case .locked:     return Color(hex: "#8E8E93")
    }
}

struct ModulesView: View {

    @Binding var showSidebar: Bool
    @EnvironmentObject var appState: AppState

    @State private var searchText = ""
    @State private var selectedDept = "All"

    var filteredModules: [Module] {
        let byDept = selectedDept == "All"
            ? sampleModules
            : sampleModules.filter { $0.department == selectedDept }
        if searchText.isEmpty { return byDept }
        return byDept.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var groupedModules: [(dept: String, modules: [Module])] {
        let depts = ["Engineering", "IT", "Home Science"]
        return depts.compactMap { dept in
            let mods = filteredModules.filter { $0.department == dept }
            return mods.isEmpty ? nil : (dept, mods)
        }
    }

    var body: some View {
        ZStack {
            Color(hex: "#F5F0EB").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Modules")
                            .font(.system(size: 28, weight: .black))
                            .foregroundColor(Color(hex: "#1C1C1E"))
                        Text("Study the module content before playing the games")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#8E8E93"))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 14)

                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(hex: "#8E8E93"))
                        TextField("Search modules...", text: $searchText)
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
                            ForEach(moduleDepartments, id: \.self) { dept in
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedDept = dept
                                    }
                                }) {
                                    Text(dept)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(selectedDept == dept ? .white : Color(hex: "#3C3C43"))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(selectedDept == dept ? Color(hex: "#E8472A") : Color.white)
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(selectedDept == dept ? Color.clear : Color(hex: "#E0DDD8"), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 22)

                    ForEach(groupedModules, id: \.dept) { group in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Text(moduleDeptEmoji(group.dept))
                                    .font(.system(size: 18))
                                Text(group.dept)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(hex: "#1C1C1E"))
                            }
                            .padding(.horizontal, 20)

                            VStack(spacing: 10) {
                                ForEach(group.modules) { module in
                                    let status = appState.status(for: module.title)
                                    NavigationLink(destination:
                                        ModuleDetailView(module: module)
                                            .environmentObject(appState)
                                    ) {
                                        ModuleRowCard(module: module, status: status)
                                    }
                                    .buttonStyle(.plain)
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                        .padding(.bottom, 28)
                    }

                    Spacer().frame(height: 10)
                }
            }
        }
        .navigationTitle("Modules")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ModuleRowCard: View {
    let module: Module
    let status: ModuleStatus

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(module.iconBgColor)
                    .frame(width: 52, height: 52)
                Image(systemName: module.icon)
                    .font(.system(size: 22))
                    .foregroundColor(module.iconColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(module.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "#1C1C1E"))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(module.description)
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "#8E8E93"))
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "#8E8E93"))
                    Text(module.duration)
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#8E8E93"))
                }
            }

            Spacer()

            Text(status.label)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(status == .locked ? Color(hex: "#8E8E93") : .white)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(status == .locked ? Color(hex: "#F0F0F0") : statusColor(status))
                .cornerRadius(20)
                .fixedSize()
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
    }
}

struct ModuleDetailView: View {
    let module: Module
    @EnvironmentObject var appState: AppState

    var status: ModuleStatus { appState.status(for: module.title) }

    var body: some View {
        ZStack {
            Color(hex: "#F5F0EB").ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    ZStack {
                        module.iconBgColor.frame(height: 190)
                        VStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.65))
                                    .frame(width: 88, height: 88)
                                Image(systemName: module.icon)
                                    .font(.system(size: 40))
                                    .foregroundColor(module.iconColor)
                            }
                            Text(module.title)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                    }

                    VStack(spacing: 14) {

                        HStack(spacing: 10) {
                            DetailStatBox(value: status.label,
                                         label: "Status",
                                         icon: "checkmark.circle",
                                         color: statusColor(status))
                            DetailStatBox(value: module.duration,
                                         label: "Duration",
                                         icon: "clock",
                                         color: module.iconColor)
                            DetailStatBox(value: module.department,
                                         label: "Dept",
                                         icon: "building.2",
                                         color: module.iconColor)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("About This Module")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                            Text(module.description)
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "#6C6C70"))
                                .lineSpacing(4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)

                        Button(action: {
                            if status == .locked {
                                appState.setModuleStatus(.inProgress, for: module.title)
                            } else if status == .inProgress {
                                appState.setModuleStatus(.completed, for: module.title)
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: status == .completed ? "checkmark.circle.fill" : "play.fill")
                                    .font(.system(size: 14))
                                Text(status == .locked ? "Start Module"
                                     : status == .completed ? "Review Module"
                                     : "Continue Module")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(status == .completed ? Color(hex: "#34C759") : Color(hex: "#E8472A"))
                            .cornerRadius(16)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .navigationTitle(module.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct DetailStatBox: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 15)).foregroundColor(color)
            Text(value)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Color(hex: "#1C1C1E"))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label).font(.system(size: 10)).foregroundColor(Color(hex: "#8E8E93"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(14)
    }
}

#Preview { ModulesView(showSidebar: .constant(false)).environmentObject(AppState.shared) }
