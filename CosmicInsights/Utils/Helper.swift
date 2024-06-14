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
        let heartRate = HKQuantityType(.heartRate)
        let activity = HKQuantityType(.appleMoveTime)
        let activeEnergy = HKQuantityType(.activeEnergyBurned)
        let restingEnergy = HKQuantityType(.basalEnergyBurned)
        let steps = HKQuantityType(.stepCount)
        let walkingRunning = HKQuantityType(.distanceWalkingRunning)
        let exercise = HKQuantityType(.appleExerciseTime)
        let swimming = HKQuantityType(.distanceSwimming)
        let swimmingStrokes = HKQuantityType(.swimmingStrokeCount)
        
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
        let dietaryBiotin = HKQuantityType(.dietaryBiotin)
        let dietaryCalcium = HKQuantityType(.dietaryCalcium)
        let dietaryCarbohydrates = HKQuantityType(.dietaryCarbohydrates)
        let dietaryFiber = HKQuantityType(.dietaryFiber)
        let dietaryIron = HKQuantityType(.dietaryIron)
        let dietaryMagnesium = HKQuantityType(.dietaryMagnesium)
        let dietaryWater = HKQuantityType(.dietaryWater)
        let dietaryZinc = HKQuantityType(.dietaryZinc)
        
        //Respiratory
        let oxygenSaturation = HKQuantityType(.oxygenSaturation)
        let forcedVitalCapacity = HKQuantityType(.forcedVitalCapacity)
        let respiratoryRate = HKQuantityType(.respiratoryRate)
        
        return [heartRate,restingEnergy,activity,activeEnergy,steps,walkingRunning,exercise,swimming,swimmingStrokes,
                bodyTemp,bodyFat,
                doubleSupportTime,groundContactTime,verticalOscillation,runningSpeed,walkingSpeed,
                dietaryBiotin,dietaryCalcium,dietaryCarbohydrates,dietaryFiber,dietaryIron,dietaryMagnesium,dietaryWater,dietaryZinc,
                oxygenSaturation,forcedVitalCapacity,respiratoryRate];
    }
}
