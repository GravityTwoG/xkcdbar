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
                        
            Divider()
            
            ControlGroup() {
                Button("Prev") {
                    Task {
                        await vm.getPrevComic()
                    }
                }.disabled(vm.isFetching || !vm.hasPrev)
            
                Button("Random") {
                    Task {
                        await vm.getRandomComic()
                    }
                }.disabled(vm.isFetching)
                
                Button("Current") {
                    Task {
                        await vm.getLastComic()
                    }
                }.disabled(vm.isFetching || vm.comicNum == vm.comicsCount)
            
                Button("Next") {
                    Task {
                        await vm.getNextComic()
                    }
                }.disabled(vm.isFetching || !vm.hasNext)
            }.controlGroupStyle(.navigation)
            
            Divider()
            
            ControlGroup {
                Button(action: {
                    openWindow(id: "about")
                }) {
                    Text("About")
                    Spacer()
                }
            }
            
            Divider()
            
            ControlGroup {
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Text("Quit")
                    Spacer()
                }
            }
        }
            .padding(8)
            .task {
                await vm.getComicsCount()
                await vm.getLastComic()
            }
            .focusable()
            .focused($isFocused)
            .focusEffectDisabled()
            .onKeyPress(.space, phases: [.down, .up]) { keyPress in
                if keyPress.phase == .down {
                    openWindow(id: "preview")
                }
                if keyPress.phase == .up {
                    let window = NSApplication.shared.windows.last
                    if window != nil && window?.title == "Preview"{
                        window?.close()
                    }
                }
            
                return .handled
            }
            .onAppear {
                isFocused = true
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
