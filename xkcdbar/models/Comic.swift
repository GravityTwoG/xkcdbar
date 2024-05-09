//
//  Comic.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import Foundation

struct Comic: Decodable {
    let num: Int
    let link: String
    
    let day: String
    let month: String
    let year: String
    
    let news: String
    
    let title: String
    let safeTitle: String
    let transcript: String
    
    let img: String
    let alt: String
    
    var wrappedImgURL: URL { URL(string: img)! }
}
