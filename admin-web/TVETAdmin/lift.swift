import SwiftUI

struct SokSokTowerView: View {
    @EnvironmentObject var appState: AppState
    // Track the floor position as a Double so the number rolls smoothly during animation
    @State private var currentFloor: Double = 1.0
    @State private var isMoving = false
    let totalFloors = 6
    let floorHeight: CGFloat = 70
    
    // Plain yellowish orange color
    let yellowishOrange = Color(red: 244/255, green: 162/255, blue: 41/255)
    
    var body: some View {
        ZStack {
            // 1. Background: Light Gray
            Color(.lightGray)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Header with Return Button
                HStack {
                    Button(action: {
                        appState.navigate(to: .dashboard)
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.system(size: 20))
                            Text("Back to Dashboard")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color(red: 0.12, green: 0.16, blue: 0.23))
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
                
                VStack(spacing: 8) {
                    Text("STDCx")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Lift level 🏢")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // 2. The 6-Storey Tower Shaft
                ZStack (alignment: .bottom) {
                    // Outer Structure & Floors
                    VStack(spacing: 0) {
                        ForEach((1...totalFloors).reversed(), id: \.self) { floor in
                            ZStack {
                                Rectangle()
                                    .fill(yellowishOrange)
                                    .frame(width: 140, height: floorHeight)
                                    .border(Color.black.opacity(0.1), width: 0.5)
                                
                                // Floor markings on the side
                                Text("F\(floor)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black.opacity(0.2))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 12)
                            }
                        }
                    }
                    
                    // 3 & 4. Animated Lift with Live Changing Number
                    Rectangle()
                        .fill(Color(.darkGray))
                        .frame(width: 60, height: floorHeight - 12)
                        .cornerRadius(6)
                        .overlay(
                            // Uses the Animatable View to update the number mid-transit
                            LiftFloorDisplay(floor: currentFloor)
                                .font(.system(.headline, design: .monospaced))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        )
                        .shadow(radius: 4)
                        // Adjust alignment offset dynamically based on the current floor float value
                        .offset(y: -CGFloat(currentFloor - 1) * floorHeight - 6)
                }
                .frame(width: 140, height: floorHeight * CGFloat(totalFloors))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                // Interactive Button
                Button(action: triggerSokSokMovement) {
                    Text(isMoving ? "Moving..." : "Sok Sok! (Random Floor)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 240)
                        .background(isMoving ? Color.gray : Color.orange)
                        .cornerRadius(12)
                        .shadow(radius: isMoving ? 0 : 4)
                }
                .disabled(isMoving)
            }
            .padding(.top, 20)
        }
    }
    
    // Logic to calculate random floor and animate the lift
    private func triggerSokSokMovement() {
        let randomFloor = Double(Int.random(in: 1...totalFloors))
        
        // Ensure it doesn't pick the exact same floor it's already on
        if randomFloor == currentFloor {
            triggerSokSokMovement()
            return
        }
        
        isMoving = true
        
        // Calculate dynamic travel duration based on how many floors it passes
        let distance = abs(randomFloor - currentFloor)
        let travelDuration = distance * 0.5
        
        withAnimation(.easeInOut(duration: travelDuration)) {
            currentFloor = randomFloor
        }
        
        // Re-enable button after travel completes
        DispatchQueue.main.asyncAfter(deadline: .now() + travelDuration) {
            isMoving = false
        }
    }
}

// 5. Custom View designed to continuously update the text floor integer mid-animation
struct LiftFloorDisplay: View, Animatable {
    var floor: Double
    // Tells SwiftUI to interpolate this value over the course of the animation timeline
    var animatableData: Double {
        get { floor }
        set { floor = newValue }
    }
    
    var body: some View {
        // Rounds the changing double to the nearest whole integer
        Text("\(Int(round(floor)))")
    }
}

// Preview Provider
#Preview {
    SokSokTowerView()
        .environmentObject(AppState())
}
