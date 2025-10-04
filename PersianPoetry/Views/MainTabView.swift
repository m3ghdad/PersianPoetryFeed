//
//  MainTabView.swift
//  PersianPoetry
//
//  Created by Meghdad Abbaszadegan on 10/3/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var refreshTrigger = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PoetryFeedView(refreshTrigger: $refreshTrigger)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            Text("Search")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)
            
            Text("Favorites")
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
                .tag(2)
            
            Text("Profile")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(.white)
        .onChange(of: selectedTab) {
            if selectedTab == 0 {
                // Trigger refresh when home tab is tapped
                refreshTrigger.toggle()
            }
        }
    }
}

#Preview {
    MainTabView()
}
