//
//  NetworkService.swift
//  News App
//
//  Created by Andrii Tymoshchuk on 20.06.2022.
//

import Foundation
import UIKit

class NetworkService  {

    private var country = "us"
    private var urlString: URL?
    private var urlSearch = "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=3f5b4bd2e1f249f186bc7c202a1e14b2&q="
    
    
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadCountry),
                                               name: NSNotification.Name("restatrt"),
                                               object: nil)
        loadCountry()
    }
    
    @objc private func loadCountry() {
        country = UserDefaults.standard.string(forKey: "country") ?? "us"
        urlString = URL(string: "https://newsapi.org/v2/top-headlines?country=\(country)&pageSize=50&apiKey=3f5b4bd2e1f249f186bc7c202a1e14b2")!
    }
    
    // запрос дані з нету
    func request(complition: @escaping (Result<Data, Error>) -> (Void)) {
        guard let url = urlString else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                complition(.failure(error))
                return
            }
            guard let data = data else { return }
            complition(.success(data))
        }.resume()
    }
    
    func requestSearch(with query: String, complition: @escaping (Result<Data, Error>) -> (Void)) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        let urlString = urlSearch + query
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                complition(.failure(error))
                return
            }
            
            guard let data = data else { return }
            complition(.success(data))
        }.resume()
    }
    
}
