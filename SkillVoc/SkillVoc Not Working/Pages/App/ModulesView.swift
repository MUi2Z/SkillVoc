import SwiftUI

struct Department: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let tagline: String
    let about: String
    let icon: String
    let color: Color
    let bgColor: Color
    let highlights: [DepartmentHighlight]
    let careers: [String]
}

struct DepartmentHighlight: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let body: String
}

let sampleDepartments: [Department] = [
    Department(
        name: "Engineering",
        emoji: "🔧",
        tagline: "Build, Fix and Power the World",
        about: "The Engineering course covers automotive and electrical technology. You will learn how vehicles work, how to maintain them, and how electrical circuits are designed and built. This course prepares you for careers in the automotive, manufacturing and electrical industries.",
        icon: "wrench.and.screwdriver.fill",
        color: Color(hex: "#E8472A"),
        bgColor: Color(hex: "#FFF0E6"),
        highlights: [
            DepartmentHighlight(icon: "car.fill", title: "Automotive Technology", body: "Learn how cars work — from engines and fuel systems to electrical components and basic maintenance."),
            DepartmentHighlight(icon: "bolt.fill", title: "Electrical Systems", body: "Understand voltage, current, resistance and how to design and analyse circuits safely."),
            DepartmentHighlight(icon: "flag.checkered", title: "Real-World Skills", body: "Practice high-pressure skills like F1 pit stop techniques that demand speed, precision and teamwork.")
        ],
        careers: ["Automotive Technician", "Electrical Engineer", "Maintenance Mechanic", "Circuit Designer"]
    ),
    Department(
        name: "IT",
        emoji: "💻",
        tagline: "Connect, Secure and Manage Networks",
        about: "The IT course focuses on computer networkin. How devices communicate, how data travels across networks and how to keep those networks safe. You will learn to configure LAN and WAN systems and understand the protocols that power the modern internet.",
        icon: "network",
        color: Color(hex: "#2196F3"),
        bgColor: Color(hex: "#E3F0FF"),
        highlights: [
            DepartmentHighlight(icon: "personalhotspot", title: "Networking Fundamentals", body: "Understand how computers and devices connect and share data using topologies and protocols."),
            DepartmentHighlight(icon: "arrow.triangle.swap", title: "Routing & Switching", body: "Learn how routers and switches direct data along the best path across a network."),
            DepartmentHighlight(icon: "lock.shield.fill", title: "Network Security", body: "Identify common threats and apply firewall rules and security practices to protect a network.")
        ],
        careers: ["Network Administrator", "IT Support Technician", "Cybersecurity Analyst", "System Engineer"]
    ),
    Department(
        name: "Home Science",
        emoji: "🍽️",
        tagline: "Cook, Create and Care",
        about: "The Home Science course covers culinary arts and fashion & sewing. You will learn food preparation, kitchen safety, baking techniques and the basics of sewing and garment care. This course builds practical life skills and prepares you for careers in hospitality, catering and fashion.",
        icon: "fork.knife",
        color: Color(hex: "#E91E63"),
        bgColor: Color(hex: "#FCE4EC"),
        highlights: [
            DepartmentHighlight(icon: "flame.fill", title: "Culinary Arts", body: "Learn food preparation techniques, kitchen safety, cooking methods and the art of baking."),
            DepartmentHighlight(icon: "scissors", title: "Fashion & Sewing", body: "Discover fabric types, basic sewing stitches and how to care for garments properly."),
            DepartmentHighlight(icon: "hand.raised.fill", title: "Practical Life Skills", body: "Gain hands-on experience that applies directly to real kitchens and creative studios.")
        ],
        careers: ["Chef", "Pastry Cook", "Fashion Designer", "Tailor", "Catering Manager"]
    ),
]

struct ModuleSection: Identifiable {
    let id = UUID()
    let heading: String
    let body: String
    let icon: String
}

struct Module: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let iconBgColor: Color
    let iconColor: Color
    let department: String
    let content: [ModuleSection]
}

let sampleModules: [Module] = [

    Module(title: "Introduction to Automotive",
           description: "Get a feel for how vehicles work and what keeps them running smoothly.",
           icon: "wrench.and.screwdriver.fill",
           iconBgColor: Color(hex: "#FFF0E6"), iconColor: Color(hex: "#E8472A"),
           department: "Engineering",
           content: [
               ModuleSection(heading: "What is Automotive Technology", body: "It's the engines, electronics and systems that work together to keep a car running.", icon: "car.fill"),
               ModuleSection(heading: "Main Vehicle Systems", body: "Engine, fuel, cooling, electrical and brakes each play their own role.", icon: "gearshape.fill"),
               ModuleSection(heading: "Basic Maintenance Habits", body: "Simple checks like oil and tyre pressure go a long way.", icon: "checkmark.shield.fill")
           ]),
    Module(title: "F1 Pit Stop Techniques",
           description: "Discover the speed and teamwork behind a world-class pit stop.",
           icon: "flag.checkered",
           iconBgColor: Color(hex: "#FFF0E6"), iconColor: Color(hex: "#E8472A"),
           department: "Engineering",
           content: [
               ModuleSection(heading: "Why Speed Matters", body: "A pro F1 pit stop takes under 3 seconds — every move counts.", icon: "stopwatch.fill"),
               ModuleSection(heading: "The Tyre Change Sequence", body: "Loosen, remove, fit, tighten — four quick steps per tyre.", icon: "circle.dashed"),
               ModuleSection(heading: "Crew Coordination", body: "The crew trains together so every task flows as one motion.", icon: "person.3.fill")
           ]),
    Module(title: "Basic Electrical Concepts",
           description: "A gentle introduction to voltage, current and how circuits work.",
           icon: "bolt.fill",
           iconBgColor: Color(hex: "#FFFDE7"), iconColor: Color(hex: "#FFC107"),
           department: "Engineering",
           content: [
               ModuleSection(heading: "Voltage, Current & Resistance", body: "Voltage pushes electricity, current is the flow, resistance limits it.", icon: "bolt.circle.fill"),
               ModuleSection(heading: "Ohm's Law Explained", body: "A simple formula — V = I × R — ties them all together.", icon: "function"),
               ModuleSection(heading: "Reading a Simple Circuit", body: "Every circuit needs a power source, a conductor and a load.", icon: "point.topleft.down.curvedto.point.bottomright.up")
           ]),
    Module(title: "Circuit Design & Analysis",
           description: "Learn how circuits are built and how current finds its way through.",
           icon: "alternatingcurrent",
           iconBgColor: Color(hex: "#FFFDE7"), iconColor: Color(hex: "#FFC107"),
           department: "Engineering",
           content: [
               ModuleSection(heading: "Series Circuits", body: "One single path — the same current flows through everything.", icon: "arrow.right"),
               ModuleSection(heading: "Parallel Circuits", body: "Multiple paths let current split between branches.", icon: "arrow.triangle.branch"),
               ModuleSection(heading: "Combination Circuits", body: "Most real circuits mix both, solved one step at a time.", icon: "puzzlepiece.fill")
           ]),

    Module(title: "Computer Networking Fundamentals",
           description: "Understand how devices talk to each other over a network.",
           icon: "network",
           iconBgColor: Color(hex: "#E3F0FF"), iconColor: Color(hex: "#2196F3"),
           department: "IT",
           content: [
               ModuleSection(heading: "What is a Network", body: "It lets devices share data, files and resources with each other.", icon: "personalhotspot"),
               ModuleSection(heading: "Common Network Topologies", body: "Star, bus and ring describe how devices are arranged.", icon: "circle.grid.3x3.fill"),
               ModuleSection(heading: "Core Networking Protocols", body: "Protocols like TCP/IP set the rules for communication.", icon: "doc.text.fill")
           ]),
    Module(title: "Network Routing & Switching",
           description: "See how data finds the fastest path to where it needs to go.",
           icon: "arrow.triangle.swap",
           iconBgColor: Color(hex: "#E3F0FF"), iconColor: Color(hex: "#2196F3"),
           department: "IT",
           content: [
               ModuleSection(heading: "Routers vs Switches", body: "Switches connect devices nearby, routers connect networks apart.", icon: "arrow.left.arrow.right"),
               ModuleSection(heading: "How Routing Works", body: "Routers use tables to pick the best path for data.", icon: "map.fill"),
               ModuleSection(heading: "Data Path Configuration", body: "The right setup keeps data fast and traffic light.", icon: "slider.horizontal.3")
           ]),
    Module(title: "LAN & WAN Configuration",
           description: "Learn the difference between a small office network and the internet.",
           icon: "wifi",
           iconBgColor: Color(hex: "#E3F0FF"), iconColor: Color(hex: "#2196F3"),
           department: "IT",
           content: [
               ModuleSection(heading: "What is a LAN", body: "A network that covers a small area, like one building.", icon: "building.2.fill"),
               ModuleSection(heading: "What is a WAN", body: "Connects networks across cities or countries.", icon: "globe"),
               ModuleSection(heading: "Choosing the Right Setup", body: "Depends on distance, devices and how much bandwidth is needed.", icon: "checkmark.circle.fill")
           ]),
    Module(title: "Network Security Basics",
           description: "Pick up a few simple habits that keep a network safe.",
           icon: "lock.shield.fill",
           iconBgColor: Color(hex: "#E3F0FF"), iconColor: Color(hex: "#2196F3"),
           department: "IT",
           content: [
               ModuleSection(heading: "Common Network Threats", body: "Malware and phishing are some of the most common risks.", icon: "exclamationmark.triangle.fill"),
               ModuleSection(heading: "Role of a Firewall", body: "It blocks traffic that doesn't follow the rules.", icon: "flame.fill"),
               ModuleSection(heading: "Everyday Security Habits", body: "Strong passwords and regular updates help a lot.", icon: "key.fill")
           ]),

    Module(title: "Kitchen Safety & Hygiene",
           description: "Small habits that keep any kitchen safe and clean.",
           icon: "fork.knife",
           iconBgColor: Color(hex: "#FCE4EC"), iconColor: Color(hex: "#E91E63"),
           department: "Home Science",
           content: [
               ModuleSection(heading: "Safe Equipment Handling", body: "Knives and stoves deserve a careful, steady hand.", icon: "hand.raised.fill"),
               ModuleSection(heading: "Hygiene Standards", body: "Clean hands and surfaces keep food safe to eat.", icon: "drop.fill"),
               ModuleSection(heading: "Handling Kitchen Emergencies", body: "Knowing what to do for cuts or burns helps you stay calm.", icon: "cross.case.fill")
           ]),
    Module(title: "Food Preparation Techniques",
           description: "The small skills that make cooking easier and more fun.",
           icon: "takeoutbag.and.cup.and.straw.fill",
           iconBgColor: Color(hex: "#FCE4EC"), iconColor: Color(hex: "#E91E63"),
           department: "Home Science",
           content: [
               ModuleSection(heading: "Accurate Measuring", body: "A little precision makes recipes turn out right.", icon: "scalemass.fill"),
               ModuleSection(heading: "Basic Cutting Techniques", body: "Dicing and slicing well saves time and looks great too.", icon: "scissors"),
               ModuleSection(heading: "Preparing Ingredients", body: "Washing and portioning sets you up for smooth cooking.", icon: "leaf.fill")
           ]),
    Module(title: "Culinary Arts & Baking",
           description: "A light look at cooking, baking and making food look good.",
           icon: "birthday.cake.fill",
           iconBgColor: Color(hex: "#FCE4EC"), iconColor: Color(hex: "#E91E63"),
           department: "Home Science",
           content: [
               ModuleSection(heading: "Cooking Methods", body: "Boiling, frying and grilling each bring out different flavours.", icon: "flame.fill"),
               ModuleSection(heading: "Baking Fundamentals", body: "Baking loves precise measurements and temperatures.", icon: "thermometer"),
               ModuleSection(heading: "Food Decoration Basics", body: "A little plating makes any dish feel special.", icon: "paintbrush.fill")
           ]),
    Module(title: "Sewing & Fabric Care",
           description: "Friendly basics for stitching and looking after your clothes.",
           icon: "scissors",
           iconBgColor: Color(hex: "#FCE4EC"), iconColor: Color(hex: "#E91E63"),
           department: "Home Science",
           content: [
               ModuleSection(heading: "Basic Sewing Stitches", body: "Running stitch and backstitch are great places to start.", icon: "scribble"),
               ModuleSection(heading: "Understanding Fabric Types", body: "Cotton, polyester and wool each need different care.", icon: "square.grid.2x2.fill"),
               ModuleSection(heading: "Proper Garment Care", body: "Reading care labels keeps clothes looking new longer.", icon: "tshirt.fill")
           ]),
]

let moduleDepartments = ["All", "Engineering", "IT", "Home Science"]

func moduleDeptEmoji(_ dept: String) -> String {
    switch dept {
    case "Engineering": return "🔧"
    case "IT":           return "💻"
    case "Home Science": return "🍽️"
    default:              return "📚"
    }
}

func statusColor(_ status: ModuleStatus) -> Color {
    switch status {
    case .completed:   return Color(hex: "#34C759")
    case .inProgress:  return Color(hex: "#E8472A")
    case .notStarted:  return Color.clear
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
                        Text("A few easy reads before you jump into the games")
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

                    if selectedDept == "All" {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                ForEach(sampleDepartments) { dept in
                                    NavigationLink(destination: DepartmentOverviewView(department: dept)) {
                                        DepartmentCard(department: dept)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 4)
                        }
                        .padding(.bottom, 20)
                    }

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
                    .lineLimit(2)
            }

            Spacer()

            if status != .notStarted {
                Text(status.label)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(statusColor(status))
                    .cornerRadius(20)
                    .fixedSize()
            }
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
                        module.iconBgColor.frame(height: 180)
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.65))
                                    .frame(width: 80, height: 80)
                                Image(systemName: module.icon)
                                    .font(.system(size: 36))
                                    .foregroundColor(module.iconColor)
                            }
                            Text(module.title)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                    }

                    VStack(spacing: 18) {

                        HStack(spacing: 10) {
                            DetailStatBox(value: status == .notStarted ? "Ready" : status.label,
                                         label: "Status",
                                         icon: "checkmark.circle",
                                         color: status == .notStarted ? module.iconColor : statusColor(status))
                            DetailStatBox(value: module.department,
                                         label: "Department",
                                         icon: "building.2",
                                         color: module.iconColor)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        Text(module.description)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#6C6C70"))
                            .lineSpacing(4)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)

                        VStack(spacing: 10) {
                            ForEach(module.content) { section in
                                ModuleSectionCard(section: section, accentColor: module.iconColor)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 6)

                        Button(action: {
                            if status == .notStarted {
                                appState.setModuleStatus(.inProgress, for: module.title)
                            } else if status == .inProgress {
                                appState.setModuleStatus(.completed, for: module.title)
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: status == .completed ? "checkmark.circle.fill" : "book.fill")
                                    .font(.system(size: 14))
                                Text(status == .notStarted ? "Mark as Read"
                                     : status == .completed ? "Read Again"
                                     : "Mark as Completed")
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
                        .padding(.top, 6)
                    }
                }
            }
        }
        .navigationTitle(module.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if status == .notStarted {
                appState.setModuleStatus(.inProgress, for: module.title)
            }
        }
    }
}

struct ModuleSectionCard: View {
    let section: ModuleSection
    let accentColor: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(accentColor.opacity(0.12))
                    .frame(width: 38, height: 38)
                Image(systemName: section.icon)
                    .font(.system(size: 16))
                    .foregroundColor(accentColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(section.heading)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(hex: "#1C1C1E"))
                Text(section.body)
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#6C6C70"))
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(14)
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


struct DepartmentCard: View {
    let department: Department

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(department.bgColor)
                        .frame(width: 42, height: 42)
                    Image(systemName: department.icon)
                        .font(.system(size: 18))
                        .foregroundColor(department.color)
                }
                Spacer()
                Text(department.emoji)
                    .font(.system(size: 22))
            }

            Text(department.name)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color(hex: "#1C1C1E"))

            Text(department.tagline)
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "#8E8E93"))
                .lineLimit(2)

            Text("Explore →")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(department.color)
        }
        .padding(14)
        .frame(width: 160)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 3)
    }
}

struct DepartmentOverviewView: View {
    let department: Department

    var departmentModules: [Module] {
        sampleModules.filter { $0.department == department.name }
    }

    var body: some View {
        ZStack {
            Color(hex: "#F5F0EB").ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    ZStack {
                        department.bgColor.frame(height: 200)
                        VStack(spacing: 12) {
                            Text(department.emoji)
                                .font(.system(size: 52))
                            Text(department.name)
                                .font(.system(size: 24, weight: .black))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                            Text(department.tagline)
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "#6C6C70"))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                        }
                    }

                    VStack(spacing: 18) {

                        VStack(alignment: .leading, spacing: 8) {
                            Text("About This Course")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                            Text(department.about)
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "#6C6C70"))
                                .lineSpacing(4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        VStack(alignment: .leading, spacing: 12) {
                            Text("What You Will Learn")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                                .padding(.horizontal, 20)

                            VStack(spacing: 10) {
                                ForEach(department.highlights) { highlight in
                                    HStack(alignment: .top, spacing: 12) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(department.color.opacity(0.12))
                                                .frame(width: 38, height: 38)
                                            Image(systemName: highlight.icon)
                                                .font(.system(size: 16))
                                                .foregroundColor(department.color)
                                        }
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(highlight.title)
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(Color(hex: "#1C1C1E"))
                                            Text(highlight.body)
                                                .font(.system(size: 12))
                                                .foregroundColor(Color(hex: "#6C6C70"))
                                                .lineSpacing(3)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                    }
                                    .padding(14)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .cornerRadius(14)
                                }
                            }
                            .padding(.horizontal, 20)
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Career Pathways")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                                .padding(.horizontal, 20)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(department.careers, id: \.self) { career in
                                        Text(career)
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(department.color)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 8)
                                            .background(department.color.opacity(0.1))
                                            .cornerRadius(20)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Modules in This Course")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                                .padding(.horizontal, 20)

                            VStack(spacing: 10) {
                                ForEach(departmentModules) { module in
                                    HStack(spacing: 12) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(module.iconBgColor)
                                                .frame(width: 42, height: 42)
                                            Image(systemName: module.icon)
                                                .font(.system(size: 18))
                                                .foregroundColor(module.iconColor)
                                        }
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text(module.title)
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(Color(hex: "#1C1C1E"))
                                            Text(module.description)
                                                .font(.system(size: 11))
                                                .foregroundColor(Color(hex: "#8E8E93"))
                                                .lineLimit(2)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color(hex: "#C7C7CC"))
                                    }
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(14)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .navigationTitle(department.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview { ModulesView(showSidebar: .constant(false)).environmentObject(AppState.shared) }
