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
    
    @AppStorage("comicNum") static var comicNum: Int = 1
    
    var body: some Scene {
        MenuBarExtra("XKCDBar", systemImage: "pencil.slash") {
            PopoverView(xkcdService: XKCDService(baseURL: baseURL))
                .frame(
                    minWidth: 600, maxWidth: 800,
                    maxHeight: 800
                )
        }.menuBarExtraStyle(.window)
          
        Window("Preview", id: "preview") {
            PopoverView(xkcdService: XKCDService(baseURL: baseURL))
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
