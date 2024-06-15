//
//  HealthModel.swift
//  CosmicInsights
//
//  Created by Mithun on 12/06/24.
//

import Foundation
import SwiftUI
import HealthKit

struct HealthDetailData {
    let id = UUID()
    var title : String
    var subtitle : String
    var amount : String
    var image : String
    var type : HeathHeaderTypes
    var color : Color
    var date : Date
    var dateString : String = ""
    var timeString : String = ""
    var healthType : HKQuantityType
    var animate : Bool = false
    var chartDigit : Int = 0
}

struct HealthCategoriesData {
    let id = UUID()
    var title : String
    var image : String
    var type : HeathHeaderTypes
    var color : Color
    var animate : Bool = false
}
