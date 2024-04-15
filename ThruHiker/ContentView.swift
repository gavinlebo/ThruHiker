import SwiftUI
import HealthKit

struct ContentView: View {
    @State private var steps: Int = 0
    @State private var distance: Double = 0.0
    
    var body: some View {
        TabView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("thru-hiker!")
                Text("TEST")
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            VStack {
                Text("Steps taken: \(steps)")
                Text("Distance: \(distance, specifier: "%.2f") miles")
            }
            .tabItem {
                Label("Health", systemImage: "heart.text.square")
            }
            .onAppear {
                // Fetch health data when this tab is shown
                requestHealthData()
            }
        }
        .padding()
    }
    
    // HealthKit setup and data request here
    private func requestHealthData() {
        // Make sure HealthKit is set up and authorized before proceeding
        // Fetch steps and distance data and update state variables
    }
}

// Preview struct
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

