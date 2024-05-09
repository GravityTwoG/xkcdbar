//
//  XKCDService.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import Foundation

class XKCDService {
    let baseURL: String
    
    let decoder: JSONDecoder
    
    init(baseURL: String) {
        self.baseURL = baseURL
        self.decoder = JSONDecoder()
        decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
    }
    
    func getComic(comicNum: Int) async throws -> Comic? {
        guard let url = URL(string: "\(baseURL)/\(comicNum)/info.0.json") else { return nil }
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let comic = try decoder.decode(Comic.self, from: data)
        
        return comic
    }
        
    func getLastComic() async throws -> Comic? {
        guard let url = URL(string: "\(baseURL)/info.0.json") else { return nil }
        let request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let comic = try decoder.decode(Comic.self, from: data)
        
        return comic
    }
    
    func getRandomComic(comicsCount: Int) async throws -> Comic? {
        let comicNum = Int.random(in: 1..<comicsCount)
        return try await getComic(comicNum: comicNum)
    }
    
    func getComicsCount() async throws -> Int? {
        let comic = try await getLastComic()
        
        if comic == nil {
            return nil
        }
        
        return comic!.num
    }
}
