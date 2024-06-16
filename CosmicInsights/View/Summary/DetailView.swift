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
    @State private var daysTab: String = "7 Days"
    var healthData : HealthDetailData
    private var weekSortHealthDatas: [HealthDetailData] {
        healthManager.weekDatas.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }
    
    var body: some View {
        
        VStack {
            
            TodayDetailHeaderView(count: "\(weekSortHealthDatas.map{$0.amount.digitFromString()}.reduce(0, { $0 + $1 })) \( weekSortHealthDatas.last?.amount.letters ?? "")", healthData: healthData, selectedDay: daysTab)
    
            HStack {
                Text("Views")
                Picker("", selection: $daysTab) {
                    
                    Text("2 Days").tag("2 Days")
                    Text("Week").tag("Week")
                    Text("Month").tag("Month")
                }
                .pickerStyle(.segmented).padding(.leading,80)
            }.onChange(of: daysTab) { oldState, newState in
                    displayType = .list
                    healthManager.getWeekHealthDatas(type: healthData.healthType, dateRange: newState)
            }
            
            Picker("Selection", selection: $displayType) {
                ForEach(DisplayType.allCases) { displayType in
                    Image(systemName: displayType.icon).tag(displayType)
                }
            }
            .pickerStyle(.segmented)
            
            switch displayType {
            case .list:
                HealthDetailListView(weekHealthDatas: Array(weekSortHealthDatas))
            case .chart:
                HealthDetailChartView(weekHealthDatas: weekSortHealthDatas, daysTab: daysTab)
            case .graph:
                HealthDetailGraphView(weekHealthDatas: weekSortHealthDatas, daysTab: daysTab)
            case .pie:
                HealthDetailPieChartView(weekHealthDatas: weekSortHealthDatas, daysTab: daysTab)
            }
        }
        .task {
            
            daysTab = "2 Days"
            healthManager.getWeekHealthDatas(type: healthData.healthType, dateRange: "2 Days")
            healthManager.showTabbar(show: false)
        }.onAppear {
        }
        .padding()
        .navigationTitle("Analytics").navigationBarTitleDisplayMode(.inline)
    }
}


struct TodayDetailHeaderView: View {
    
    let count : String
    var healthData : HealthDetailData
    var selectedDay : String
    var body: some View {
        VStack {
            Text("\(count)")
                .font(.system(size: 35,weight: .bold)).foregroundStyle(.white).padding(.top,20)
            
            if selectedDay == "2 Days" {
                Text("in two days")
                    .font(.system(size: 18,weight: .regular)).foregroundStyle(.white)
            }
            else if selectedDay == "Week" {
                Text("in 7 days")
                    .font(.system(size: 18,weight: .regular)).foregroundStyle(.white)
            }
            else {
                Text("in 2 months")
                    .font(.system(size: 18,weight: .regular)).foregroundStyle(.white)
            }

        }.frame(maxWidth: .infinity, maxHeight: 150)
            .background(healthData.color)
        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
        .overlay(alignment: .topLeading) {
            HStack {
                Image(healthData.image).resizable().renderingMode(.template).foregroundStyle(.white).frame(width: 20,height: 20)
                Text(healthData.title).font(.system(size: 16,weight: .semibold)).foregroundStyle(.white)
            }.padding()
        }.modifier(HealthCardModifier())
    }
}

struct HealthDetailListView: View {
    
    let weekHealthDatas: [HealthDetailData]
    
    var body: some View {
        List(weekHealthDatas , id: \.id) { health in
            HStack {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(health.color)
                    
                Text("\(health.amount)").font(.system(size: 16,weight: .semibold)).foregroundStyle(.black)
                Spacer()
                Text(checkSameDate(date:health.dateString) ? "\("Today at") \(health.timeString)" : "\(health.dateString) \(health.timeString)").font(.system(size: 15,weight: .regular)).foregroundStyle(.gray)
            }
        }.listStyle(.plain)
    }
}

struct HealthDetailChartView: View {
    
    @State var weekHealthDatas : [HealthDetailData]
    var daysTab : String
    var body: some View {
        
        Chart(weekHealthDatas.sorted{$0.date < $1.date}, id: \.id) { health in
                BarMark(
                    x: .value("Date", daysTab == "Month" ? health.date.dayOfMonth() ?? "" : health.date.dayOfWeek() ?? ""),
                    y: .value("Amount",health.animate ? health.amount.digitFromString() : 0)
                ).foregroundStyle(health.color).annotation(position: .overlay, alignment: .top) {
                    
                }
            
        }.chartYScale(domain: 0...(((weekHealthDatas.map{$0.chartDigit}.max() ?? 0)) )).onAppear {
            
            // Chart update animation
            for (index,_) in weekHealthDatas.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                    withAnimation(.interactiveSpring(response: 0.8,dampingFraction: 0.8,blendDuration: 0.8)) {
                        weekHealthDatas[index].animate = true
                    }
                }
            }
        }
    }
}

struct HealthDetailGraphView: View {
    
    @State var weekHealthDatas : [HealthDetailData]
    var daysTab : String
    var body: some View {
        
        Chart {
            ForEach(weekHealthDatas.sorted{$0.date < $1.date}, id: \.id) { health in
                LineMark(
                    x: .value("Date", daysTab == "Month" ? health.date.dayOfMonth() ?? "" : health.date.dayOfWeek() ?? ""),
                    y: .value("Amount",health.amount.digitFromString())
                ).foregroundStyle(health.color)
            }
        }.chartYScale(domain: 0...(weekHealthDatas.map{$0.chartDigit}.max() ?? 1000)).onAppear {
            
        }
    }
}

struct HealthDetailPieChartView: View {
    
    @State var weekHealthDatas : [HealthDetailData]
    var daysTab : String
    
    var body: some View {
        Chart(weekHealthDatas.sorted{$0.date < $1.date}, id: \.id) { health in
          SectorMark(
            angle: .value("Amount",health.animate ? health.amount.digitFromString() : 0),
            innerRadius: .ratio(0.6),
            angularInset: 2
          ).cornerRadius(5)
          .foregroundStyle(by: .value("Date", daysTab == "Month" ? health.date.dayOfMonth() ?? "" : health.date.dayOfWeek() ?? ""))
        }
        .scaledToFit().onAppear {
            
            // Chart update animation
            for (index,_) in weekHealthDatas.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                    withAnimation(.interactiveSpring(response: 0.8,dampingFraction: 0.8,blendDuration: 0.8)) {
                        weekHealthDatas[index].animate = true
                    }
                }
            }
        }
      }

}


