//
//  ContentView.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import SwiftUI

struct AboutView: View {
    
    var body: some View {
        VStack {
            Image("xkcd-icon").resizable().scaledToFit().frame(width: 128, height: 128)
            Text("XKCDBar - xkcd comics in your menu bar.").font(.system(size: 24))
            Text("Author: Marsel Abazbekov").font(.system(size: 24))
            Text("Github: https://github.com/gravitytwog/xkcdbar").font(.system(size: 24))
        }.frame(width: 600, height: 400)
    }
}

#Preview {
    AboutView()
}
