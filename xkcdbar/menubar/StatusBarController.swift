//
//  StatusBarController.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import SwiftUI

class StatusBarController {
    private var statusBar: NSStatusBar
    private(set) var statusItem: NSStatusItem
    private(set) var popover: NSPopover
    
    init(_ popover: NSPopover) {
        self.popover = popover
        statusBar = .init()
        
        statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "pencil.slash", accessibilityDescription: "xkcdbar")
            button.action = #selector(showApp(sender:))
            button.target = self
        }
    }
    
    @objc
    func showApp(sender: AnyObject) {
        if popover.isShown {
            popover.performClose(nil)
        } else {
            if let button = statusItem.button {
                popover.show(
                    relativeTo: button.bounds,
                    of: button,
                    preferredEdge: .maxY
                )
                popover.contentViewController?.view.window?.makeKey()
            }
        }
    }
}
