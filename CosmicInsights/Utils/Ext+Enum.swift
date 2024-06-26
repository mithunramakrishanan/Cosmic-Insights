//
//  Ext+Enum.swift
//  CosmicInsights
//
//  Created by Mithun on 13/06/24.
//

import Foundation
import HealthKit
import SwiftUI

// Getting digits from string to show chart values
extension String {
    func digitFromString()-> Int {
        let stringArray = self.components(separatedBy: CharacterSet.decimalDigits.inverted)
        for item in stringArray {
            if let number = Int(item) {
                return number
            }
        }
        return 0
    }
    
    var letters: String {
        return self.components(separatedBy: CharacterSet.decimalDigits).joined()
    }
}

extension Date {
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    
    func dayOfMonth() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self).capitalized
    }
    
    func getDateFormat(format : String)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

//Making extension for health type to arrange data
extension HKQuantityType {
    
    func getHeaderDetails()-> HealthDetailData {
        
        //ACTIVITY
        if self == HKQuantityType(.activeEnergyBurned) {
            
            return HealthDetailData(title: "Active Energy Burned", subtitle: "Individuals should strive to burn at least 2,000 calories per week if the ultimate goal is to promote and sustain weight loss", amount: "", image: "activeEnergyBurned", type: .ACTIVITY, color: Color.activityColor, date: Date(), healthType: HKQuantityType(.activeEnergyBurned))
            
        }
        else if self == HKQuantityType(.stepCount)  {
            
            return HealthDetailData(title: "Step Count", subtitle: "Most adults should aim for 10,000 steps per day, with fewer than 5,000 steps being a sign of a sedentary lifestyle", amount: "", image: "stepCount", type: .ACTIVITY, color: Color.activityColor, date: Date(), healthType: HKQuantityType(.stepCount))
            
        }
        else if self == HKQuantityType(.distanceWalkingRunning)  {
            
            return HealthDetailData(title: "Distance Walking Running", subtitle: "As a result, the CDC recommend that most adults aim for 10,000 steps per day, this is the equivalent of 5 miles ", amount: "", image: "walkingDoubleSupportPercentage", type: .ACTIVITY, color: Color.activityColor, date: Date(), healthType: HKQuantityType(.distanceWalkingRunning))
            
        }
        else if self == HKQuantityType(.appleExerciseTime)  {
            
            return HealthDetailData(title: "Apple Exercise Time", subtitle: "As a general goal, aim for at least 30 minutes of moderate physical activity every day", amount: "", image: "appleExerciseTime", type: .ACTIVITY, color: Color.activityColor, date: Date(), healthType: HKQuantityType(.appleExerciseTime))
            
        }
        else if self == HKQuantityType(.distanceSwimming)  {
            
            return HealthDetailData(title: "Distance Swimming", subtitle: "A good target for intermediate swimmers is to swim 1 to 2 kilometers (0.6 to 1.2 miles) per session, three to four times per week", amount: "", image: "distanceSwimming", type: .ACTIVITY, color: Color.activityColor, date: Date(), healthType: HKQuantityType(.distanceSwimming))
            
        }
        
        // BLOOD MEASUREMENTS
        else if self == HKQuantityType(.bodyTemperature)  {
            
            return HealthDetailData(title: "Body Temperature", subtitle: "Normal body temperature varies by person, age, activity, and time of day. The average normal body temperature is generally accepted as 98.6°F (37°C)", amount: "", image: "bodyTemperature", type: .BODYMEASURE, color: Color.bodyMeasureColor, date: Date(), healthType: HKQuantityType(.bodyTemperature))
            
        }
        else if self == HKQuantityType(.bodyFatPercentage)  {
            
            return HealthDetailData(title: "Body Fat Percentage", subtitle: "Best body fat percentages averaged between 12% and 20% for men and 20% and 30% for women", amount: "", image: "bodyFatPercentage", type: .BODYMEASURE, color: Color.bodyMeasureColor, date: Date(), healthType: HKQuantityType(.bodyFatPercentage))
            
        }
        
        //MOBILITY
        else if self == HKQuantityType(.walkingDoubleSupportPercentage)  {
            
            return HealthDetailData(title: "Walking Double Support Percentage", subtitle: "An average and healthy walk is typically between 28 and 40%", amount: "", image: "walkingDoubleSupportPercentage", type: .MOBILITY, color: Color.mobilityColor, date: Date(), healthType: HKQuantityType(.walkingDoubleSupportPercentage))
        }
        else if self == HKQuantityType(.runningGroundContactTime)  {
            
            return HealthDetailData(title: "Running Ground Contact Time", subtitle: "For many runners, ground contact time balance tends to deviate further from 50–50 when running up or down hills", amount: "", image: "runningGroundContactTime", type: .MOBILITY, color: Color.mobilityColor, date: Date(), healthType: HKQuantityType(.runningGroundContactTime))
            
        }
        else if self == HKQuantityType(.runningVerticalOscillation)  {
            
            return HealthDetailData(title: "Running Vertical Oscillation", subtitle: "Most runners oscillate somewhere between 6 to 13cm. It takes energy to move the weight of your body up and down, so the lower your VO, the better", amount: "", image: "runningSpeed", type: .MOBILITY, color: Color.mobilityColor, date: Date(), healthType: HKQuantityType(.runningVerticalOscillation))
            
        }
        else if self == HKQuantityType(.runningStrideLength) {
            
            return HealthDetailData(title: "Running Stride Length", subtitle: "the average stride length would be approximately 5 feet (60 inches)", amount: "", image: "runningSpeed", type: .MOBILITY, color: Color.mobilityColor, date: Date(), healthType: HKQuantityType(.runningSpeed))
            
        }
        else if self == HKQuantityType(.walkingSpeed)  {
            
            return HealthDetailData(title: "Walking Speed", subtitle: "Many people tend to walk at about 1.42 metres per second (5.1 km/h; 3.2 mph; 4.7 ft/s)", amount: "", image: "walkingDoubleSupportPercentage", type: .MOBILITY, color: Color.mobilityColor, date: Date(), healthType: HKQuantityType(.walkingSpeed))
            
        }
        
        //NUTRITION
        else if self == HKQuantityType(.dietaryCalcium)  {
            
            return HealthDetailData(title: "Calcium", subtitle: "Normal blood calcium results in adults are: Total blood calcium: 8.5 to 10.5 milligrams per deciliter (mg/dL)", amount: "", image: "dietaryCalcium", type: .NUTRITION, color: Color.nutritionColor, date: Date(), healthType: HKQuantityType(.dietaryCalcium))
            
        }
        else if self == HKQuantityType(.dietaryFiber)  {
            
            return HealthDetailData(title: "Fiber", subtitle: "Total dietary fiber intake should be 25 to 30 grams a day from food, not supplements", amount: "", image: "dietaryFiber", type: .NUTRITION, color: Color.nutritionColor, date: Date(), healthType: HKQuantityType(.dietaryFiber))
            
        }
        else if self == HKQuantityType(.dietaryIron)  {
            
            return HealthDetailData(title: "Iron", subtitle: "Normal value range is: Iron: 60 to 170 micrograms per deciliter (mcg/dL)", amount: "", image: "dietaryIron", type: .NUTRITION, color: Color.nutritionColor, date: Date(), healthType: HKQuantityType(.dietaryIron))
            
        }
        else if self == HKQuantityType(.dietaryWater)  {
            
            return HealthDetailData(title: "Water", subtitle: "You're usually in a healthy range if your body water percentage is more than 50 percent", amount: "", image: "dietaryWater", type: .NUTRITION, color: Color.nutritionColor, date: Date(), healthType: HKQuantityType(.dietaryWater))
            
        }
        else if self == HKQuantityType(.dietaryZinc)  {
            
            return HealthDetailData(title: "Zinc", subtitle: "In healthy people, the amount of zinc in serum or plasma is 80 to 120 mcg/dL (12 to 18 mcmol/L)", amount: "", image: "dietaryZinc", type: .NUTRITION, color: Color.nutritionColor, date: Date(), healthType: HKQuantityType(.dietaryZinc))
            
        }
        //RESPIRATORY
        else if self == HKQuantityType(.oxygenSaturation)  {
            
            return HealthDetailData(title: "Oxygen Saturation", subtitle: "A normal level of oxygen is usually 95% or higher", amount: "", image: "oxygenSaturation", type: .RESPIRATORY, color: Color.respiratoryColor, date: Date(), healthType: HKQuantityType(.oxygenSaturation))
            
        }
        else if self == HKQuantityType(.forcedVitalCapacity)  {
            
            return HealthDetailData(title: "Forced Vital Capacity", subtitle: "The maximum amount of air you can forcibly exhale from your lungs after fully inhaling. It is about 80 percent of total capacity", amount: "", image: "oxygenSaturation", type: .RESPIRATORY, color: Color.respiratoryColor, date: Date(), healthType: HKQuantityType(.forcedVitalCapacity))
            
        }
        else if self == HKQuantityType(.respiratoryRate)  {
            
            return HealthDetailData(title: "Respiratory Rate", subtitle: "Normal respiration rates for an adult person at rest range from 12 to 16 breaths per minute.", amount: "", image: "respiratoryRate", type: .RESPIRATORY, color: Color.respiratoryColor, date: Date(), healthType: HKQuantityType(.respiratoryRate))
            
        }
        //HEART
        else if self == HKQuantityType(.heartRate) {
            
            return HealthDetailData(title: "Heart Rate", subtitle: "A normal resting heart rate for adults ranges from 60 to 100 beats per minute", amount: "", image: "heartRate", type: .HEART, color: Color.activityColor, date: Date(), healthType: HKQuantityType(.heartRate))
        }
        else if self == HKQuantityType(.bloodPressureSystolic) {
            
            return HealthDetailData(title: "Blood Pressure Systolic", subtitle: "Typical blood pressure as below 120 mm Hg systolic", amount: "", image: "bloodPressureSystolic", type: .HEART, color: Color.activityColor, date: Date(), healthType: HKQuantityType(.bloodPressureSystolic))
        }
        else {
            
            return HealthDetailData(title: "", subtitle: "", amount: "", image: "", type: .ACTIVITY, color: Color.respiratoryColor, date: Date(), healthType: HKQuantityType(.heartRate))
        }
        
    }
}

extension Color {
    static let activityColor = Color.red
    static let bodyMeasureColor = Color(red: 127, green: 0, blue: 255)
    static let mobilityColor = Color.orange
    static let nutritionColor = Color.green
    static let heartColor = Color.red
    static let respiratoryColor = Color.blue
}

enum HeathHeaderTypes:String,CaseIterable {
    case ACTIVITY = "Activity"
    case BODYMEASURE = "Body Measurements"
    case MOBILITY = "Mobility"
    case NUTRITION = "Nutrition"
    case HEART = "Heart"
    case RESPIRATORY = "Respiratory"
}

enum DisplayType: Int, Identifiable, CaseIterable {
    case list
    case chart
    case graph
    case pie
    
    var id: Int {
        rawValue
    }
}

extension DisplayType {
    var icon: String {
        switch self {
            case .list:
                return "list.bullet"
            case .chart:
                return "chart.bar"
            case .graph:
            return "chart.line.uptrend.xyaxis"
            case .pie:
            return "chart.pie.fill"
        }
    }
}

//Card modifier
struct HealthCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
    }
    
}

func checkSameDate(date : String)-> Bool {
    let currentDate = Date().getDateFormat(format: "dd-MM-YY")
    if date == currentDate{
        return true
    }
    else {
        return false
    }
}
