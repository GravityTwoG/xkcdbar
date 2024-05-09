//
//  PopoverView.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import SwiftUI

struct PopoverView: View {
    @State var fetching = false
    
    @State var errorString: String = ""
    
    @State var comic: Comic? = nil
    
    @AppStorage("comicNum") var comicNum: Int = 1
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Spacer()
                
                if fetching {
                    ProgressView().padding(8)
                } else if let existingComic = comic {
                    VStack {
                        Link(
                            "\(existingComic.num): \(existingComic.title)",
                            destination: existingComic.wrappedImgURL
                        )
                        AsyncImage(
                            url: existingComic.wrappedImgURL,
                            content: { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            },
                            placeholder: {
                                ProgressView().padding(8)
                            }
                        )
                    }
                } else if errorString != "" {
                    Text(errorString)
                } else {
                    Text("Unknown error")
                }
                
                Spacer()
            }
                        
            Divider()
            
            HStack {
                Button("Prev") {
                    comicNum -= 1
                    getComic(comicNum: comicNum)
                }.disabled(fetching)
                
                Spacer()
            
                Button("random") {
                    getRandomComic()
                }.disabled(fetching)
                
                Spacer()
            
                Button("Next") {
                    comicNum += 1
                    getComic(comicNum: comicNum)
                }.disabled(fetching)
            }
            
            Divider()
            
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                Text("Quit")
                Spacer()
            }
            .buttonStyle(.plain)
        }
        .padding(8)
        .frame(
            idealWidth: 400, maxWidth: 500
        )
        .task {
            getComic(comicNum: comicNum)
        }
    }
    
    func getComic(comicNum: Int) {
        let url = URL(string: "https://xkcd.com/\(comicNum)/info.0.json")!
        
        fetching = true
        errorString = ""
        URLSession.shared.fetchData(at: url) { result in
            switch result {
            case .success(let newComic):
              comic = newComic
              fetching = false
            case .failure(let error):
              comic = nil
              errorString = error.localizedDescription
              fetching = false
              print(error)
            }
        }
    }
    
    func getRandomComic() {
        let url = URL(string: "https://xkcd.com/info.0.json")!
        
        fetching = true
        errorString = ""
        URLSession.shared.fetchData(at: url) { result in
            switch result {
            case .success(let newComic):
              let comicsCount = newComic.num
              comicNum = Int.random(in: 1..<comicsCount)
              getComic(comicNum: comicNum)
            case .failure(let error):
              errorString = error.localizedDescription
              fetching = false
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
