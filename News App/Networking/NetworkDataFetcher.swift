//
//  NetworkDataFetcher.swift
//  News App
//
//  Created by Andrii Tymoshchuk on 20.06.2022.
//

import Foundation

class NetworkDataFetcher {
    private let networkService = NetworkService()
    
    func fetchNews(response: @escaping(Result<[Articles], Error>) -> Void) {
        networkService.request(complition: { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    response(.success(result.articles))
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(.failure(error))
            }
        })
    }
    
    func fetchSearchNews(with text: String, response: @escaping(Result<[Articles], Error>) -> Void) {
        networkService.requestSearch(with: text, complition: { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articals \(result.articles.count)")
                    response(.success(result.articles))
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(.failure(error))
            }
        })
    }
}
