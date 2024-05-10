//
//  ComicViewModel.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import Foundation

@Observable
class XKCDViewModel {
    let xkcdService: XKCDService
    
    var isFetching = false
    
    var errorString: String = ""
    
    var comicsCount: Int = 1
    
    var comicNum: Int = 1
    
    var comic: Comic? = nil
    
    var hasPrev: Bool { comicNum > 1 }
    
    var hasNext: Bool { comicNum < comicsCount }
    
    init(xkcdService: XKCDService) {
        self.xkcdService = xkcdService
    }
    
    func getPrevComic() async {
        if !hasPrev {
            return
        }
        await getComic(comicNum: comicNum - 1)
    }
    
    func getNextComic() async {
        if !hasNext {
            return
        }
        await getComic(comicNum: comicNum + 1)
    }
    
    func getComic(comicNum: Int) async {
        do {
            isFetching = true
            errorString = ""

            let newComic = try await xkcdService.getComic(comicNum: comicNum)

            self.comicNum = comicNum
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
            if newComic != nil {
                comicNum = newComic!.num
            }
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
            isFetching = true
            errorString = ""
            
            let _comicsCount = try await xkcdService.getComicsCount()
            if (_comicsCount != nil) {
                comicsCount = _comicsCount!
            }
        } catch {
            errorString = error.localizedDescription
            isFetching = false
            print(error)
        }
    }
}
