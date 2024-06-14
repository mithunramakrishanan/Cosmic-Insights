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
    var healthType : HKQuantityType
}