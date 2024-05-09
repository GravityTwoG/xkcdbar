//
//  PopoverView.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import SwiftUI

struct PopoverView: View {
    @State var isFetching = false
    
    @State var errorString: String = ""
    
    @State var comicsCount: Int = 1
    
    @State var comic: Comic? = nil
    
    @AppStorage("comicNum") var comicNum: Int = 1
    
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
                    comicNum -= 1
                    getComic(comicNum: comicNum)
                }.disabled(isFetching || comicNum == 1)
            
                Button("Random") {
                    getRandomComic()
                }.disabled(isFetching)
                
                Button("Current") {
                    getLastComic()
                }.disabled(isFetching)
            
                Button("Next") {
                    comicNum += 1
                    getComic(comicNum: comicNum)
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
            getComicsCount()
            getComic(comicNum: comicNum)
        }
    }
    
    func getComic(comicNum: Int) {
        let url = URL(string: "https://xkcd.com/\(comicNum)/info.0.json")!
        
        isFetching = true
        errorString = ""
        URLSession.shared.fetchData(at: url) { result in
            switch result {
                case .success(let newComic):
                  comic = newComic
                  isFetching = false
                case .failure(let error):
                  comic = nil
                  errorString = error.localizedDescription
                  isFetching = false
                  print(error)
            }
        }
    }
    
    func getRandomComic() {
        comicNum = Int.random(in: 1..<comicsCount)
        getComic(comicNum: comicNum)
    }
    
    func getLastComic() {
        let url = URL(string: "https://xkcd.com/info.0.json")!
        
        isFetching = true
        errorString = ""
        URLSession.shared.fetchData(at: url) { result in
            switch result {
                case .success(let newComic):
                  comic = newComic
                  isFetching = false
                case .failure(let error):
                  errorString = error.localizedDescription
                  isFetching = false
                  print(error)
            }
        }
    }
    
    func getComicsCount() {
        let url = URL(string: "https://xkcd.com/info.0.json")!
        
        isFetching = true
        errorString = ""
        URLSession.shared.fetchData(at: url) { result in
            switch result {
                case .success(let newComic):
                  comicsCount = newComic.num
                case .failure(let error):
                  errorString = error.localizedDescription
                  isFetching = false
                  print(error)
            }
        }
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverView()
    }
}
