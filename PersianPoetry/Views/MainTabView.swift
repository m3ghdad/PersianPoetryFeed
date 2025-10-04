//
//  MainTabView.swift
//  PersianPoetry
//
//  Created by Meghdad Abbaszadegan on 10/3/25.
//

import SwiftUI
import UIKit

struct MainTabView: View {
    @State private var refreshTrigger = false
    @State private var isRefreshingAnim = false

    var body: some View {
        PoetryFeedView(refreshTrigger: $refreshTrigger)
            .ignoresSafeArea()
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Button {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        isRefreshingAnim = true
                        refreshTrigger.toggle()
                        // Ensure a minimum visible animation duration
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            isRefreshingAnim = false
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .rotationEffect(.degrees(isRefreshingAnim ? 360 : 0))
                            .animation(isRefreshingAnim ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isRefreshingAnim)
                            .font(.system(size: 18, weight: .semibold))
                            .padding(12)
                    }
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 14))
                    .scaleEffect(isRefreshingAnim ? 1.05 : 1.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isRefreshingAnim)
                    .disabled(isRefreshingAnim)

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
            }
    }
}

#Preview {
    MainTabView()
}
