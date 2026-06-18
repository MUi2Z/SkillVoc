import SwiftUI

struct CalendarEvent: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let date: Date
    let endDate: Date
    let location: String
    let type: EventType
    let registeredCount: Int
    let maxCount: Int

    enum EventType: String {
        case workshop    = "Workshop"
        case competition = "Competition"
        case seminar     = "Seminar"
        case assessment  = "Assessment"
        case class_      = "Class"

        var color: Color {
            switch self {
            case .workshop:    return Color(hex: "#E8472A")
            case .competition: return Color(hex: "#9C27B0")
            case .seminar:     return Color(hex: "#2196F3")
            case .assessment:  return Color(hex: "#FF9500")
            case .class_:      return Color(hex: "#34C759")
            }
        }
        var icon: String {
            switch self {
            case .workshop:    return "wrench.fill"
            case .competition: return "trophy.fill"
            case .seminar:     return "person.3.fill"
            case .assessment:  return "checkmark.circle.fill"
            case .class_:      return "book.fill"
            }
        }
    }

    var registrationProgress: Double {
        guard maxCount > 0 else { return 0 }
        return Double(registeredCount) / Double(maxCount)
    }
}


let sampleEvents: [CalendarEvent] = {
    let cal = Calendar.current
    let today = Date()
    func makeDate(_ dayOffset: Int, _ hour: Int, _ endHour: Int) -> (Date, Date) {
        let base = cal.date(byAdding: .day, value: dayOffset, to: today)!
        let start = cal.date(bySettingHour: hour, minute: 0, second: 0, of: base)!
        let end   = cal.date(bySettingHour: endHour, minute: 0, second: 0, of: base)!
        return (start, end)
    }
    let (d1s, d1e) = makeDate(0, 9, 12)
    let (d2s, d2e) = makeDate(6, 9, 16)
    let (d3s, d3e) = makeDate(13, 9, 16)
    let (d4s, d4e) = makeDate(20, 14, 17)
    let (d5s, d5e) = makeDate(3, 10, 11)
    let (d6s, d6e) = makeDate(8, 8, 10)

    return [
        CalendarEvent(title: "TVET Skills Workshop",
                      description: "Practical hands-on training session for all enrolled students.",
                      date: d1s, endDate: d1e, location: "Lab A",
                      type: .workshop, registeredCount: 36, maxCount: 50),
        CalendarEvent(title: "TVET Innovation Competition",
                      description: "Annual competition showcasing student innovation and vocational projects.",
                      date: d2s, endDate: d2e, location: "Innovation Hall",
                      type: .competition, registeredCount: 65, maxCount: 100),
        CalendarEvent(title: "Career Guidance Seminar",
                      description: "Industry professionals share TVET career pathways and opportunities.",
                      date: d3s, endDate: d3e, location: "Hall B",
                      type: .seminar, registeredCount: 40, maxCount: 80),
        CalendarEvent(title: "Automotive Theory Assessment",
                      description: "Written test covering engine systems and vehicle diagnostics.",
                      date: d4s, endDate: d4e, location: "Exam Hall",
                      type: .assessment, registeredCount: 28, maxCount: 30),
        CalendarEvent(title: "Network Systems Class",
                      description: "Introduction to LAN/WAN configuration and network protocols.",
                      date: d5s, endDate: d5e, location: "ICT Lab",
                      type: .class_, registeredCount: 22, maxCount: 35),
        CalendarEvent(title: "Culinary Skills Workshop",
                      description: "Hands-on food preparation and kitchen safety training.",
                      date: d6s, endDate: d6e, location: "Culinary Lab",
                      type: .workshop, registeredCount: 18, maxCount: 25),
    ]
}()


struct CalendarView: View {

    @Binding var showSidebar: Bool
    @State private var selectedDate = Date()
    @State private var displayedMonth = Date()
    @State private var selectedTab = 0

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var eventsOnSelectedDate: [CalendarEvent] {
        sampleEvents.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
    }

    var upcomingEvents: [CalendarEvent] {
        sampleEvents.filter { $0.date >= Date() }.sorted { $0.date < $1.date }
    }

    var body: some View {
        ZStack {
            Color(hex: "#F5F0EB").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // Title
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Calendar & Events")
                            .font(.system(size: 26, weight: .black))
                            .foregroundColor(Color(hex: "#1C1C1E"))
                        Text("TVET programs, workshops, competitions and training sessions")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#8E8E93"))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 16)

                    // Tab selector
                    HStack(spacing: 0) {
                        ForEach(["Monthly View", "Upcoming", "Attendance"].indices, id: \.self) { i in
                            Button(action: { withAnimation { selectedTab = i } }) {
                                Text(["Monthly View", "Upcoming", "Attendance"][i])
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(selectedTab == i ? .white : Color(hex: "#3C3C43"))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 9)
                                    .background(selectedTab == i ? Color(hex: "#E8472A") : Color.white)
                                    .cornerRadius(20)
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)

                    // Monthly calendar card
                    VStack(spacing: 12) {

                        // Month navigation
                        HStack {
                            Button(action: { changeMonth(by: -1) }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "#1C1C1E"))
                            }
                            Spacer()
                            VStack(spacing: 2) {
                                Text(monthYearString(from: displayedMonth))
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(hex: "#1C1C1E"))
                                Text("\(eventsInMonth()) events this month")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(hex: "#8E8E93"))
                            }
                            Spacer()
                            Button(action: { changeMonth(by: 1) }) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "#1C1C1E"))
                            }
                        }
                        .padding(.horizontal, 4)

                        // Weekday headers
                        LazyVGrid(columns: columns, spacing: 6) {
                            ForEach(weekdays, id: \.self) { day in
                                Text(day)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(Color(hex: "#8E8E93"))
                                    .frame(maxWidth: .infinity)
                            }
                        }

                        // Day cells
                        LazyVGrid(columns: columns, spacing: 6) {
                            ForEach(daysInMonth(), id: \.self) { date in
                                if let date = date {
                                    DayCell(
                                        date: date,
                                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                        isToday: calendar.isDateInToday(date),
                                        hasEvent: hasEvent(on: date)
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedDate = date
                                        }
                                    }
                                } else {
                                    Color.clear.frame(height: 38)
                                }
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                    // Events on selected day
                    VStack(alignment: .leading, spacing: 10) {
                        Text(dayHeaderLabel(for: selectedDate))
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(hex: "#1C1C1E"))
                            .padding(.horizontal, 20)

                        if eventsOnSelectedDate.isEmpty {
                            HStack(spacing: 12) {
                                Image(systemName: "calendar.badge.checkmark")
                                    .font(.system(size: 22))
                                    .foregroundColor(Color(hex: "#8E8E93"))
                                Text("No events on this day")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#8E8E93"))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(16)
                            .padding(.horizontal, 20)
                        } else {
                            ForEach(eventsOnSelectedDate) { event in
                                EventCard(event: event)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.bottom, 20)

                    // Upcoming events
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Upcoming Events")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(hex: "#1C1C1E"))
                            .padding(.horizontal, 20)

                        ForEach(upcomingEvents.prefix(4)) { event in
                            EventCard(event: event)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationTitle("Calendar")
        .navigationBarTitleDisplayMode(.inline)
    }


    private func daysInMonth() -> [Date?] {
        guard let interval = calendar.dateInterval(of: .month, for: displayedMonth),
              let firstWeekday = calendar.dateComponents([.weekday], from: interval.start).weekday
        else { return [] }

        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        var current = interval.start
        while current < interval.end {
            days.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }
        return days
    }

    private func hasEvent(on date: Date) -> Bool {
        sampleEvents.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }

    private func eventsInMonth() -> Int {
        sampleEvents.filter {
            calendar.isDate($0.date, equalTo: displayedMonth, toGranularity: .month)
        }.count
    }

    private func changeMonth(by value: Int) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            displayedMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth)!
        }
    }

    private func monthYearString(from date: Date) -> String {
        let fmt = DateFormatter(); fmt.dateFormat = "MMMM yyyy"
        return fmt.string(from: date)
    }

    private func dayHeaderLabel(for date: Date) -> String {
        if calendar.isDateInToday(date)     { return "Today's Events" }
        if calendar.isDateInTomorrow(date)  { return "Tomorrow's Events" }
        let fmt = DateFormatter(); fmt.dateFormat = "EEEE, MMM d"
        return fmt.string(from: date)
    }
}


struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasEvent: Bool
    private let cal = Calendar.current

    var body: some View {
        VStack(spacing: 3) {
            Text("\(cal.component(.day, from: date))")
                .font(.system(size: 13, weight: isSelected || isToday ? .bold : .regular))
                .foregroundColor(
                    isSelected ? .white :
                    isToday    ? Color(hex: "#E8472A") :
                    Color(hex: "#1C1C1E")
                )
                .frame(width: 32, height: 32)
                .background(
                    isSelected ? Color(hex: "#E8472A") :
                    isToday    ? Color(hex: "#E8472A").opacity(0.1) :
                    Color.clear
                )
                .clipShape(Circle())

            Circle()
                .fill(hasEvent && !isSelected ? Color(hex: "#E8472A") : Color.clear)
                .frame(width: 5, height: 5)
        }
    }
}


struct EventCard: View {
    let event: CalendarEvent

    private let timeFmt: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "h:mm a"; return f
    }()
    private let dateFmt: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "d MMM yyyy"; return f
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            
            HStack(alignment: .top, spacing: 12) {
                
                Text(dateFmt.string(from: event.date))
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(event.type.color)
                    .cornerRadius(20)

                Spacer()

                Image(systemName: event.type.icon)
                    .font(.system(size: 16))
                    .foregroundColor(event.type.color)
            }

            
            Text(event.title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(hex: "#1C1C1E"))

            
            Text(event.description)
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "#8E8E93"))
                .lineLimit(2)

            
            HStack(spacing: 14) {
                HStack(spacing: 4) {
                    Image(systemName: "clock").font(.system(size: 11)).foregroundColor(Color(hex: "#8E8E93"))
                    Text("\(timeFmt.string(from: event.date)) – \(timeFmt.string(from: event.endDate))")
                        .font(.system(size: 11)).foregroundColor(Color(hex: "#8E8E93"))
                }
                HStack(spacing: 4) {
                    Image(systemName: "mappin").font(.system(size: 11)).foregroundColor(Color(hex: "#8E8E93"))
                    Text(event.location)
                        .font(.system(size: 11)).foregroundColor(Color(hex: "#8E8E93"))
                }
            }

            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("\(event.registeredCount) / \(event.maxCount) registered")
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#8E8E93"))
                    Spacer()
                    Button(action: {}) {
                        Text("Register")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color(hex: "#E8472A"))
                            .cornerRadius(20)
                    }
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3).fill(Color(hex: "#E0DDD8")).frame(height: 5)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(event.type.color)
                            .frame(width: geo.size.width * event.registrationProgress, height: 5)
                    }
                }
                .frame(height: 5)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 6, y: 2)
    }
}

#Preview { CalendarView(showSidebar: .constant(false)) }
