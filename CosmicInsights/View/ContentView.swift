//
//  ContentView.swift
//  CosmicInsights
//
//  Created by Mithun on 12/06/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var healthManager : HealthStoreManager
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                VStack {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 1), content: {
                            ForEach(healthManager.todayHealthValues.sorted{$0.title < $1.title} , id:\.id) { item in
                                
                                NavigationLink(destination: DetailView(healthData: item)) {
                                    HealthCardView(healthData: item)
                                }
                            }
                        }).padding()
                    }
                }
            }
            .navigationTitle("Welcome")
        }
    }
}

#Preview {
    
    ContentView()
}

struct HealthCardView: View {
    
    var healthData : HealthDetailData
    
    var body: some View {
        
        GroupBox {
            
            HStack {
                Text(healthData.title).font(.system(size: 16, weight: .semibold)).foregroundColor(healthData.color)
                Spacer()
                Image(healthData.image).resizable().renderingMode(.template).foregroundColor(healthData.color).frame(width: 30,height: 30)
                
            }
            GroupBox {
                Text(healthData.amount).font(.system(size: 20,weight: .bold)).foregroundColor(.black)
            }
            Text(healthData.subtitle).font(.system(size: 12)).foregroundColor(.gray).padding(.bottom).padding(1)
            
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center).backgroundStyle(Color.white)
        
        
    }
}
