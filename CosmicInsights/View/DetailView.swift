//
//  DetailView.swift
//  CosmicInsights
//
//  Created by Mithun on 12/06/24.
//

import SwiftUI
import Charts
import HealthKit

struct DetailView: View {
    
    @EnvironmentObject var healthManager : HealthStoreManager
    @State private var displayType: DisplayType = .list
    var healthData : HealthDetailData

    private var weekSortHealthDatas: [HealthDetailData] {
        healthManager.weekDatas.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }
    
    var body: some View {
        
        VStack {
            
            if let health = weekSortHealthDatas.first {
                TodayDetailHeaderView(weekHealthData: health, healthData: healthData)
            }
            
            Picker("Selection", selection: $displayType) {
                ForEach(DisplayType.allCases) { displayType in
                    Image(systemName: displayType.icon).tag(displayType)
                }
            }
            .pickerStyle(.segmented)
            
            switch displayType {
            case .list:
                HealthDetailListView(weekHealthDatas: Array(weekSortHealthDatas.dropFirst()))
            case .chart:
                HealthDetailChartView(weekHealthDatas: weekSortHealthDatas)
            case .graph:
                HealthDetailGraphView(weekHealthDatas: weekSortHealthDatas)
            }
        }
        .task {
            
            healthManager.getWeekHealthDatas(type: healthData.healthType)
        }
        .padding()
        .navigationTitle("Details")
    }
}


struct TodayDetailHeaderView: View {
    
    let weekHealthData : HealthDetailData
    var healthData : HealthDetailData
    
    var body: some View {
        VStack {
            Text("\(weekHealthData.amount)")
                .font(.largeTitle)
        }.frame(maxWidth: .infinity, maxHeight: 150)
            .background(healthData.color)
        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
        .overlay(alignment: .topLeading) {
            HStack {
                Image(healthData.image).resizable().frame(width: 20,height: 20)
                    .foregroundStyle(.red)
                Text(healthData.title)
            }.padding()
        }
        .overlay(alignment: .bottomTrailing) {
            Text(weekHealthData.date.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .padding()
        }
    }
}

struct HealthDetailListView: View {
    
    let weekHealthDatas: [HealthDetailData]
    
    var body: some View {
        List(weekHealthDatas , id: \.id) { health in
            HStack {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(isUnder8000(Int(health.amount) ?? 0) ? .red: .green)
                    
                Text("\(health.amount)")
                Spacer()
                Text(health.date.formatted(date: .abbreviated, time: .omitted))
            }
        }.listStyle(.plain)
    }
}

struct HealthDetailChartView: View {
    
    let weekHealthDatas : [HealthDetailData]
    
    var body: some View {
        
        Chart {
            ForEach(weekHealthDatas, id: \.id) { health in
                
                BarMark(
                          x: .value("Date", health.date),
                          y: .value("Amount", health.amount.digitFromString())
                ).foregroundStyle(health.color.gradient)
            }
        }
    }
}

struct HealthDetailGraphView: View {
    
    let weekHealthDatas : [HealthDetailData]
    
    var body: some View {
        
        Chart {
            ForEach(weekHealthDatas, id: \.id) { health in
                
                LineMark(
                          x: .value("Date", health.date),
                          y: .value("Amount", health.amount.digitFromString())
                ).foregroundStyle(health.color.gradient)
            }
        }
    }
}
