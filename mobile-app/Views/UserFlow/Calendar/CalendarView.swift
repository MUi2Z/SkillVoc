import SwiftUI

// MARK: - Calendar Event Model
struct CalendarEvent: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let type: EventType
    let department: String
    let duration: String

    enum EventType: String {
        case assessment = "Assessment"
        case workshop   = "Workshop"
        case submission = "Submission"
        case class_     = "Class"

        var color: Color {
            switch self {
            case .assessment: return Color(hex: "#E8472A")
            case .workshop:   return Color(hex: "#2196F3")
            case .submission: return Color(hex: "#FF9500")
            case .class_:     return Color(hex: "#34C759")
            }
        }

        var icon: String {
            switch self {
            case .assessment: return "checkmark.circle.fill"
            case .workshop:   return "wrench.fill"
            case .submission: return "paperplane.fill"
            case .class_:     return "book.fill"
            }
        }
    }
}

// MARK: - Dummy Calendar Data
let sampleEvents: [CalendarEvent] = {
    let cal = Calendar.current
    let today = Date()
    func date(_ dayOffset: Int, _ hour: Int) -> Date {
        cal.date(bySettingHour: hour, minute: 0, second: 0,
                 of: cal.date(byAdding: .day, value: dayOffset, to: today)!)!
    }
    return [
        CalendarEvent(title: "Automotive Theory Test", date: date(0, 9),
                      type: .assessment, department: "Mechanical", duration: "2 hrs"),
        CalendarEvent(title: "F1 Pit Stop Workshop", date: date(0, 14),
                      type: .workshop, department: "Mechanical", duration: "3 hrs"),
        CalendarEvent(title: "Programming Assignment Due", date: date(1, 11),
                      type: .submission, department: "ICT", duration: "—"),
        CalendarEvent(title: "Network Systems Class", date: date(2, 8),
                      type: .class_, department: "ICT", duration: "1.5 hrs"),
        CalendarEvent(title: "Culinary Skills Assessment", date: date(3, 10),
                      type: .assessment, department: "Hospitality", duration: "2 hrs"),
        CalendarEvent(title: "Electrical Safety Workshop", date: date(5, 14),
                      type: .workshop, department: "Mechanical", duration: "4 hrs"),
        CalendarEvent(title: "Graphic Design Portfolio Due", date: date(7, 17),
                      type: .submission, department: "Creative", duration: "—"),
        CalendarEvent(title: "ICT Fundamentals Class", date: date(8, 9),
                      type: .class_, department: "ICT", duration: "2 hrs"),
    ]
}()

// MARK: - Calendar View
// Letak dalam folder: Views/UserFlow/Calendar/CalendarView.swift

struct CalendarView: View {

    @State private var selectedDate = Date()
    @State private var displayedMonth = Date()

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    // Events on selected date
    var todayEvents: [CalendarEvent] {
        sampleEvents.filter {
            calendar.isDate($0.date, inSameDayAs: selectedDate)
        }
    }

    // Upcoming events (next 14 days)
    var upcomingEvents: [CalendarEvent] {
        let upcoming = sampleEvents.filter { $0.date > Date() }
        return upcoming.sorted { $0.date < $1.date }
    }

    // Days that have events
    var eventDates: Set<String> {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return Set(sampleEvents.map { fmt.string(from: $0.date) })
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F5F0EB").ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {

                        // ── Monthly Calendar ───────────────────────
                        VStack(spacing: 12) {

                            // Month navigation
                            HStack {
                                Button(action: { changeMonth(by: -1) }) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Color(hex: "#1C1C1E"))
                                }
                                Spacer()
                                Text(monthYearString(from: displayedMonth))
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(Color(hex: "#1C1C1E"))
                                Spacer()
                                Button(action: { changeMonth(by: 1) }) {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Color(hex: "#1C1C1E"))
                                }
                            }
                            .padding(.horizontal, 8)

                            // Weekday headers
                            LazyVGrid(columns: columns, spacing: 8) {
                                ForEach(weekdays, id: \.self) { day in
                                    Text(day)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(Color(hex: "#6C6C70"))
                                        .frame(maxWidth: .infinity)
                                }
                            }

                            // Day cells
                            LazyVGrid(columns: columns, spacing: 8) {
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
                                        Color.clear.frame(height: 36)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                        // ── Selected Day Events ────────────────────
                        VStack(alignment: .leading, spacing: 10) {
                            Text(dayLabel(for: selectedDate))
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                                .padding(.horizontal, 20)

                            if todayEvents.isEmpty {
                                HStack(spacing: 12) {
                                    Image(systemName: "calendar.badge.checkmark")
                                        .font(.system(size: 24))
                                        .foregroundColor(Color(hex: "#6C6C70"))
                                    Text("No events on this day")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(hex: "#6C6C70"))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(20)
                                .background(Color.white)
                                .cornerRadius(16)
                                .padding(.horizontal, 20)
                            } else {
                                ForEach(todayEvents) { event in
                                    EventRowView(event: event)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }

                        // ── Upcoming Events ────────────────────────
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Upcoming")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color(hex: "#1C1C1E"))
                                .padding(.horizontal, 20)

                            ForEach(upcomingEvents.prefix(5)) { event in
                                EventRowView(event: event)
                                    .padding(.horizontal, 20)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Calendar")
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

    // MARK: - Helper Functions

    private func daysInMonth() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
              let firstWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday
        else { return [] }

        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        var current = monthInterval.start
        while current < monthInterval.end {
            days.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }
        return days
    }

    private func hasEvent(on date: Date) -> Bool {
        sampleEvents.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }

    private func changeMonth(by value: Int) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            displayedMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth)!
        }
    }

    private func monthYearString(from date: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM yyyy"
        return fmt.string(from: date)
    }

    private func dayLabel(for date: Date) -> String {
        if calendar.isDateInToday(date) { return "Today" }
        if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        let fmt = DateFormatter()
        fmt.dateFormat = "EEEE, MMM d"
        return fmt.string(from: date)
    }
}

// MARK: - Day Cell
struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasEvent: Bool

    private let calendar = Calendar.current

    var body: some View {
        VStack(spacing: 3) {
            Text("\(calendar.component(.day, from: date))")
                .font(.system(size: 14, weight: isSelected || isToday ? .bold : .regular))
                .foregroundColor(
                    isSelected ? .white :
                    isToday ? Color(hex: "#E8472A") :
                    Color(hex: "#1C1C1E")
                )
                .frame(width: 34, height: 34)
                .background(
                    isSelected ? Color(hex: "#E8472A") :
                    isToday ? Color(hex: "#E8472A").opacity(0.1) :
                    Color.clear
                )
                .clipShape(Circle())

            // Event dot
            Circle()
                .fill(hasEvent ? Color(hex: "#E8472A") : Color.clear)
                .frame(width: 5, height: 5)
        }
    }
}

// MARK: - Event Row
struct EventRowView: View {
    let event: CalendarEvent

    private let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f
    }()

    var body: some View {
        HStack(spacing: 14) {

            // Color bar
            RoundedRectangle(cornerRadius: 3)
                .fill(event.type.color)
                .frame(width: 4, height: 50)

            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(event.type.color.opacity(0.12))
                    .frame(width: 40, height: 40)
                Image(systemName: event.type.icon)
                    .font(.system(size: 16))
                    .foregroundColor(event.type.color)
            }

            // Info
            VStack(alignment: .leading, spacing: 3) {
                Text(event.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#1C1C1E"))
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Text(timeFormatter.string(from: event.date))
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#6C6C70"))

                    Text("·")
                        .foregroundColor(Color(hex: "#6C6C70"))

                    Text(event.department)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#6C6C70"))
                }

                Text(event.type.rawValue)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(event.type.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(event.type.color.opacity(0.1))
                    .cornerRadius(6)
            }

            Spacer()

            // Duration
            Text(event.duration)
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "#6C6C70"))
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
    }
}

#Preview { CalendarView() }
