import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth

struct CalendarEvent: Identifiable {
    let id: String
    let title: String
    let description: String
    let date: Date
    let endDate: Date
    let location: String
    let type: EventType
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
}

class EventRegistrationManager: ObservableObject {
    @Published var registrationCounts: [String: Int] = [:]
    @Published var registeredEventIds: Set<String> = []

    private let db = Firestore.firestore()

    func fetchRegistrations(for eventId: String) {
        db.collection("events").document(eventId).collection("registrations")
            .addSnapshotListener { [weak self] snapshot, _ in
                self?.registrationCounts[eventId] = snapshot?.documents.count ?? 0
            }
    }

    func checkIfRegistered(eventId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("events").document(eventId).collection("registrations")
            .document(uid).getDocument { [weak self] doc, _ in
                if doc?.exists == true {
                    self?.registeredEventIds.insert(eventId)
                }
            }
    }

    func register(eventId: String, userName: String, completion: @escaping (Bool, String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false, "Please log in to register.")
            return
        }
        let data: [String: Any] = [
            "uid": uid,
            "name": userName,
            "registeredAt": FieldValue.serverTimestamp()
        ]
        db.collection("events").document(eventId).collection("registrations")
            .document(uid).setData(data) { [weak self] error in
                if let error = error {
                    completion(false, error.localizedDescription)
                } else {
                    self?.registeredEventIds.insert(eventId)
                    completion(true, nil)
                }
            }
    }

    func unregister(eventId: String, completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("events").document(eventId).collection("registrations")
            .document(uid).delete { [weak self] error in
                if error == nil {
                    self?.registeredEventIds.remove(eventId)
                    completion(true)
                } else {
                    completion(false)
                }
            }
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
        CalendarEvent(id: "event_workshop_1", title: "TVET Skills Workshop",
                      description: "Practical hands-on training session for all enrolled students.",
                      date: d1s, endDate: d1e, location: "Lab A", type: .workshop, maxCount: 50),
        CalendarEvent(id: "event_competition_1", title: "TVET Innovation Competition",
                      description: "Annual competition showcasing student innovation and vocational projects.",
                      date: d2s, endDate: d2e, location: "Innovation Hall", type: .competition, maxCount: 100),
        CalendarEvent(id: "event_seminar_1", title: "Career Guidance Seminar",
                      description: "Industry professionals share TVET career pathways and opportunities.",
                      date: d3s, endDate: d3e, location: "Hall B", type: .seminar, maxCount: 80),
        CalendarEvent(id: "event_assessment_1", title: "Automotive Theory Assessment",
                      description: "Written test covering engine systems and vehicle diagnostics.",
                      date: d4s, endDate: d4e, location: "Exam Hall", type: .assessment, maxCount: 30),
        CalendarEvent(id: "event_class_1", title: "Network Systems Class",
                      description: "Introduction to LAN/WAN configuration and network protocols.",
                      date: d5s, endDate: d5e, location: "ICT Lab", type: .class_, maxCount: 35),
        CalendarEvent(id: "event_culinary_1", title: "Culinary Skills Workshop",
                      description: "Hands-on food preparation and kitchen safety training.",
                      date: d6s, endDate: d6e, location: "Culinary Lab", type: .workshop, maxCount: 25),
    ]
}()

struct CalendarView: View {

    @Binding var showSidebar: Bool
    @EnvironmentObject var appState: AppState
    @StateObject private var regManager = EventRegistrationManager()

    @State private var selectedDate = Date()
    @State private var displayedMonth = Date()
    @State private var selectedTab = 0
    @State private var selectedEventForRegistration: CalendarEvent? = nil

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var eventsOnSelectedDate: [CalendarEvent] {
        sampleEvents.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
    }

    var body: some View {
        ZStack {
            Color(hex: "#F5F0EB").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

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

                    HStack(spacing: 0) {
                        ForEach(["Monthly View"].indices, id: \.self) { i in
                            Button(action: { withAnimation { selectedTab = i } }) {
                                Text(["Monthly View"    ][i])
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

                    VStack(spacing: 12) {
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

                        LazyVGrid(columns: columns, spacing: 6) {
                            ForEach(weekdays, id: \.self) { day in
                                Text(day)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(Color(hex: "#8E8E93"))
                                    .frame(maxWidth: .infinity)
                            }
                        }

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
                                EventCard(
                                    event: event,
                                    regManager: regManager,
                                    userName: appState.userName,
                                    onRegisterTap: { selectedEventForRegistration = event }
                                )
                                .padding(.horizontal, 20)
                                .onAppear {
                                    regManager.fetchRegistrations(for: event.id)
                                    regManager.checkIfRegistered(eventId: event.id)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationTitle("Calendar")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedEventForRegistration) { event in
            EventRegistrationSheet(
                event: event,
                regManager: regManager,
                userName: appState.userName
            )
        }
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

struct EventRegistrationSheet: View {
    let event: CalendarEvent
    @ObservedObject var regManager: EventRegistrationManager
    let userName: String
    @Environment(\.dismiss) var dismiss
    @State private var isLoading = false
    @State private var message = ""
    @State private var success = false

    var isRegistered: Bool { regManager.registeredEventIds.contains(event.id) }
    var registeredCount: Int { regManager.registrationCounts[event.id] ?? 0 }
    var isFull: Bool { registeredCount >= event.maxCount }

    private let dateFmt: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "d MMM yyyy"; return f
    }()
    private let timeFmt: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "h:mm a"; return f
    }()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F5F0EB").ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {

                        ZStack {
                            event.type.color.opacity(0.1).frame(height: 140)
                            VStack(spacing: 10) {
                                Image(systemName: event.type.icon)
                                    .font(.system(size: 44))
                                    .foregroundColor(event.type.color)
                                Text(event.title)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color(hex: "#1C1C1E"))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                            }
                        }
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 10) {
                                Image(systemName: "calendar").foregroundColor(event.type.color)
                                Text(dateFmt.string(from: event.date))
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#1C1C1E"))
                            }
                            HStack(spacing: 10) {
                                Image(systemName: "clock").foregroundColor(event.type.color)
                                Text("\(timeFmt.string(from: event.date)) – \(timeFmt.string(from: event.endDate))")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#1C1C1E"))
                            }
                            HStack(spacing: 10) {
                                Image(systemName: "mappin").foregroundColor(event.type.color)
                                Text(event.location)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#1C1C1E"))
                            }
                            HStack(spacing: 10) {
                                Image(systemName: "person.2.fill").foregroundColor(event.type.color)
                                Text("\(registeredCount) / \(event.maxCount) registered")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#1C1C1E"))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Registering as")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: "#8E8E93"))
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: "#E8472A"))
                                        .frame(width: 40, height: 40)
                                    Text(String(userName.prefix(2)).uppercased())
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                Text(userName)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "#1C1C1E"))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)

                        if !message.isEmpty {
                            Text(message)
                                .font(.system(size: 13))
                                .foregroundColor(success ? Color(hex: "#34C759") : Color(hex: "#FF3B30"))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }

                        if isRegistered {
                            VStack(spacing: 12) {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(hex: "#34C759"))
                                    Text("You are registered for this event")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color(hex: "#34C759"))
                                }

                                Button(action: { handleUnregister() }) {
                                    Text(isLoading ? "Cancelling..." : "Cancel Registration")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(Color(hex: "#FF3B30"))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(Color(hex: "#FF3B30").opacity(0.1))
                                        .cornerRadius(14)
                                }
                                .disabled(isLoading)
                            }
                            .padding(.horizontal, 20)
                        } else if isFull {
                            Text("This event is full")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(hex: "#8E8E93"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color(hex: "#F0F0F0"))
                                .cornerRadius(14)
                                .padding(.horizontal, 20)
                        } else {
                            Button(action: { handleRegister() }) {
                                HStack {
                                    if isLoading {
                                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white)).scaleEffect(0.9)
                                    }
                                    Text(isLoading ? "Registering..." : "Confirm Registration")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(hex: "#E8472A"))
                                .cornerRadius(14)
                            }
                            .disabled(isLoading)
                            .padding(.horizontal, 20)
                        }

                        Spacer().frame(height: 20)
                    }
                }
            }
            .navigationTitle("Event Registration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                        .foregroundColor(Color(hex: "#E8472A"))
                }
            }
        }
    }

    private func handleRegister() {
        isLoading = true
        message = ""
        regManager.register(eventId: event.id, userName: userName) { success, error in
            isLoading = false
            if success {
                self.success = true
                message = "Successfully registered!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { dismiss() }
            } else {
                self.success = false
                message = error ?? "Registration failed. Please try again."
            }
        }
    }

    private func handleUnregister() {
        isLoading = true
        regManager.unregister(eventId: event.id) { success in
            isLoading = false
            if success {
                self.success = true
                message = "Registration cancelled."
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { dismiss() }
            }
        }
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
    @ObservedObject var regManager: EventRegistrationManager
    let userName: String
    let onRegisterTap: () -> Void

    var registeredCount: Int { regManager.registrationCounts[event.id] ?? 0 }
    var isRegistered: Bool { regManager.registeredEventIds.contains(event.id) }
    var progress: Double { Double(registeredCount) / Double(event.maxCount) }

    private let timeFmt: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "h:mm a"; return f
    }()
    private let dateFmt: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "d MMM yyyy"; return f
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack(alignment: .top) {
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
                    Text(event.location).font(.system(size: 11)).foregroundColor(Color(hex: "#8E8E93"))
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("\(registeredCount) / \(event.maxCount) registered")
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#8E8E93"))
                    Spacer()
                    Button(action: onRegisterTap) {
                        HStack(spacing: 4) {
                            if isRegistered {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 12))
                            }
                            Text(isRegistered ? "Registered" : "Register")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(isRegistered ? Color(hex: "#34C759") : Color(hex: "#E8472A"))
                        .cornerRadius(20)
                    }
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3).fill(Color(hex: "#E0DDD8")).frame(height: 5)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(event.type.color)
                            .frame(width: geo.size.width * min(progress, 1.0), height: 5)
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

#Preview { CalendarView(showSidebar: .constant(false)).environmentObject(AppState.shared) }
