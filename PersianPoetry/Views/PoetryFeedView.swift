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
    @State private var isRefreshing = false
    @State private var refreshStartTime: Date? = nil
    private let minRefreshDuration: TimeInterval = 1.2
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
                                               // Load more poems when user reaches 10th card from the end (for 1000 poem batches)
                                               if index >= viewModel.poems.count - 10 {
                                                   print("Loading more poems - user at index \(index), total poems: \(viewModel.poems.count)")
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
                            isRefreshing = true
                            refreshStartTime = Date()
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
        .safeAreaInset(edge: .top) {
            if isRefreshing {
                HStack(spacing: 8) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    Text("Refreshing…")
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.black.opacity(0.5))
                .clipShape(Capsule())
                .padding(.top, 8)
            } else {
                EmptyView().frame(height: 0)
            }
        }
        .onAppear {
            viewModel.loadInitialPoems()
        }
        .onChange(of: viewModel.isLoading) {
            if !viewModel.isLoading {
                let elapsed = refreshStartTime.map { Date().timeIntervalSince($0) } ?? minRefreshDuration
                let remaining = max(0, minRefreshDuration - elapsed)
                DispatchQueue.main.asyncAfter(deadline: .now() + remaining) {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isRefreshing = false
                    }
                    refreshStartTime = nil
                }
            }
        }
        .onChange(of: refreshTrigger) {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            isRefreshing = true
            refreshStartTime = Date()
            viewModel.refreshPoems()
            currentIndex = 0
        }
        .onTapGesture(count: 2) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            isRefreshing = true
            refreshStartTime = Date()
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
        private let batchSize = 1000 // Large batch size for initial load
        private let loadMoreSize = 1000 // Large batch size for loading more
        private var hasLoadedInitialBatch = false

    private let pageSize = 20
    private var currentPage = 1
    private var currentKeyword: String = ""
    private var isExhausted = false

    private func randomKeyword() -> String {
        let letters = ["ا","ب","پ","ت","ث","ج","چ","ح","خ","د","ذ","ر","ز","ژ","س","ش","ص","ض","ط","ظ","ع","غ","ف","ق","ک","گ","ل","م","ن","و","ه","ی"]
        return letters.randomElement() ?? "ا"
    }
    
    func loadInitialPoems() {
        isLoading = true
        error = nil
        poems.removeAll()
        animationTypes.removeAll()
        hasLoadedInitialBatch = false

        print("Loading initial batch of \(batchSize) poems...")

        apiService.fetchRandomPoems(count: batchSize)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        print("API Error: \(error)")
                        self?.error = "Failed to load poetry: \(error.localizedDescription)"
                        // Try to load from Core Data as fallback
                        self?.loadFromCoreData()
                    }
                },
                receiveValue: { [weak self] results in
                    guard let self else { return }
                    print("Successfully loaded \(results.count) poems from API")
                    self.poems = results
                    self.animationTypes = self.animationService.getAnimationTypes(count: results.count)
                    self.hasLoadedInitialBatch = true
                    self.error = results.isEmpty ? "No poems found." : nil
                    
                    // Save to Core Data for future use
                    self.saveToCoreData(poems: results)
                    
                    // Proactively load more content to ensure we never run out
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.loadMorePoems()
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func loadMorePoems() {
        guard !isLoadingMore else { 
            print("Already loading more poems, skipping...")
            return 
        }
        
        // Proactively load more if we're running low on content
        if poems.count < 20 && !isLoadingMore { // If less than 20 poems, load more aggressively
            print("Proactively loading more poems due to low count (\(poems.count))...")
        } else {
            print("Starting to load more poems...")
        }
        
        isLoadingMore = true
        
        print("Loading \(loadMoreSize) more poems...")
        
        apiService.fetchRandomPoems(count: loadMoreSize)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoadingMore = false
                    if case .failure(let error) = completion {
                        print("API Error loading more: \(error)")
                        // Try to load from Core Data as fallback
                        self?.loadMoreFromCoreData()
                    }
                },
                receiveValue: { [weak self] newPoems in
                    guard let self else { return }
                    print("Successfully loaded \(newPoems.count) more poems")
                    print("Total poems before: \(self.poems.count)")
                    self.poems.append(contentsOf: newPoems)
                    let newAnimationTypes = self.animationService.getAnimationTypes(count: newPoems.count)
                    self.animationTypes.append(contentsOf: newAnimationTypes)
                    print("Total poems after: \(self.poems.count)")
                    print("Total animation types: \(self.animationTypes.count)")
                    
                    // Save to Core Data for future use
                    self.saveToCoreData(poems: newPoems)
                }
            )
            .store(in: &cancellables)
    }
    
    func refreshPoems() {
        poems.removeAll()
        animationTypes.removeAll()
        loadInitialPoems()
    }
    
    // MARK: - Core Data Methods
    private func saveToCoreData(poems: [Poem]) {
        // This would save poems to Core Data for offline use
        // For now, we'll just print that we would save them
        print("Would save \(poems.count) poems to Core Data")
    }
    
    private func loadFromCoreData() {
        // This would load poems from Core Data as fallback
        // For now, we'll fall back to sample data
        print("Loading from Core Data fallback...")
        let samplePoems = SampleDataService.shared.getSamplePoems()
        let shuffledPoems = Array(samplePoems.shuffled().prefix(batchSize))
        self.poems = shuffledPoems
        self.animationTypes = self.animationService.getAnimationTypes(count: shuffledPoems.count)
        self.error = nil
    }
    
    private func loadMoreFromCoreData() {
        // This would load more poems from Core Data as fallback
        print("Loading more from Core Data fallback...")
        let samplePoems = SampleDataService.shared.getSamplePoems()
        let shuffledPoems = Array(samplePoems.shuffled().prefix(loadMoreSize))
        self.poems.append(contentsOf: shuffledPoems)
        let newAnimationTypes = self.animationService.getAnimationTypes(count: shuffledPoems.count)
        self.animationTypes.append(contentsOf: newAnimationTypes)
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

