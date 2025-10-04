//
//  ContentView.swift
//  PersianPoetry
//
//  Created by Meghdad Abbaszadegan on 10/3/25.
//

import SwiftUI

struct ContentView: View {
    @State private var refreshTrigger = false

    var body: some View {
        PoetryFeedView(refreshTrigger: $refreshTrigger)
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
