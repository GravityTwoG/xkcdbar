//
//  ComicURLSession.swift
//  xkcdbar
//
//  Created by Marsel Abazbekov on 09.05.2024.
//

import Foundation

extension URLSession {
  func fetchData(at url: URL, completion: @escaping (Result<Comic, Error>) -> Void) {
    self.dataTask(with: url) { (data, response, error) in
      if let error = error {
        completion(.failure(error))
      }

      if let data = data {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
            let comic = try decoder.decode(Comic.self, from: data)
          completion(.success(comic))
        } catch let decoderError {
          completion(.failure(decoderError))
        }
      }
    }.resume()
  }
}
