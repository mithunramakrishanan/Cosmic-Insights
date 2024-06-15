//
//  Helper.swift
//  CosmicInsights
//
//  Created by Mithun on 13/06/24.
//

import Foundation
import HealthKit

final class Helper {
    
    static let shared = Helper()
    private init() { }

    func getAllHealthTypes()-> Set<HKQuantityType> {
       
        //Activity Details
        let activeEnergy = HKQuantityType(.activeEnergyBurned)
        let steps = HKQuantityType(.stepCount)
        let walkingRunning = HKQuantityType(.distanceWalkingRunning)
        let exercise = HKQuantityType(.appleExerciseTime)
        let swimming = HKQuantityType(.distanceSwimming)
        
        //Body Measurements
        let bodyTemp = HKQuantityType(.bodyTemperature)
        let bodyFat = HKQuantityType(.bodyFatPercentage)
        
        //Mobility
        let doubleSupportTime = HKQuantityType(.walkingDoubleSupportPercentage)
        let groundContactTime = HKQuantityType(.runningGroundContactTime)
        let verticalOscillation = HKQuantityType(.runningVerticalOscillation)
        let runningSpeed = HKQuantityType(.runningStrideLength)
        let walkingSpeed = HKQuantityType(.walkingSpeed)
        
        //Nutrition
        let dietaryCalcium = HKQuantityType(.dietaryCalcium)
        let dietaryFiber = HKQuantityType(.dietaryFiber)
        let dietaryIron = HKQuantityType(.dietaryIron)
        let dietaryWater = HKQuantityType(.dietaryWater)
        let dietaryZinc = HKQuantityType(.dietaryZinc)
        
        //Respiratory
        let oxygenSaturation = HKQuantityType(.oxygenSaturation)
        let forcedVitalCapacity = HKQuantityType(.forcedVitalCapacity)
        let respiratoryRate = HKQuantityType(.respiratoryRate)
        
        //Heart
        let heartRate = HKQuantityType(.heartRate)
        let bloodPressureSystolic = HKQuantityType(.bloodPressureSystolic)
        
        return [heartRate,activeEnergy,steps,walkingRunning,exercise,swimming,
                bodyTemp,bodyFat,
                doubleSupportTime,groundContactTime,verticalOscillation,runningSpeed,walkingSpeed,dietaryCalcium,dietaryFiber,dietaryIron,dietaryWater,dietaryZinc,
                oxygenSaturation,forcedVitalCapacity,respiratoryRate,bloodPressureSystolic];
    }
}
