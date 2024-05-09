//
//  PopoverView.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import SwiftUI

struct PopoverView: View {
    let xkcdService: XKCDService
    
    @State var isFetching = false
    
    @State var errorString: String = ""
    
    @State var comicsCount: Int = 1
    
    @State var comic: Comic? = nil
    
    @AppStorage("comicNum") var comicNum: Int = 1
    
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
                        comicNum -= 1
                        await getComic(comicNum: comicNum)
                    }
                }.disabled(isFetching || comicNum == 1)
            
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
                        comicNum += 1
                        await getComic(comicNum: comicNum)
                    }
                }.disabled(isFetching || comicNum == comicsCount)
            }.controlGroupStyle(.navigation)
            
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
        .frame(
            minWidth: 600, maxWidth: 800,
            maxHeight: 800
        )
        .task {
            await getComicsCount()
            await getComic(comicNum: comicNum)
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
        comicNum = Int.random(in: 1..<comicsCount)
        await getComic(comicNum: comicNum)
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
