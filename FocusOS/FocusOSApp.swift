//
//  FocusOSApp.swift
//  FocusOS
//
//  Created by Sheldon on 2/13/26.
//

import SwiftUI

@main
struct FocusOSApp: App {
    init() {
        OpenAIConfig.startupLog()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
