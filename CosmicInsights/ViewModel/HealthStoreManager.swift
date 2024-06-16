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
    @Published var showTabbar : Bool = true
    @Published var loginSuccess : Bool = false
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
            else {
                
                //Only reading data, HealthKit does not provide any information about whether or not the user has granted permissions to access the required data. Apple has clearly mentioned this in their documentation
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
                      let data = result.last as? HKQuantitySample else {
                    var health = types.getHeaderDetails()
                    health.amount = "-----"
                    aHealthDataArray.append(health)
                    self.dispatchGroupDay.leave()
                    return
                }
                let quantity = data.quantity
                var health = data.quantityType.getHeaderDetails()
                health.amount = "\(quantity)"
                health.chartDigit = health.amount.digitFromString()
                health.dateString = (result.last?.startDate.getDateFormat(format: "dd-MM-YY"))!
                health.timeString = (result.last?.startDate.getDateFormat(format: "hh:mm a"))!
                aHealthDataArray.append(health)
                self.dispatchGroupDay.leave()
                
            }
            healthStore.execute(query)
        }
        self.dispatchGroupDay.notify(queue: .main) {
            
            aHealthDataArray = aHealthDataArray.sorted { $0.title < $1.title }
            self.todayHealthValues = aHealthDataArray
        }
    }
    
    func getFilteredData(type : HeathHeaderTypes)-> [HealthDetailData] {
        return self.todayHealthValues.filter { $0.type == type}
    }
    
    //One week datas
    func getWeekHealthDatas(type : HKQuantityType, dateRange : String) {
        
        var aHealthDataArray : [HealthDetailData] = []
        let today = Date()
        
        var startDate = Date()
        
        if dateRange == "2 Days"{
            
            startDate = Calendar.current.date(byAdding: .day, value: -2, to: today) ?? Date()
        }
        else if dateRange == "Week"{
            
            startDate = Calendar.current.date(byAdding: .day, value: -6, to: today) ?? Date()
        }
        else if dateRange == "Month"{
            
            startDate = Calendar.current.date(byAdding: .month, value: -1, to: today) ?? Date()
        }
    
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
                health.dateString = aValue.startDate.getDateFormat(format: "dd-MM-YY")
                health.timeString = aValue.startDate.getDateFormat(format: "hh:mm a")
                
                var calculateHighest = 0
                //Logic to get highest chat value for the day
                if dateRange == "Month"{
                    
                    calculateHighest = aHealthDataArray.filter{$0.date.dayOfMonth() == health.date.dayOfMonth()}.map {$0.amount.digitFromString()}.reduce(0, { $0 + $1 }) + health.amount.digitFromString()
                }
                else {
                    
                    calculateHighest = aHealthDataArray.filter{$0.dateString == health.dateString}.map {$0.amount.digitFromString()}.reduce(0, { $0 + $1 }) + health.amount.digitFromString()
                }
                health.chartDigit = calculateHighest
                aHealthDataArray.append(health)
            }
            self.dispatchGroupWeek.leave()
        }
        healthStore.execute(query)
        
        self.dispatchGroupWeek.notify(queue: .main) {
            self.weekDatas = aHealthDataArray
        }
    }
    
    func getCategoriesDetails()->[HealthCategoriesData] {
        
        var aCategoryArray : [HealthCategoriesData] = []
        for category in HeathHeaderTypes.allCases {
            var healthCategory = HealthCategoriesData(title: category.rawValue, image: "", type: category, color: .clear)
           
            if category.rawValue == "Activity" {
                healthCategory.image = "category_Activity"
                healthCategory.color = .activityColor
            }
            else if category.rawValue == "Body Measurements" {
                healthCategory.image = "category_body"
                healthCategory.color = .bodyMeasureColor
            }
            else if category.rawValue == "Mobility" {
                healthCategory.image = "runningSpeed"
                healthCategory.color = .mobilityColor
            }
            else if category.rawValue == "Nutrition" {
                healthCategory.image = "category_Nutrition"
                healthCategory.color = .nutritionColor
            }
            else if category.rawValue == "Heart"  {
                healthCategory.image = "heartRate"
                healthCategory.color = .heartColor
            }
            else {
                healthCategory.image = "respiratoryRate"
                healthCategory.color = .respiratoryColor
            }

            aCategoryArray.append(healthCategory)
            
        }
        return aCategoryArray
    }
    
    func showTabbar(show : Bool) {
        showTabbar = show
    }
}


