//
//  xkcdbarApp.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import SwiftUI

@main
struct XKCDBarApp: App {
    var body: some Scene {
        MenuBarExtra("XKCDBar", systemImage: "pencil.slash") {
            PopoverView(xkcdService: XKCDService(baseURL: "https://xkcd.com"))
        }.menuBarExtraStyle(.window)
    }
}
