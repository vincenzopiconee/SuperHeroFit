//
//  HealthKitManager.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 17/11/24.
//

import HealthKit

class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    
    func checkAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        let status = HKHealthStore().authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: .stepCount)!)
        completion(status == .sharingAuthorized)
    }

    
    // Richiedi permesso per leggere e scrivere passi e distanza percorsa
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        // I dati che vogliamo leggere e scrivere
        let stepCount = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let distanceWalkingRunning = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        
        // Richiedi autorizzazioni
        healthStore.requestAuthorization(toShare: [stepCount, distanceWalkingRunning], read: [stepCount, distanceWalkingRunning]) { (success, error) in
            if let error = error {
                print("Authorization failed: \(error.localizedDescription)")
            }
            completion(success)
        }
    }
    
    // Leggi i passi effettuati oggi
    func getStepsToday(completion: @escaping (Double) -> Void) {
        let stepCount = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        // Filtro per oggi
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let now = Date()
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)
        
        // Crea la query per leggere i passi
        let query = HKStatisticsQuery(quantityType: stepCount, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        
        healthStore.execute(query)
    }
    
    // Leggi la distanza percorsa oggi
    func getDistanceToday(completion: @escaping (Double) -> Void) {
        let distanceWalkingRunning = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        
        // Filtro per oggi
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let now = Date()
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)
        
        // Crea la query per leggere la distanza
        let query = HKStatisticsQuery(quantityType: distanceWalkingRunning, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.meter()))
        }
        
        healthStore.execute(query)
    }
    
    func getSteps(from startDate: Date, completion: @escaping (Double) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        let sampleType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let query = HKStatisticsQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let steps = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            DispatchQueue.main.async {
                completion(steps)
            }
        }
        healthStore.execute(query)
    }

    func getDistance(from startDate: Date, completion: @escaping (Double) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        let sampleType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        
        let query = HKStatisticsQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let distance = result?.sumQuantity()?.doubleValue(for: .meter()) ?? 0
            DispatchQueue.main.async {
                completion(distance)
            }
        }
        healthStore.execute(query)
    }

    func getDailyStats(startDate: Date, endDate: Date, type: GoalType, completion: @escaping ([DailyProgress]) -> Void) {
        let sampleType = type == .steps ?
            HKQuantityType.quantityType(forIdentifier: .stepCount)! :
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKStatisticsCollectionQuery(
            quantityType: sampleType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startDate,
            intervalComponents: DateComponents(day: 1)
        )
        
        query.initialResultsHandler = { _, results, _ in
            var dailyProgress: [DailyProgress] = []
            results?.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                let value = statistics.sumQuantity()?.doubleValue(for: type == .steps ? .count() : .meter()) ?? 0
                dailyProgress.append(DailyProgress(date: statistics.startDate, value: value))
            }
            DispatchQueue.main.async {
                completion(dailyProgress)
            }
        }
        
        healthStore.execute(query)
    }
    
    
}

