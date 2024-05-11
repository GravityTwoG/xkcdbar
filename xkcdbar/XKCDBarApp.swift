//
//  xkcdbarApp.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import SwiftUI
import MenuBarExtraAccess

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
                ).background(Color(NSColor.windowBackgroundColor))
        }.menuBarExtraStyle(.window).menuBarExtraAccess(
            isPresented: Binding(
                get: { xkcdViewModel.popoverOpened },
                set: {value in xkcdViewModel.popoverOpened = value}
            )
        ).commands(content: {
            
        })
          
        Window("Preview", id: "preview") {
            PreviewView(xkcdViewModel: xkcdViewModel)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
                .onAppear {
                    if let window = NSApplication.shared.windows.last {
                        window.zoom(window)
                        window.makeKeyAndOrderFront(nil)
                        window.makeKey()
                    }
                }
        }
        
        Window("About XKCDBar", id: "about") {
            AboutView()
        }.windowResizability(WindowResizability.contentSize)
    }
}
