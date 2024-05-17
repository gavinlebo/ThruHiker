//
//  ThruHikerApp.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/9/24.
//
import SwiftUI
import HealthKit

// HealthKitManager to handle HealthKit setup and permissions
class HealthKitManager: ObservableObject {
    private var healthStore = HKHealthStore()
    
    // Store the distance and steps walked within the health kit manager
    @Published var distanceWalked: Double = 0.0
    @Published var stepsWalked: Int = 0
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            requestHealthKitPermission()
        }
    }
    
    func requestHealthKitPermission() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        
        let typesToRead: Set<HKObjectType> = [stepType, distanceType]

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if !success {
                print("HealthKit authorization denied: \(String(describing: error))")
                return
            }
            print("HealthKit permission granted.")
        }
    }
    // valid distances (in miles) are stored only in half and whole miles
    // this function rounds the user healthkit distance walked into the nearest valid distance
    func roundToValidDistance(_ value: Double) -> Double {
        let roundedValue = value.rounded()
        
        // If the rounded value is already a whole number, return it
        if roundedValue.truncatingRemainder(dividingBy: 1) == 0 {
            return roundedValue
        }
        
        // If the rounded value is within 0.25 of the next whole number, round up to the next whole number
        if value.truncatingRemainder(dividingBy: 1) >= 0.75 {
            return roundedValue + 1.0
        }
        
        // If the rounded value is within 0.25 of the previous whole number, round down to the previous whole number
        if value.truncatingRemainder(dividingBy: 1) <= 0.25 {
            return roundedValue
        }
        
        // Otherwise, round to the nearest 0.5
        return (roundedValue * 2).rounded() / 2
    }

    // queries HeathKit for user distance walked from a specified start date
    // Thinking usage by storing a start date with route, passing start date through in MapView.swift
    func queryDistanceWalked(from startDate: Date) {
        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            print("Distance walking/running data not available.")
            return
        }

        // Define the unit as miles
        let milesUnit = HKUnit.mile()

        // Create a predicate to filter the data
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] (_, result, error) in
            guard let self = self else { return }

            guard let result = result, let sum = result.sumQuantity() else {
                if let error = error {
                    print("Error querying distance walked: \(error.localizedDescription)")
                }
                return
            }

            // Convert distance to miles
            let distanceInMiles = sum.doubleValue(for: milesUnit)
            let roundedDistance = roundToValidDistance(distanceInMiles)

            DispatchQueue.main.async {
                self.distanceWalked = roundedDistance // Update the published property
            }
        }

        healthStore.execute(query)
    }

    // queries HeathKit for user steps walked
    // opitnally can be from a specified start date
    func queryStepsWalked() {
        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            print("Step count data not available.")
            return
        }
        
        let startDate = Calendar.current.date(byAdding: .month, value: -6, to: Date()) // Start date 6 months ago
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] _, result, error in
            guard let self = self else { return }
            
            guard let result = result, let sum = result.sumQuantity() else {
                if let error = error {
                    print("Error querying steps walked: \(error.localizedDescription)")
                }
                return
            }
            
            let steps = Int(sum.doubleValue(for: .count()))
            DispatchQueue.main.async {
                self.stepsWalked = steps // Update the published property
            }
        }
        
        healthStore.execute(query)
    }
    
    func queryStepsFromPastSixMonths() {
        // Create the step count type.
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            fatalError("Step Count type is no longer available in HealthKit")
        }
        
        // Set the date range to the past six months.
        let endDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -6
        guard let startDate = Calendar.current.date(byAdding: dateComponents, to: endDate) else {
            fatalError("Failed to calculate start date.")
        }
        
        // Create the predicate to filter the data.
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        // Create the query to sum the steps over the given time range.
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, statistics, error in
            guard let statistics = statistics, let sum = statistics.sumQuantity() else {
                // Handle any errors or the case where there is no data.
                return
            }
            
            let steps = sum.doubleValue(for: HKUnit.count())
            // Use the steps data here, make sure you handle UI updates on the main thread.
            DispatchQueue.main.async {
                // Update any UI elements with the step count here.
                print("Steps taken in the past six months: \(steps)")
            }
        }
        
        // Execute the query.
        healthStore.execute(query)
    }
}
