//
//  PoetryFeedView.swift
//  PersianPoetry
//
//  Created by Meghdad Abbaszadegan on 10/3/25.
//

import SwiftUI
import Combine
import UIKit

struct PoetryFeedView: View {
    @StateObject private var viewModel = PoetryFeedViewModel()
    @State private var currentIndex: Int? = 0
    @Binding var refreshTrigger: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.poems.isEmpty {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                        Text("Loading beautiful poetry...")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.top)
                    }
                } else if !viewModel.poems.isEmpty {
                    ScrollViewReader { proxy in
                        ScrollView(.vertical) {
                            LazyVStack(spacing: 0) {
                                ForEach(Array(viewModel.poems.enumerated()), id: \.element.id) { index, poem in
                                    PoetryAnimatedCard(
                                        poem: poem,
                                        animationType: viewModel.animationTypes[safe: index] ?? "floating_particles",
                                        isActive: index == (currentIndex ?? 0)
                                    )
                                    .containerRelativeFrame(.vertical)
                                    .id(index)
                                    .onAppear {
                                        // Load more poems when approaching the end
                                        if index >= viewModel.poems.count - 3 {
                                            viewModel.loadMorePoems()
                                        }
                                    }
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollIndicators(.hidden)
                        .scrollTargetBehavior(.paging)
                        .ignoresSafeArea()
                        .scrollPosition(id: $currentIndex)
                        .sensoryFeedback(.selection, trigger: currentIndex)
                        .refreshable {
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                            viewModel.refreshPoems()
                            currentIndex = 0
                        }
                    }
                } else {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        Text("Failed to load poetry")
                            .foregroundColor(.white)
                            .font(.headline)
                        Button("Try Again") {
                            viewModel.refreshPoems()
                        }
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadInitialPoems()
        }
        .onChange(of: refreshTrigger) { _ in
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            viewModel.refreshPoems()
            currentIndex = 0
        }
        .onTapGesture(count: 2) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            viewModel.refreshPoems()
            currentIndex = 0
        }
    }
}

// MARK: - Poetry Animated Card
struct PoetryAnimatedCard: View {
    let poem: Poem
    let animationType: String
    let isActive: Bool
    
    var body: some View {
        ZStack {
            // Animated Background
            AnimatedBackgroundView(animationType: animationType)
                .ignoresSafeArea()
            
            // Gradient Overlay
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.3),
                    Color.clear,
                    Color.black.opacity(0.7)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Poetry Text Overlay
            VStack {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 16) {
                    // Poet Name
                    Text(poem.poet.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                    
                    // Poem Text
                    Text(poem.plainText)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .lineSpacing(8)
                        .shadow(color: .black.opacity(0.8), radius: 2, x: 1, y: 1)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
    }
}

// MARK: - View Model
class PoetryFeedViewModel: ObservableObject {
    @Published var poems: [Poem] = []
    @Published var animationTypes: [String] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var error: String?
    
    private let apiService = APIService.shared
    private let animationService = AnimationService.shared
    private var cancellables = Set<AnyCancellable>()
    private let batchSize = 10
    
    func loadInitialPoems() {
        isLoading = true
        error = nil
        
        apiService.fetchRandomPoems(count: batchSize)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        print("API Error: \(error)")
                        self?.error = "Failed to load poetry: \(error.localizedDescription)"
                    }
                },
                receiveValue: { [weak self] poems in
                    print("Successfully loaded \(poems.count) poems")
                    self?.poems = poems
                    self?.animationTypes = self?.animationService.getAnimationTypes(count: poems.count) ?? []
                }
            )
            .store(in: &cancellables)
    }
    
    func loadMorePoems() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        
        apiService.fetchRandomPoems(count: batchSize)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoadingMore = false
                    if case .failure(let error) = completion {
                        print("API Error loading more: \(error)")
                    }
                },
                receiveValue: { [weak self] newPoems in
                    print("Successfully loaded \(newPoems.count) more poems")
                    self?.poems.append(contentsOf: newPoems)
                    let newAnimationTypes = self?.animationService.getAnimationTypes(count: newPoems.count) ?? []
                    self?.animationTypes.append(contentsOf: newAnimationTypes)
                }
            )
            .store(in: &cancellables)
    }
    
    func refreshPoems() {
        poems.removeAll()
        animationTypes.removeAll()
        loadInitialPoems()
    }
}

// MARK: - Array Extension
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    PoetryFeedView(refreshTrigger: .constant(false))
}

