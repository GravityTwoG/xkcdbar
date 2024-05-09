//
//  PopoverView.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import SwiftUI

struct PopoverView: View {
    @Environment(\.openWindow) var openWindow
    
    let xkcdService: XKCDService
    
    @State var isFetching = false
    
    @State var errorString: String = ""
    
    @State var comicsCount: Int = 1
    
    @State var comic: Comic? = nil
    
    @FocusState private var isFocused: Bool
    
    init(xkcdService: XKCDService) {
        self.xkcdService = xkcdService
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            HStack(alignment: .center) {
                Spacer()
                
                if isFetching && comic == nil {
                    ProgressView().padding(8)
                } else if let existingComic = comic {
                    ComicView(comic: existingComic).disabled(isFetching)
                } else if errorString != "" {
                    Text(errorString)
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
                        XKCDBarApp.comicNum -= 1
                        await getComic(comicNum: XKCDBarApp.comicNum)
                    }
                }.disabled(isFetching || XKCDBarApp.comicNum == 1)
            
                Button("Random") {
                    Task {
                        await getRandomComic()
                    }
                }.disabled(isFetching)
                
                Button("Current") {
                    Task {
                        await getLastComic()
                    }
                }.disabled(isFetching)
            
                Button("Next") {
                    Task {
                        XKCDBarApp.comicNum += 1
                        await getComic(comicNum: XKCDBarApp.comicNum)
                    }
                }.disabled(isFetching || XKCDBarApp.comicNum == comicsCount)
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
                await getComicsCount()
                await getComic(comicNum: XKCDBarApp.comicNum)
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
    
    func getComic(comicNum: Int) async {
        do {
            isFetching = true
            errorString = ""

            let newComic = try await xkcdService.getComic(comicNum: comicNum)

            comic = newComic
            isFetching = false
        } catch {
            comic = nil
            errorString = error.localizedDescription
            isFetching = false
            print(error)
        }
    }
    
    func getRandomComic() async {
        XKCDBarApp.comicNum = Int.random(in: 1..<comicsCount)
        await getComic(comicNum: XKCDBarApp.comicNum)
    }
    
    func getLastComic() async {
        do {
            isFetching = true
            errorString = ""

            let newComic = try await xkcdService.getLastComic()

            comic = newComic
            isFetching = false
        } catch {
            comic = nil
            errorString = error.localizedDescription
            isFetching = false
            print(error)
        }
    }
    
    func getComicsCount() async {
        do {
            let _comicsCount = try await xkcdService.getComicsCount()
            if (_comicsCount != nil) {
                comicsCount = _comicsCount!
            }
        } catch {
            print(error)
        }
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverView(
            xkcdService: XKCDService(baseURL: "https://xkcd.com")
        )
    }
}
