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
    
    // Animation types for Persian poetry backgrounds - all minimalistic
    private let animationTypes = [
        "looping_line",
        "looping_line",
        "looping_line",
        "looping_line",
        "looping_line"
    ]
    
    private init() {}
    
    func getRandomAnimationType() -> String {
        return "looping_line"
    }
    
    func getAnimationTypes(count: Int) -> [String] {
        return Array(repeating: "looping_line", count: max(0, count))
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
                colors: [Color.black, Color.black.opacity(0.95)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Animated content based on type
            switch animationType {
            case "looping_line":
                LoopingLineView()
            case "messy_sketches":
                MessySketchesView()
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
                LoopingLineView()
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Animation Components
struct LoopingLineView: View {
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.3
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Single minimalistic looping line
                LoopingLineShape()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.4),
                                Color.white.opacity(0.2),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 1.0
                    )
                    .frame(
                        width: geometry.size.width * 0.6,
                        height: geometry.size.height * 0.6
                    )
                    .rotationEffect(.degrees(rotation))
                    .scaleEffect(scale)
                    .opacity(opacity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        // Very slow, subtle rotation
        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
            rotation = 360
        }
        
        // Very gentle scale pulse
        withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
            scale = 1.05
        }
        
        // Subtle breathing opacity
        withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
            opacity = 0.15
        }
    }
}

struct LoopingLineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        // Create a figure-8 or infinity symbol
        let width = radius * 0.6
        let height = radius * 0.4
        
        // Start from the left side
        path.move(to: CGPoint(x: center.x - width, y: center.y))
        
        // Create the first loop (left side)
        path.addCurve(
            to: CGPoint(x: center.x, y: center.y - height),
            control1: CGPoint(x: center.x - width/2, y: center.y - height/2),
            control2: CGPoint(x: center.x - width/4, y: center.y - height)
        )
        
        // Create the second loop (right side)
        path.addCurve(
            to: CGPoint(x: center.x + width, y: center.y),
            control1: CGPoint(x: center.x + width/4, y: center.y - height),
            control2: CGPoint(x: center.x + width/2, y: center.y - height/2)
        )
        
        // Complete the bottom part
        path.addCurve(
            to: CGPoint(x: center.x, y: center.y + height),
            control1: CGPoint(x: center.x + width/2, y: center.y + height/2),
            control2: CGPoint(x: center.x + width/4, y: center.y + height)
        )
        
        // Close the loop
        path.addCurve(
            to: CGPoint(x: center.x - width, y: center.y),
            control1: CGPoint(x: center.x - width/4, y: center.y + height),
            control2: CGPoint(x: center.x - width/2, y: center.y + height/2)
        )
        
        return path
    }
}

struct FloatingParticlesView: View {
    @State private var particles: [Particle] = []
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
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
                generateParticles(in: size)
                startAnimation()
            }
            .onChange(of: size) { newSize in
                generateParticles(in: newSize)
            }
        }
    }
    
    private func generateParticles(in size: CGSize) {
        particles = (0..<20).map { _ in
            Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
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
        GeometryReader { geo in
            let size = geo.size
            ZStack {
                ForEach(hearts) { heart in
                    Text("💖")
                        .font(.system(size: heart.size))
                        .position(heart.position)
                        .opacity(heart.opacity)
                }
            }
            .onAppear {
                generateHearts(in: size)
                startHeartAnimation()
            }
            .onChange(of: size) { newSize in
                generateHearts(in: newSize)
            }
        }
    }
    
    private func generateHearts(in size: CGSize) {
        hearts = (0..<8).map { _ in
            Heart(
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
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
        GeometryReader { geo in
            let size = geo.size
            ZStack {
                ForEach(stars) { star in
                    Text("✨")
                        .font(.system(size: star.size))
                        .position(star.position)
                        .opacity(star.opacity)
                }
            }
            .onAppear {
                generateStars(in: size)
                startStarAnimation()
            }
            .onChange(of: size) { newSize in
                generateStars(in: newSize)
            }
        }
    }
    
    private func generateStars(in size: CGSize) {
        stars = (0..<15).map { _ in
            Star(
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
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
        GeometryReader { geo in
            let size = geo.size
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
                generateLines(in: size)
                startLineAnimation()
            }
            .onChange(of: size) { newSize in
                generateLines(in: newSize)
            }
        }
    }
    
    private func generateLines(in size: CGSize) {
        lines = (0..<6).map { _ in
            FlowingLine(
                startPoint: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                ),
                endPoint: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                ),
                control1: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                ),
                control2: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
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

struct MessySketchesView: View {
    @State private var stroke: SketchStroke? = nil

    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation) { timeline in
                let size = geo.size
                let time = timeline.date.timeIntervalSinceReferenceDate

                ZStack {
                    if let s = stroke {
                        Path { path in
                            let pts = morphingLoopPoints(for: s, time: time, in: size, samples: 260)
                            guard let first = pts.first else { return }
                            path.move(to: first)
                            for p in pts.dropFirst() {
                                path.addLine(to: p)
                            }
                            path.closeSubpath()
                        }
                        .stroke(Color.white.opacity(s.opacity),
                                style: StrokeStyle(lineWidth: s.lineWidth, lineCap: .round, lineJoin: .round))
                    }
                }
                .onAppear { generateStroke(in: size) }
                .onChange(of: size) { newSize in generateStroke(in: newSize) }
            }
        }
        .ignoresSafeArea()
    }

    private func generateStroke(in size: CGSize) {
        let minDim = min(size.width, size.height)
        let center = CGPoint(x: size.width * 0.5, y: size.height * 0.55)
        let baseRadius = CGFloat.random(in: minDim * 0.22...minDim * 0.36)
        let radiusPulseAmp = CGFloat.random(in: 0.08...0.18) // ±8–18%
        let radiusPulseSpeed = CGFloat.random(in: 0.18...0.28) // calm
        let eccMin: CGFloat = 0.04  // near-line
        let eccMax: CGFloat = 1.0   // perfect circle
        let eccSpeed = CGFloat.random(in: 0.12...0.22)
        let rotationSpeed = CGFloat.random(in: 0.18...0.32)
        let noiseAmp = baseRadius * CGFloat.random(in: 0.015...0.045)
        let noiseFreq = CGFloat.random(in: 0.8...1.6)
        let lineWidth = CGFloat.random(in: 1.0...1.8)
        let opacity = Double.random(in: 0.45...0.75)

        stroke = SketchStroke(
            center: center,
            baseRadius: baseRadius,
            radiusPulseAmplitude: radiusPulseAmp,
            radiusPulseSpeed: radiusPulseSpeed,
            eccentricityMin: eccMin,
            eccentricityMax: eccMax,
            eccentricitySpeed: eccSpeed,
            rotationSpeed: rotationSpeed,
            noiseAmplitude: noiseAmp,
            noiseFrequency: noiseFreq,
            lineWidth: lineWidth,
            opacity: opacity,
            seed: CGFloat.random(in: 0...(2 * .pi))
        )
    }

    private func morphingLoopPoints(for s: SketchStroke, time: TimeInterval, in size: CGSize, samples: Int) -> [CGPoint] {
        // Time-based parameters
        let t = CGFloat(time)
        let phaseRot = t * s.rotationSpeed + s.seed

        // Radius pulsing (expand/shrink)
        let pulse = sin(t * s.radiusPulseSpeed + s.seed) * s.radiusPulseAmplitude
        let radius = s.baseRadius * (1 + pulse)

        // Eccentricity morph (line <-> circle)
        let eccPhase = (sin(t * s.eccentricitySpeed + s.seed * 0.7) + 1) * 0.5 // 0..1
        let ecc = s.eccentricityMin + (s.eccentricityMax - s.eccentricityMin) * eccPhase

        let twoPi = CGFloat.pi * 2
        let step = twoPi / CGFloat(samples)
        var points: [CGPoint] = []
        points.reserveCapacity(samples + 1)

        for i in 0...samples {
            let a = CGFloat(i) * step
            // Elliptical radii with small noise ripple
            let rx = radius
            let ry = max(0, radius * ecc)
            let n = sin(a * s.noiseFrequency + phaseRot) * s.noiseAmplitude
            let x = s.center.x + (rx + n) * cos(a + phaseRot)
            let y = s.center.y + (ry + n) * sin(a + phaseRot)
            points.append(CGPoint(x: x, y: y))
        }
        return points
    }
}

struct SketchStroke: Identifiable {
    let id = UUID()
    let center: CGPoint

    // Radius base and pulsing
    let baseRadius: CGFloat
    let radiusPulseAmplitude: CGFloat // 0..~0.2 of base radius
    let radiusPulseSpeed: CGFloat

    // Eccentricity morph between line (≈0) and circle (=1)
    let eccentricityMin: CGFloat
    let eccentricityMax: CGFloat
    let eccentricitySpeed: CGFloat

    // Motion and organic noise
    let rotationSpeed: CGFloat
    let noiseAmplitude: CGFloat
    let noiseFrequency: CGFloat

    // Rendering
    let lineWidth: CGFloat
    let opacity: Double

    // Random seed
    let seed: CGFloat
}

struct ColorfulBubblesView: View {
    @State private var bubbles: [Bubble] = []
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
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
                generateBubbles(in: size)
                startBubbleAnimation()
            }
            .onChange(of: size) { newSize in
                generateBubbles(in: newSize)
            }
        }
    }
    
    private func generateBubbles(in size: CGSize) {
        bubbles = (0..<12).map { _ in
            Bubble(
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
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

