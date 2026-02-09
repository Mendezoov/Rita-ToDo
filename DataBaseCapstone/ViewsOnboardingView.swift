//
//  OnboardingView.swift
//  DataBaseCapstone
//
//  Created by Mendez on 2/9/26.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var rotation: Double = 0
    @State private var floatingOffset: CGFloat = 0
    
    let emojis = ["✨", "🎯", "📝", "💫", "🌟", "⭐️"]
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.2, blue: 0.8),
                    Color(red: 0.8, green: 0.3, blue: 0.6),
                    Color(red: 1.0, green: 0.5, blue: 0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .hueRotation(.degrees(rotation))
            
            // Floating emojis
            ForEach(0..<6, id: \.self) { index in
                Text(emojis[index])
                    .font(.system(size: 60))
                    .offset(
                        x: CGFloat.random(in: -150...150),
                        y: CGFloat.random(in: -300...300) + floatingOffset
                    )
                    .opacity(opacity)
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: floatingOffset
                    )
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                // Main content
                VStack(spacing: 20) {
                    Text("✨")
                        .font(.system(size: 100))
                        .scaleEffect(scale)
                        .rotationEffect(.degrees(rotation * 0.5))
                    
                    Text("Welcome to")
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.9))
                        .opacity(opacity)
                    
                    Text("Rita To-Do List")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .scaleEffect(scale)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Text("Organize your life with style ✨")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.8))
                        .opacity(opacity)
                        .padding(.top, 8)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Get Started button
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        hasSeenOnboarding = true
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    }
                } label: {
                    HStack {
                        Text("Get Started")
                            .font(.title3.bold())
                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 18)
                    .background(
                        Capsule()
                            .fill(.white.opacity(0.2))
                            .overlay(
                                Capsule()
                                    .stroke(.white.opacity(0.5), lineWidth: 2)
                            )
                    )
                }
                .scaleEffect(scale)
                .opacity(opacity)
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
            
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                floatingOffset = 30
            }
        }
    }
}

#Preview {
    OnboardingView(hasSeenOnboarding: .constant(false))
}
