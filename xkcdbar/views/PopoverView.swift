//
//  PopoverView.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import SwiftUI

struct PopoverView: View {
    @Environment(\.openWindow) var openWindow
    
    @FocusState private var isFocused: Bool
    
    @State var vm: XKCDViewModel
    
    init(xkcdViewModel: XKCDViewModel) {
        self.vm = xkcdViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ControlGroup() {
                Button("Prev") {
                    Task {
                        await vm.getPrevComic()
                    }
                }
                .disabled(vm.isFetching || !vm.hasPrev)
                .keyboardShortcut(.leftArrow)
            
                Button("Random") {
                    Task {
                        await vm.getRandomComic()
                    }
                }
                .disabled(vm.isFetching)
                .keyboardShortcut(.upArrow)
                
                Button("Current") {
                    Task {
                        await vm.getLastComic()
                    }
                }
                .disabled(vm.isFetching || vm.comicNum == vm.comicsCount)
                .keyboardShortcut(.downArrow)
            
                Button("Next") {
                    Task {
                        await vm.getNextComic()
                    }
                }
                .disabled(vm.isFetching || !vm.hasNext)
                .keyboardShortcut(.rightArrow)
            }
            .controlGroupStyle(.navigation)
            
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
            
            HStack() {
                Spacer()
                Text("Hold space bar to open in fullscreen")
                Spacer()
            }

            ControlGroup {
                Button("About") {
                    vm.popoverOpened = false
                    openWindow(id: "about")
                }.keyboardShortcut("I")
                
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }.keyboardShortcut("Q")
            }
            .controlGroupStyle(.navigation)
        }
            .padding(8)
            .task {
                await vm.getComicsCount()
                await vm.getLastComic()
            }
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

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverView(
            xkcdViewModel: XKCDViewModel(
                xkcdService: XKCDService(baseURL: "https://xkcd.com")
            )
        )
    }
}
