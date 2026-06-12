import SwiftUI

struct CalendarEventsView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var showNotifications = false
    @State private var selectedTab = "Monthly View"
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(spacing: 0) {
                SidebarView()
                    .frame(width: appState.compactSidebar ? 90 : 260)
                    .background(Color(red: 0.12, green: 0.16, blue: 0.23))
                
                VStack(spacing: 0) {
                    TopHeaderView(searchText: $searchText, showNotifications: $showNotifications)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(appState.darkMode ? Color(red: 0.1, green: 0.1, blue: 0.12) : Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                        .zIndex(1)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Calendar & Events")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(appState.darkMode ? .white : .primary)
                                Text("TVET programs, workshops, competitions and training sessions")
                                    .font(.system(size: 14))
                                    .foregroundColor(appState.darkMode ? .gray : .secondary)
                            }
                            .padding(.top, 30)
                            
                            HStack(spacing: 10) {
                                TabToggleButton(title: "Monthly View", isSelected: selectedTab == "Monthly View") { selectedTab = "Monthly View" }
                                TabToggleButton(title: "Upcoming Events", isSelected: selectedTab == "Upcoming Events") { selectedTab = "Upcoming Events" }
                                TabToggleButton(title: "Attendance", isSelected: selectedTab == "Attendance") { selectedTab = "Attendance" }
                            }
                            .padding(4)
                            .background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color(red: 0.9, green: 0.92, blue: 0.94).opacity(0.5))
                            .cornerRadius(25)
                            
                            HStack(alignment: .top, spacing: 24) {
                                CalendarGridCard()
                                    .frame(maxWidth: .infinity)
                                
                                VStack(spacing: 24) {
                                    UpcomingEventsSection()
                                    AttendanceSummaryCard()
                                }
                                .frame(width: 400)
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                    }
                    .background(appState.darkMode ? Color(red: 0.08, green: 0.09, blue: 0.11) : Color(red: 0.94, green: 0.95, blue: 0.96))
                    .zIndex(0)
                }
            }
            .frame(minWidth: 1150, minHeight: 750)
            .animation(appState.animatedTransitions ? .easeInOut(duration: 0.3) : .none, value: appState.compactSidebar)
            
            if showNotifications {
                NotificationDropdownView(isPresented: $showNotifications)
                    .padding(.top, 80)
                    .padding(.trailing, 60)
                    .zIndex(9999)
                    .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
            }
        }
    }
}

struct CalendarHeaderView: View {
    @Binding var searchText: String
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Search events...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(appState.darkMode ? .white : .primary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .frame(maxWidth: 400)
            .background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color(red: 0.97, green: 0.98, blue: 0.99))
            .cornerRadius(12)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {}) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                        Text("Add Event").font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(Color.orange)
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct TabToggleButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.vertical, 10)
                .padding(.horizontal, 24)
                .background(isSelected ? Color.orange : Color.clear)
                .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CalendarGridCard: View {
    @EnvironmentObject var appState: AppState
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    let daysData: [(day: Int, isCurrentMonth: Bool, hasDot: Bool, isHighlighted: Bool)] = [
        (27, false, false, false), (28, false, false, false), (29, false, false, false), (30, false, false, false), (31, false, false, false), (1, true, false, false), (2, true, false, false),
        (3, true, false, false), (4, true, false, false), (5, true, false, false), (6, true, true, false), (7, true, false, false), (8, true, false, false), (9, true, false, false),
        (10, true, false, false), (11, true, false, false), (12, true, false, false), (13, true, false, false), (14, true, false, false), (15, true, true, false), (16, true, false, false),
        (17, true, false, false), (18, true, false, false), (19, true, false, false), (20, true, false, false), (21, true, false, false), (22, true, true, false), (23, true, false, true),
        (24, true, false, false), (25, true, false, false), (26, true, false, false), (27, true, false, false), (28, true, false, false), (29, true, false, false), (30, true, false, false),
        (31, true, false, false), (1, false, false, false), (2, false, false, false), (3, false, false, false), (4, false, false, false), (5, false, false, false), (6, false, false, false)
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                HStack(spacing: 16) {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .padding(10)
                            .background(appState.darkMode ? Color(red: 0.2, green: 0.22, blue: 0.25) : Color(red: 0.96, green: 0.96, blue: 0.97))
                            .cornerRadius(8)
                    }
                    
                    Text("August 2026")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(appState.darkMode ? .white : .primary)
                    
                    Button(action: {}) {
                        Image(systemName: "chevron.right")
                            .padding(10)
                            .background(appState.darkMode ? Color(red: 0.2, green: 0.22, blue: 0.25) : Color(red: 0.96, green: 0.96, blue: 0.97))
                            .cornerRadius(8)
                    }
                }
                .foregroundColor(.gray)
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Text("3 events this month")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 10)
            
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 16) {
                ForEach(0..<daysData.count, id: \.self) { index in
                    let cell = daysData[index]
                    
                    VStack(spacing: 4) {
                        Text("\(cell.day)")
                            .font(.system(size: 15, weight: cell.isHighlighted ? .bold : .medium))
                            .foregroundColor(
                                cell.isHighlighted ? .white :
                                (!cell.isCurrentMonth ? .gray.opacity(0.5) : (appState.darkMode ? .white : .primary))
                            )
                            .frame(width: 40, height: 40)
                            .background(cell.isHighlighted ? Color.orange : Color.clear)
                            .cornerRadius(10)
                        
                        Circle()
                            .fill(cell.hasDot ? Color.orange : Color.clear)
                            .frame(width: 5, height: 5)
                    }
                    .frame(height: 55)
                }
            }
        }
        .padding(32)
        .background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.03), radius: 4, y: 2)
    }
}

struct UpcomingEventsSection: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Upcoming Events")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(appState.darkMode ? .white : .primary)
            
            EventDetailRow(dateBadge: "6 Aug 2026", title: "TVET Skills Workshop", desc: "Practical hands-on training session for all enrolled students.", time: "9:00 AM - 12:00 PM", location: "Lab A", registered: 36, totalCapacity: 50)
            EventDetailRow(dateBadge: "15 Aug 2026", title: "TVET Innovation Competition", desc: "Annual competition showcasing student innovation and vocational projects.", time: "9:00 AM - 4:00 PM", location: "Innovation Hall", registered: 65, totalCapacity: 100)
            EventDetailRow(dateBadge: "22 Aug 2026", title: "Career Guidance Seminar", desc: "Industry professionals share TVET career pathways and opportunities.", time: "2:00 PM - 5:00 PM", location: "Hall B", registered: 40, totalCapacity: 80)
        }
    }
}

struct EventDetailRow: View {
    @EnvironmentObject var appState: AppState
    let dateBadge: String
    let title: String
    let desc: String
    let time: String
    let location: String
    let registered: Int
    let totalCapacity: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(dateBadge)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
                .background(Color.orange)
                .cornerRadius(6)
            
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(appState.darkMode ? .white : .primary)
            
            Text(desc)
                .font(.system(size: 13))
                .foregroundColor(appState.darkMode ? .gray : .secondary)
                .lineLimit(2)
            
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text(time)
                }
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                    Text(location)
                }
            }
            .font(.system(size: 12))
            .foregroundColor(.gray)
            
            HStack(alignment: .bottom, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(registered)/\(totalCapacity) registered")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(appState.darkMode ? Color.gray.opacity(0.2) : Color.gray.opacity(0.15))
                            Capsule().fill(Color.orange).frame(width: geo.size.width * CGFloat(registered) / CGFloat(totalCapacity))
                        }
                    }
                    .frame(height: 6)
                }
                
                Button(action: {}) {
                    Text("Register")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.orange)
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(20)
        .background(appState.darkMode ? Color(red: 0.15, green: 0.17, blue: 0.2) : Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.02), radius: 3, y: 1)
    }
}

struct AttendanceSummaryCard: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Innovation Competition — Attendance Summary")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.orange)
            
            HStack(spacing: 16) {
                VStack(spacing: 6) {
                    Text("85")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(appState.darkMode ? .white : Color(red: 0.15, green: 0.15, blue: 0.2))
                    Text("Present")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(appState.darkMode ? Color(red: 0.18, green: 0.2, blue: 0.24) : Color.white)
                .cornerRadius(10)
                
                VStack(spacing: 6) {
                    Text("15")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color.red.opacity(0.8))
                    Text("Absent")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(appState.darkMode ? Color(red: 0.18, green: 0.2, blue: 0.24) : Color.white)
                .cornerRadius(10)
            }
            
            HStack {
                Spacer()
                HStack(spacing: 4) {
                    Text("Attendance Rate:")
                        .foregroundColor(.gray)
                    Text("85%")
                        .foregroundColor(.orange)
                        .bold()
                }
                .font(.system(size: 13))
                Spacer()
            }
            .padding(.top, 4)
        }
        .padding(24)
        .background(appState.darkMode ? Color(red: 0.13, green: 0.14, blue: 0.16) : Color.orange.opacity(0.08))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.orange.opacity(0.15), lineWidth: 1)
        )
    }
}

#Preview {
    CalendarEventsView()
        .environmentObject(AppState())
}
