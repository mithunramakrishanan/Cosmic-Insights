//
//  HealthStoreManager.swift
//  CosmicInsights
//
//  Created by Mithun on 12/06/24.
//

import Foundation
import SwiftUI
import HealthKit

class HealthStoreManager : ObservableObject {
    
    let healthStore = HKHealthStore()
    @Published var todayHealthValues : [HealthDetailData] = []
    @Published var weekDatas : [HealthDetailData] = []
    let dispatchGroupDay = DispatchGroup()
    let dispatchGroupWeek = DispatchGroup()
    var healthTypes = Set<HKQuantityType>()
     
    //Init class with getting health datas
    init() {
        healthTypes = Helper.shared.getAllHealthTypes()
        healthStore.requestAuthorization(toShare: [], read: healthTypes) { isSuccess, error in
            if isSuccess {
                self.todayHealthDetails()
            }
        }
    }
    
    //Current day datas
    func todayHealthDetails() {
        
        var aHealthDataArray : [HealthDetailData] = []
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        for types in healthTypes {
        
            self.dispatchGroupDay.enter()
            let query =  HKSampleQuery(sampleType: types, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: []) { _, result, error in
                guard let result = result,
                      let data = result.first as? HKQuantitySample else {
                    var health = types.getHeaderDetails()
                    health.amount = "No data"
                    aHealthDataArray.append(health)
                    self.dispatchGroupDay.leave()
                    return
                }
                let quantity = data.quantity
                print(quantity)
                var health = data.quantityType.getHeaderDetails()
                health.amount = "\(quantity)"
                aHealthDataArray.append(health)
                self.dispatchGroupDay.leave()
                
            }
            healthStore.execute(query)
        }
        self.dispatchGroupDay.notify(queue: .main) {
            
            print(aHealthDataArray)
            aHealthDataArray = aHealthDataArray.sorted { $0.title < $1.title }
            self.todayHealthValues = aHealthDataArray
        }
    }
    
    //One week datas
    func getWeekHealthDatas(type : HKQuantityType) {
        
        var aHealthDataArray : [HealthDetailData] = []
        let today = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: today)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: today)
        self.weekDatas.removeAll()
        self.dispatchGroupWeek.enter()
        let query =  HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: []) { _, result, error in
            guard let result = result else {
                return
            }
            for aValue in result {
                guard let data = aValue as? HKQuantitySample else {
                    print("error : \(String(describing: error?.localizedDescription))")
                    return
                }
                let quantity = data.quantity
                var health = data.quantityType.getHeaderDetails()
                health.amount = "\(quantity)"
                health.date = aValue.startDate
                aHealthDataArray.append(health)
                
            }
            self.dispatchGroupWeek.leave()
        }
        healthStore.execute(query)
        
        self.dispatchGroupWeek.notify(queue: .main) {
            print(aHealthDataArray)
            self.weekDatas = aHealthDataArray
        }
    }
}


