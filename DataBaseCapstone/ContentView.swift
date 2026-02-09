//
//  ContentView.swift
//  DataBaseCapstone
//
//  Created by Mendez on 2/9/26.
//

import SwiftUI

struct ContentView: View {
    @State private var hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    var body: some View {
        Group {
            if hasSeenOnboarding {
                TodoListView()
                    .transition(.opacity.combined(with: .scale))
            } else {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: hasSeenOnboarding)
    }
}

#Preview {
    ContentView()
}
