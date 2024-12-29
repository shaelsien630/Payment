//
//  MainView.swift
//  Payment
//
//  Created by 최서희 on 12/27/24.
//

import SwiftUI

struct MainView: View {
    @State var selectedTab: Int = 2
    
    var body: some View {
        TabView(selection: $selectedTab) {
            VStack{}
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                        .environment(\.symbolVariants, .none)
                }
                .tag(0)
            
            VStack{}
                .tabItem {
                    Image(systemName: "creditcard")
                        .environment(\.symbolVariants, .none)
                }
                .tag(1)
            
            TransactionsView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                }
                .tag(2)
            
            VStack{}
                .tabItem {
                    Image(systemName: "person")
                        .environment(\.symbolVariants, .none)
                }
                .tag(3)
        }
    }
}

#Preview {
    MainView()
}
