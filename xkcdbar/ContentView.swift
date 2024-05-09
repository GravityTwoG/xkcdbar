//
//  ContentView.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Image("xkcd-icon").resizable().scaledToFit().frame(width: 64, height: 64)
            Text("XKCDBar - xkcd comics in your menubar.")
            Text("Author: Marsel Abazbekov")
            
        }
    }
}

#Preview {
    ContentView()
}
