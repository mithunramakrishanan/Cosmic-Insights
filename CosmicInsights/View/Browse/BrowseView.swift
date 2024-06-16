//
//  BrowseView.swift
//  CosmicInsights
//
//  Created by Mithun on 12/06/24.
//

import SwiftUI

struct BrowseView: View {
    
    @EnvironmentObject var healthManager : HealthStoreManager
    @State var categotyValues : [HealthCategoriesData] = []
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                List(searchedCategotyValues, id: \.id) { category in
                    VStack {
                        
                        if category.animate {
                            NavigationLink(destination: FilteredHealthListView(filterType: category)) {
                                CategoryRowView(category: category)
                            }
                        }

                    }.frame(height: 40)
                }
            }
            .navigationTitle("Health Categories").onAppear {
                categotyValues = healthManager.getCategoriesDetails()
                
                // Data loading animation
                for(index,_) in categotyValues.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                        withAnimation(.interactiveSpring(response: 0.8,dampingFraction: 0.8,blendDuration: 0.8)) {
                            categotyValues[index].animate = true
                        }
                    }
                }
                
                healthManager.showTabbar(show: true)
            }
        }.environmentObject(healthManager).searchable(text: $searchText, prompt: "Search Category")
    }
    
    var searchedCategotyValues: [HealthCategoriesData] {
        if searchText.isEmpty {
            return categotyValues
        } else {
            return categotyValues.filter { $0.title.contains(searchText) }
        }
    }
}

#Preview {
    BrowseView(categotyValues: [HealthCategoriesData(title: "Activity", image: "category_Activity", type: .ACTIVITY, color: .red)])
}

struct CategoryRowView: View {
    
    var category : HealthCategoriesData
    
    var body: some View {
        HStack {
            Image(category.image).resizable().renderingMode(.template).foregroundColor(category.color).frame(width: 30,height: 30).padding(.trailing)
            Text(category.title).font(.system(size: 20,weight: .bold))
        }
    }
}


struct ContentView: View {
    let names = ["Holly", "Josh", "Rhonda", "Ted"]
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { name in
                    NavigationLink {
                        Text(name)
                    } label: {
                        Text(name)
                    }
                }
            }
            .navigationTitle("Contacts")
        }
        .searchable(text: $searchText)
    }

    var searchResults: [String] {
        if searchText.isEmpty {
            return names
        } else {
            return names.filter { $0.contains(searchText) }
        }
    }
}
