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
        MenuBarExtra {
            PopoverView(xkcdViewModel: xkcdViewModel)
                .frame(
                    minWidth: 600, maxWidth: 800,
                    maxHeight: 800
                ).background(Color(NSColor.windowBackgroundColor))
        } label: {
            let image: NSImage = {
                let ratio = $0.size.height / $0.size.width
                $0.size.height = 28
                $0.size.width = 28 / ratio
                return $0
            }(NSImage(named: "xkcd-icon-white")!)

            Image(nsImage: image).renderingMode(.template)
        }.menuBarExtraStyle(.window).menuBarExtraAccess(
            isPresented: Binding(
                get: { xkcdViewModel.popoverOpened },
                set: {value in xkcdViewModel.popoverOpened = value}
            )
        )
          
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
                .onAppear {
                    if let window = NSApplication.shared.windows.last {
                        window.makeKeyAndOrderFront(nil)
                    }
                }
        }.windowResizability(WindowResizability.contentSize)
    }
}
