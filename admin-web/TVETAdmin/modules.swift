//
//  modules.swift
//  SkillVocWeb
//
//  Created by MUi2Z on 11/06/2026.
//

import SwiftUI

// MARK: - Data Model
struct ModuleItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: String
    let duration: String
    let status: String // Completed, In Progress, Locked
    let iconName: String
}

// MARK: - Main View
struct ModuleManagementView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var selectedCategory = "All Modules"
    
    let categories = ["All Modules", "Construction", "IT (KSK)", "SRT"]
    
    // Mock Data parsed directly from card elements in image_3bf37d.jpg
    @State private var modules = [
        ModuleItem(title: "Introduction to Construction", description: "Foundations of the construction industry, professional roles, and essential terminology.", category: "Construction", duration: "25 min", status: "Completed", iconName: "hammer.fill"),
        ModuleItem(title: "Construction Safety", description: "PPE guidelines, hazard identification, and safe working procedures on construction sites.", category: "Construction", duration: "30 min", status: "Completed", iconName: "shield.checkerboard"),
        ModuleItem(title: "Building Materials", description: "Types, properties, and appropriate uses of common construction materials on site.", category: "Construction", duration: "36 min", status: "In Progress", iconName: "square.stack.3d.up.fill"),
        ModuleItem(title: "Blueprint Reading", description: "Interpreting technical drawings, floor plans, and construction blueprints accurately.", category: "Construction", duration: "40 min", status: "Locked", iconName: "doc.plaintext.fill"),
        ModuleItem(title: "Computer Fundamentals", description: "Introduction to computers, their history, types, and core computing functions.", category: "IT (KSK)", duration: "20 min", status: "Completed", iconName: "desktopcomputer"),
        ModuleItem(title: "Hardware Components", description: "CPU, RAM, storage, motherboards and peripheral device identification and functions.", category: "IT (KSK)", duration: "35 min", status: "In Progress", iconName: "wrench.and.screwdriver.fill"),
        ModuleItem(title: "Networking Basics", description: "LAN, WAN, network topologies, protocols, and basic network setup procedures.", category: "IT (KSK)", duration: "40 min", status: "Locked", iconName: "network"),
        ModuleItem(title: "IP Addressing", description: "IPv4, subnetting, CIDR notation, address classes and practical addressing exercises.", category: "IT (KSK)", duration: "45 min", status: "Locked", iconName: "globe.asia.australia.fill"),
        ModuleItem(title: "Kitchen Safety", description: "Safe handling of kitchen equipment, hygiene standards, and emergency procedures.", category: "SRT", duration: "20 min", status: "Completed", iconName: "fork.knife"),
        ModuleItem(title: "Food Preparation", description: "Proper techniques for measuring, cutting, and preparing a variety of food ingredients.", category: "SRT", duration: "30 min", status: "Locked", iconName: "leaf.fill")
    ]
    
    var filteredModules: [ModuleItem] {
        modules.filter { module in
            let matchesCategory = selectedCategory == "All Modules" || module.category == selectedCategory
            let matchesSearch = searchText.isEmpty || module.title.localizedCaseInsensitiveContains(searchText) || module.description.localizedCaseInsensitiveContains(searchText)
            return matchesCategory && matchesSearch
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Sidebar Template
            SidebarView()
                .frame(width: appState.compactSidebar ? 90 : 260)
                .background(Color(red: 0.12, green: 0.16, blue: 0.23))
            
            // Content Body
            VStack(spacing: 0) {
                // Top Header Input Bar
                HStack {
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass").foregroundColor(.gray)
                        TextField("Search modules...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(appState.darkMode ? .white : .primary)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: 400)
                    .background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color(red: 0.97, green: 0.98, blue: 0.99))
                    .cornerRadius(12)
                    
                    Spacer()
                    
                    // CRUD Create Button Added For Admin Management Intentions
                    Button(action: { /* Action to add module */ }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Create Module").bold()
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(Color.orange)
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(appState.darkMode ? Color(red: 0.1, green: 0.1, blue: 0.12) : Color.white)
                .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Title Deck Area
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Modules")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(appState.darkMode ? .white : .primary)
                            Text("Study and manage the course module content before playing the games")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 30)
                        
                        // Category Pill Filtering Component
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                Button(action: { selectedCategory = category }) {
                                    Text(category)
                                        .font(.system(size: 14, weight: .semibold))
                                        .padding(.horizontal, 18)
                                        .padding(.vertical, 8)
                                        .background(selectedCategory == category ? Color.orange : (appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color.white))
                                        .foregroundColor(selectedCategory == category ? .white : .gray)
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(selectedCategory == category ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        
                        // CRUD Data Table List Container
                        VStack(spacing: 0) {
                            // Table Header Label Row
                            HStack {
                                Text("Module Info").frame(width: 320, alignment: .leading)
                                Text("Category").frame(width: 140, alignment: .leading)
                                Text("Duration").frame(width: 100, alignment: .leading)
                                Text("Status").frame(width: 120, alignment: .leading)
                                Spacer()
                                Text("Actions").frame(width: 120, alignment: .trailing)
                            }
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(appState.darkMode ? Color(red: 0.13, green: 0.15, blue: 0.18) : Color(red: 0.96, green: 0.97, blue: 0.98))
                            
                            Divider()
                            
                            // Dynamic Table Body Items List Row
                            if filteredModules.isEmpty {
                                Text("No course modules found matching criteria.")
                                    .foregroundColor(.gray)
                                    .padding(.vertical, 40)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                ForEach(filteredModules) { module in
                                    ModuleTableRowView(module: module, onEdit: {
                                        print("Editing: \(module.title)")
                                    }, onDelete: {
                                        if let index = modules.firstIndex(where: { $0.id == module.id }) {
                                            modules.remove(at: index)
                                        }
                                    })
                                    
                                    Divider()
                                }
                            }
                        }
                        .background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 40)
                }
                .background(appState.darkMode ? Color(red: 0.08, green: 0.09, blue: 0.11) : Color(red: 0.94, green: 0.95, blue: 0.96))
            }
        }
        .frame(minWidth: 1150, minHeight: 750)
    }
}

// MARK: - Module Management Sub Table Row Module
struct ModuleTableRowView: View {
    @EnvironmentObject var appState: AppState
    let module: ModuleItem
    var onEdit: () -> Void
    var onDelete: () -> Void
    
    // Status style resolution tracking maps
    private var statusColors: (bg: Color, text: Color) {
        switch module.status {
        case "Completed":
            return (Color.green.opacity(0.1), .green)
        case "In Progress":
            return (Color.orange.opacity(0.1), .orange)
        default:
            return (Color.gray.opacity(0.1), .gray)
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            // Column 1: Info and graphical identity
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(appState.darkMode ? Color.white.opacity(0.05) : Color.orange.opacity(0.06))
                        .frame(width: 44, height: 44)
                    Image(systemName: module.iconName)
                        .foregroundColor(.orange)
                        .font(.system(size: 16))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(module.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(appState.darkMode ? .white : .primary)
                    Text(module.description)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            .frame(width: 320, alignment: .leading)
            
            // Column 2: Structural Category Scope
            Text(module.category)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(appState.darkMode ? .lightGray : .secondary)
                .frame(width: 140, alignment: .leading)
            
            // Column 3: Duration Metadata
            HStack(spacing: 6) {
                Image(systemName: "clock").font(.system(size: 12))
                Text(module.duration)
            }
            .font(.system(size: 13))
            .foregroundColor(.gray)
            .frame(width: 100, alignment: .leading)
            
            // Column 4: Process Phase State Badge Indicator
            Text(module.status)
                .font(.system(size: 11, weight: .bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(statusColors.bg)
                .foregroundColor(statusColors.text)
                .cornerRadius(6)
                .frame(width: 120, alignment: .leading)
            
            Spacer()
            
            // Column 5: CRUD Operations Container View Control Layout Block
            HStack(spacing: 16) {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                        .font(.system(size: 14, weight: .bold))
                        .padding(6)
                        .background(Color.blue.opacity(0.08))
                        .cornerRadius(6)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .font(.system(size: 14, weight: .bold))
                        .padding(6)
                        .background(Color.red.opacity(0.08))
                        .cornerRadius(6)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .frame(width: 120, alignment: .trailing)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background(appState.darkMode ? Color.clear : Color.white)
    }
}

// Extension fallback support helper mapping for colors if needed
extension Color {
    static let lightGray = Color(white: 0.8)
}

#Preview {
    ModuleManagementView()
        .environmentObject(AppState())
}
