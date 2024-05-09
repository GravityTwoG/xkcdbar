//
//  AppDelegate.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import SwiftUI

class AppDelegate : NSObject, NSApplicationDelegate {
    static var popover = NSPopover()
    
    var statusBar: StatusBarController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        Self.popover.contentViewController = NSHostingController(rootView: PopoverView())
        
        Self.popover.behavior = .transient
        
        statusBar = StatusBarController(Self.popover)
    }
}
