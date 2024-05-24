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
    @Published var PCTdistanceWalked: Double = 0.0
    @Published var JMTdistanceWalked: Double = 0.0
    @Published var ATdistanceWalked: Double = 0.0
    @Published var stepsWalked: Int = 0
    @Published var dailyAverageDistance: Double = 0.0
    
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
    func queryDistanceWalked(from startDate: Date, route: String) {
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
            
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.main.async {
                if route == "Pacific Crest Trail"{
                    self.PCTdistanceWalked = roundedDistance
                }
                if route == "Appalachian Trail"{
                    self.ATdistanceWalked = roundedDistance
                }
                if route == "John Muir Trail"{
                    self.JMTdistanceWalked = roundedDistance
                }
                //self.distanceWalked = roundedDistance // Update the published property
                group.leave()
            }
        }

        healthStore.execute(query)
    }
//    func queryDistanceWalked(from startDate: Date, completion: @escaping (Double) -> ()) {
//        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
//            print("Distance walking/running data not available.")
//            return
//        }
//
//        // Define the unit as miles
//        let milesUnit = HKUnit.mile()
//
//        // Create a predicate to filter the data
//        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
//
//        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] (_, result, error) in
//            guard let self = self else { return }
//
//            if let error = error {
//                print("Error querying distance walked: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    completion(0) // Return 0 or handle error appropriately
//                }
//                return
//            }
//
//            guard let result = result, let sum = result.sumQuantity() else {
//                print("Failed to fetch results or sum quantity")
//                DispatchQueue.main.async {
//                    completion(0) // Return 0 or handle the case where no data is found
//                }
//                return
//            }
//
//            // Convert distance to miles
//            let distanceInMiles = sum.doubleValue(for: milesUnit)
//            let roundedDistance = self.roundToValidDistance(distanceInMiles)
//
//            DispatchQueue.main.async {
//                completion(roundedDistance) // Call completion handler with the final distance
//            }
//        }
//
//        healthStore.execute(query)
//    }
    
    
    
    // queries HeathKit for user steps walked
    // opitnally can be from a specified start date
    func calculateDailyAverageDistance(from startDate: Date) {
            guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
                print("Distance walking/running data not available.")
                return
            }

            let milesUnit = HKUnit.mile()
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

            let query = HKStatisticsCollectionQuery(quantityType: distanceType,
                                                    quantitySamplePredicate: predicate,
                                                    options: .cumulativeSum,
                                                    anchorDate: startDate,
                                                    intervalComponents: DateComponents(day: 1))

            query.initialResultsHandler = { [weak self] query, results, error in
                guard let self = self else { return }
                guard let results = results else {
                    if let error = error {
                        print("Error querying daily average distance: \(error.localizedDescription)")
                    }
                    return
                }

                var totalDistance: Double = 0.0
                var daysCount: Int = 0

                results.enumerateStatistics(from: startDate, to: Date()) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        let distance = quantity.doubleValue(for: milesUnit)
                        totalDistance += distance
                        daysCount += 1
                    }
                }

                let averageDistance = daysCount > 0 ? totalDistance / Double(daysCount) : 0.0
                DispatchQueue.main.async {
                    self.dailyAverageDistance = self.roundToValidDistance(averageDistance)
                }
            }

            healthStore.execute(query)
        }

        func queryStepsWalked() {
            guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
                print("Step count data not available.")
                return
            }
            
            let startDate = Calendar.current.date(byAdding: .month, value: -6, to: Date())
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
                    self.stepsWalked = steps
                }
            }
            
            healthStore.execute(query)
        }
}
