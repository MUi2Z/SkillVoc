import SwiftUI

// MARK: - Notification Model
struct AppNotification: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let time: String
    let type: NotifType
    var isRead: Bool = false

    enum NotifType {
        case game, module, event, achievement, system

        var icon: String {
            switch self {
            case .game:        return "gamecontroller.fill"
            case .module:      return "book.fill"
            case .event:       return "calendar.badge.exclamationmark"
            case .achievement: return "trophy.fill"
            case .system:      return "bell.fill"
            }
        }

        var color: Color {
            switch self {
            case .game:        return Color(hex: "#E8472A")
            case .module:      return Color(hex: "#2196F3")
            case .event:       return Color(hex: "#FF9500")
            case .achievement: return Color(hex: "#F5A623")
            case .system:      return Color(hex: "#34C759")
            }
        }
    }
}

// MARK: - Dummy Notifications
let dummyNotifications: [AppNotification] = [
    AppNotification(
        title: "New Game Available!",
        message: "F1 Pit Stop: Tyre Changer is now available. Tap to play and earn 250 XP!",
        time: "Just now",
        type: .game,
        isRead: false
    ),
    AppNotification(
        title: "Module Reminder",
        message: "You haven't completed 'Engine Systems & Components' yet. Continue where you left off!",
        time: "2 hours ago",
        type: .module,
        isRead: false
    ),
    AppNotification(
        title: "Upcoming Event",
        message: "TVET Skills Workshop is tomorrow at 9:00 AM in Lab A. Don't forget to register!",
        time: "5 hours ago",
        type: .event,
        isRead: false
    ),
    AppNotification(
        title: "Achievement Unlocked!",
        message: "You've earned 'First Module Completed'! Keep going to unlock more achievements.",
        time: "Yesterday",
        type: .achievement,
        isRead: true
    ),
    AppNotification(
        title: "RotateTheRoute Coming Soon",
        message: "Muizz's RotateTheRoute game is almost ready. Stay tuned for the launch!",
        time: "2 days ago",
        type: .game,
        isRead: true
    ),
    AppNotification(
        title: "New Module Added",
        message: "F1 Pit Stop Techniques module has been added under Engineering. Check it out!",
        time: "3 days ago",
        type: .module,
        isRead: true
    ),
    AppNotification(
        title: "Welcome to SkillVoc!",
        message: "Your account is ready. Start learning by exploring Modules or jump straight into Games.",
        time: "1 week ago",
        type: .system,
        isRead: true
    ),
]

// MARK: - Notifications View
struct NotificationsView: View {

    @State private var notifications = dummyNotifications
    @State private var selectedFilter = "All"

    let filters = ["All", "Unread", "Games", "Modules", "Events"]

    var filtered: [AppNotification] {
        switch selectedFilter {
        case "Unread":  return notifications.filter { !$0.isRead }
        case "Games":   return notifications.filter { $0.type == .game }
        case "Modules": return notifications.filter { $0.type == .module }
        case "Events":  return notifications.filter { $0.type == .event }
        default:        return notifications
        }
    }

    var unreadCount: Int { notifications.filter { !$0.isRead }.count }

    var body: some View {
        ZStack {
            Color(hex: "#F5F0EB").ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Filter chips ───────────────────────────
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(filters, id: \.self) { filter in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedFilter = filter
                                }
                            }) {
                                Text(filter)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(selectedFilter == filter ? .white : Color(hex: "#3C3C43"))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedFilter == filter ? Color(hex: "#E8472A") : Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(selectedFilter == filter ? Color.clear : Color(hex: "#E0DDD8"), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 12)

                // ── Notification list ──────────────────────
                if filtered.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "bell.slash")
                            .font(.system(size: 44))
                            .foregroundColor(Color(hex: "#C7C7CC"))
                        Text("No notifications")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#8E8E93"))
                    }
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 10) {
                            ForEach(filtered) { notif in
                                NotificationRow(notification: notif) {
                                    markAsRead(notif)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if unreadCount > 0 {
                    Button(action: { markAllAsRead() }) {
                        Text("Mark all read")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(hex: "#E8472A"))
                    }
                }
            }
        }
    }

    private func markAsRead(_ notif: AppNotification) {
        if let idx = notifications.firstIndex(where: { $0.id == notif.id }) {
            withAnimation { notifications[idx].isRead = true }
        }
    }

    private func markAllAsRead() {
        withAnimation {
            for i in notifications.indices {
                notifications[i].isRead = true
            }
        }
    }
}

// MARK: - Notification Row
struct NotificationRow: View {
    let notification: AppNotification
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 14) {

                // Icon
                ZStack {
                    Circle()
                        .fill(notification.type.color.opacity(0.12))
                        .frame(width: 46, height: 46)
                    Image(systemName: notification.type.icon)
                        .font(.system(size: 20))
                        .foregroundColor(notification.type.color)
                }

                // Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(notification.title)
                            .font(.system(size: 14, weight: notification.isRead ? .regular : .bold))
                            .foregroundColor(Color(hex: "#1C1C1E"))
                            .lineLimit(1)
                        Spacer()
                        if !notification.isRead {
                            Circle()
                                .fill(Color(hex: "#E8472A"))
                                .frame(width: 8, height: 8)
                        }
                    }

                    Text(notification.message)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#6C6C70"))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Text(notification.time)
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#C7C7CC"))
                }
            }
            .padding(14)
            .background(notification.isRead ? Color.white : Color(hex: "#E8472A").opacity(0.04))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(notification.isRead ? Color.clear : Color(hex: "#E8472A").opacity(0.15), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview { NotificationsView() }
