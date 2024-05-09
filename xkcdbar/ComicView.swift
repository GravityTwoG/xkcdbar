//
//  ComicView.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import SwiftUI

struct ComicView: View {
    var comic: Comic;
    
    init(comic: Comic) {
        self.comic = comic
    }
    
    var body: some View {
        VStack {
            Link(
                "\(comic.num): \(comic.title)",
                destination: URL(string: "https://xkcd.com/\(comic.num)")!
            ).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            AsyncImage(
                url: comic.wrappedImgURL,
                content: { image in
                    image
                        .resizable()
                        .scaledToFit()
                },
                placeholder: {
                    ProgressView().padding(8)
                }
            )
        }.padding([.bottom], 8)
    }
}

#Preview {
    ComicView(comic: Comic(
        num: 1, link: "",
        day: "1", month: "1", year: "2006",
        news: "", title: "Barrel - Part 1", safeTitle: "Barrel - Part 1", transcript: "[[A boy sits in a barrel which is floating in an ocean.]]\nBoy: I wonder where I'll float next?\n[[The barrel drifts into the distance. Nothing else can be seen.]]\n{{Alt: Don't we all.}}",
        img: "https://imgs.xkcd.com/comics/barrel_cropped_(1).jpg", alt: "Don't we all."
    ))
}
