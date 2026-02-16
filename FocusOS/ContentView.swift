//
//  ContentView.swift
//  FocusOS
//
//  Created by Sheldon on 2/13/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasOnboarded") private var hasOnboarded = false

    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()

            if hasOnboarded {
                TabView {
                    NavigationStack {
                        DashboardView()
                            .focusNavigationStyle()
                    }
                    .tabItem { Label("Dashboard", systemImage: "square.grid.2x2.fill") }

                    NavigationStack {
                        FocusTimerView()
                            .focusNavigationStyle()
                    }
                    .tabItem { Label("Focus", systemImage: "timer") }

                    NavigationStack {
                        TasksView()
                            .focusNavigationStyle()
                    }
                    .tabItem { Label("Tasks", systemImage: "checklist") }

                    NavigationStack {
                        StatsView()
                            .focusNavigationStyle()
                    }
                    .tabItem { Label("Stats", systemImage: "chart.bar.fill") }

                    NavigationStack {
                        SettingsView()
                            .focusNavigationStyle()
                    }
                    .tabItem { Label("Settings", systemImage: "gearshape.fill") }
                }
            } else {
                OnboardingView {
                    hasOnboarded = true
        }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .accentColor(AppColors.gold)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
