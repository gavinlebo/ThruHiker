import SwiftUI
import HealthKit

struct ContentView: View {
    @State private var steps: Int = 0
    @State private var distance: Double = 0.0
    private var healthStore: HKHealthStore?

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }

    var body: some View {
        TabView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("thru-hiker!")
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
                requestHealthData()
            }
        }
        .padding()
    }
    
    private func requestHealthData() {
        guard let healthStore = healthStore else { return }

        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!

        let allTypes = Set([stepType, distanceType])

        healthStore.requestAuthorization(toShare: nil, read: allTypes) { success, error in
            if success {
                fetchStepsAndDistance()
            } else if let error = error {
                print("Authorization failed with error: \(error.localizedDescription)")
            }
        }
    }

    private func fetchStepsAndDistance() {
        guard let healthStore = healthStore else { return }

        let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let stepsQuery = HKStatisticsQuery(quantityType: stepsType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            DispatchQueue.main.async {
                if let result = result, let sum = result.sumQuantity() {
                    self.steps = Int(sum.doubleValue(for: HKUnit.count()))
                }
            }
        }

        let distanceQuery = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            DispatchQueue.main.async {
                if let result = result, let sum = result.sumQuantity() {
                    self.distance = sum.doubleValue(for: HKUnit.mile())
                }
            }
        }

        healthStore.execute(stepsQuery)
        healthStore.execute(distanceQuery)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDisplayName("Content View")
        MockContentView().previewDisplayName("Mock Content View")
    }
}

struct MockContentView: View {
    var body: some View {
        Text("Mock Content View")
    }
}
