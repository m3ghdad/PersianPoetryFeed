//
//  VideoService.swift
//  PersianPoetry
//
//  Created by Meghdad Abbaszadegan on 10/3/25.
//

import Foundation
import SwiftUI

class AnimationService {
    static let shared = AnimationService()
    
    // Animation types for Persian poetry backgrounds
    private let animationTypes = [
        "floating_particles",
        "gradient_waves", 
        "geometric_patterns",
        "floating_hearts",
        "sparkling_stars",
        "flowing_lines",
        "colorful_bubbles",
        "mystical_aurora"
    ]
    
    private init() {}
    
    func getRandomAnimationType() -> String {
        guard let randomType = animationTypes.randomElement() else { return "floating_particles" }
        print("Selected animation type: \(randomType)")
        return randomType
    }
    
    func getAnimationTypes(count: Int) -> [String] {
        var types: [String] = []
        for _ in 0..<count {
            types.append(getRandomAnimationType())
        }
        return types
    }
}

// MARK: - Animated Background View
struct AnimatedBackgroundView: View {
    let animationType: String
    @State private var animationOffset: CGFloat = 0
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Base gradient background
            LinearGradient(
                colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3), Color.pink.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Animated content based on type
            switch animationType {
            case "floating_particles":
                FloatingParticlesView()
            case "gradient_waves":
                GradientWavesView()
            case "geometric_patterns":
                GeometricPatternsView()
            case "floating_hearts":
                FloatingHeartsView()
            case "sparkling_stars":
                SparklingStarsView()
            case "flowing_lines":
                FlowingLinesView()
            case "colorful_bubbles":
                ColorfulBubblesView()
            case "mystical_aurora":
                MysticalAuroraView()
            default:
                FloatingParticlesView()
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Animation Components
struct FloatingParticlesView: View {
    @State private var particles: [Particle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
        }
        .onAppear {
            generateParticles()
            startAnimation()
        }
    }
    
    private func generateParticles() {
        particles = (0..<20).map { _ in
            Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 4...12),
                color: [Color.purple, Color.blue, Color.pink, Color.orange].randomElement() ?? .purple,
                opacity: Double.random(in: 0.3...0.8)
            )
        }
    }
    
    private func startAnimation() {
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            for i in particles.indices {
                particles[i].position.y -= 100
                particles[i].opacity = Double.random(in: 0.3...0.8)
            }
        }
    }
}

struct GradientWavesView: View {
    @State private var waveOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                WaveShape(offset: waveOffset + CGFloat(index * 100))
                    .fill(
                        LinearGradient(
                            colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 100)
                    .offset(y: CGFloat(index * 50))
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                waveOffset = 400
            }
        }
    }
}

struct GeometricPatternsView: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [Color.purple.opacity(0.4), Color.blue.opacity(0.4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: CGFloat(100 + index * 50))
                    .rotationEffect(.degrees(rotation + Double(index * 30)))
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

struct FloatingHeartsView: View {
    @State private var hearts: [Heart] = []
    
    var body: some View {
        ZStack {
            ForEach(hearts) { heart in
                Text("💖")
                    .font(.system(size: heart.size))
                    .position(heart.position)
                    .opacity(heart.opacity)
            }
        }
        .onAppear {
            generateHearts()
            startHeartAnimation()
        }
    }
    
    private func generateHearts() {
        hearts = (0..<8).map { _ in
            Heart(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 20...40),
                opacity: Double.random(in: 0.4...0.8)
            )
        }
    }
    
    private func startHeartAnimation() {
        withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
            for i in hearts.indices {
                hearts[i].position.y -= 50
                hearts[i].opacity = Double.random(in: 0.4...0.8)
            }
        }
    }
}

struct SparklingStarsView: View {
    @State private var stars: [Star] = []
    
    var body: some View {
        ZStack {
            ForEach(stars) { star in
                Text("✨")
                    .font(.system(size: star.size))
                    .position(star.position)
                    .opacity(star.opacity)
            }
        }
        .onAppear {
            generateStars()
            startStarAnimation()
        }
    }
    
    private func generateStars() {
        stars = (0..<15).map { _ in
            Star(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 15...30),
                opacity: Double.random(in: 0.3...0.9)
            )
        }
    }
    
    private func startStarAnimation() {
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            for i in stars.indices {
                stars[i].opacity = Double.random(in: 0.3...0.9)
            }
        }
    }
}

struct FlowingLinesView: View {
    @State private var lines: [FlowingLine] = []
    
    var body: some View {
        ZStack {
            ForEach(lines) { line in
                Path { path in
                    path.move(to: line.startPoint)
                    path.addCurve(
                        to: line.endPoint,
                        control1: line.control1,
                        control2: line.control2
                    )
                }
                .stroke(
                    LinearGradient(
                        colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
            }
        }
        .onAppear {
            generateLines()
            startLineAnimation()
        }
    }
    
    private func generateLines() {
        lines = (0..<6).map { _ in
            FlowingLine(
                startPoint: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                endPoint: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                control1: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                control2: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                )
            )
        }
    }
    
    private func startLineAnimation() {
        withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
            for i in lines.indices {
                lines[i].startPoint.x += 50
                lines[i].endPoint.x += 50
            }
        }
    }
}

struct ColorfulBubblesView: View {
    @State private var bubbles: [Bubble] = []
    
    var body: some View {
        ZStack {
            ForEach(bubbles) { bubble in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [bubble.color.opacity(0.6), bubble.color.opacity(0.2)],
                            center: .center,
                            startRadius: 0,
                            endRadius: bubble.size / 2
                        )
                    )
                    .frame(width: bubble.size, height: bubble.size)
                    .position(bubble.position)
                    .opacity(bubble.opacity)
            }
        }
        .onAppear {
            generateBubbles()
            startBubbleAnimation()
        }
    }
    
    private func generateBubbles() {
        bubbles = (0..<12).map { _ in
            Bubble(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 30...80),
                color: [Color.purple, Color.blue, Color.pink, Color.orange, Color.green].randomElement() ?? .purple,
                opacity: Double.random(in: 0.3...0.7)
            )
        }
    }
    
    private func startBubbleAnimation() {
        withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
            for i in bubbles.indices {
                bubbles[i].position.y -= 100
                bubbles[i].opacity = Double.random(in: 0.3...0.7)
            }
        }
    }
}

struct MysticalAuroraView: View {
    @State private var auroraOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<4, id: \.self) { index in
                AuroraShape(offset: auroraOffset + CGFloat(index * 100))
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.purple.opacity(0.4),
                                Color.blue.opacity(0.4),
                                Color.pink.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 150)
                    .offset(y: CGFloat(index * 80))
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                auroraOffset = 500
            }
        }
    }
}

// MARK: - Data Models
struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let color: Color
    var opacity: Double
}

struct Heart: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    var opacity: Double
}

struct Star: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    var opacity: Double
}

struct FlowingLine: Identifiable {
    let id = UUID()
    var startPoint: CGPoint
    var endPoint: CGPoint
    var control1: CGPoint
    var control2: CGPoint
}

struct Bubble: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let color: Color
    var opacity: Double
}

// MARK: - Custom Shapes
struct WaveShape: Shape {
    var offset: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: 0, y: height))
        
        for x in stride(from: 0, through: width, by: 1) {
            let y = height * 0.5 + sin((x + offset) * 0.01) * height * 0.3
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        
        return path
    }
}

struct AuroraShape: Shape {
    var offset: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: 0, y: height))
        
        for x in stride(from: 0, through: width, by: 1) {
            let y = height * 0.3 + sin((x + offset) * 0.005) * height * 0.4 + cos((x + offset) * 0.003) * height * 0.2
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        
        return path
    }
}
