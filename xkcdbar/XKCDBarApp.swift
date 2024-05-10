//
//  xkcdbarApp.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import SwiftUI

@main
struct XKCDBarApp: App {
    let baseURL = "https://xkcd.com"
    
    let xkcdViewModel: XKCDViewModel
    
    init() {
        self.xkcdViewModel = XKCDViewModel(xkcdService: XKCDService(baseURL: baseURL))
    }
    
    var body: some Scene {
        MenuBarExtra("XKCDBar", systemImage: "pencil.slash") {
            PopoverView(xkcdViewModel: xkcdViewModel)
                .frame(
                    minWidth: 600, maxWidth: 800,
                    maxHeight: 800
                )
        }.menuBarExtraStyle(.window)
          
        Window("Preview", id: "preview") {
            PreviewView(xkcdViewModel: xkcdViewModel)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
                .onAppear {
                    DispatchQueue.main.async {
                        if let window = NSApplication.shared.windows.last {
                            window.zoom(window)
                        }
                    }
                }
        }
        
        Window("About XKCDBar", id: "about") {
            AboutView()
        }.windowResizability(WindowResizability.contentSize)
    }
}
