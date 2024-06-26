//
//  PreviewView.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 10.05.2024.
//

import Foundation
import SwiftUI

struct PreviewView: View {
    @Environment(\.openWindow) var openWindow
    
    @FocusState private var isFocused: Bool
    
    @State var vm: XKCDViewModel
    
    init(xkcdViewModel: XKCDViewModel) {
        self.vm = xkcdViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            HStack(alignment: .center) {
                Spacer()
                
                if vm.isFetching && vm.comic == nil {
                    ProgressView().padding(8)
                } else if let existingComic = vm.comic {
                    ComicView(comic: existingComic).disabled(vm.isFetching)
                } else if vm.errorString != "" {
                    Text(vm.errorString)
                } else {
                    Text("Unknown error")
                }
                
                Spacer()
            }
            
            Spacer()
        }
            .padding(8)
            .focusable()
            .focused($isFocused)
            .focusEffectDisabled()
            .onAppear {
                isFocused = true
            }
            .onKeyPress(.space, phases: [.all]) { keyPress in
                if keyPress.phase == .down {
                    vm.popoverOpened = false
                    openWindow(id: "preview")
                }
                if keyPress.phase == .up {
                    let window = NSApplication.shared.windows.last
                    if window != nil && window?.title == "Preview" {
                        vm.popoverOpened = true
                        window?.close()
                    }
                }
            
                return .handled
            }
    }
}
