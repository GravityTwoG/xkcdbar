//
//  xkcdbarApp.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import SwiftUI

@main
struct xkcdbarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
