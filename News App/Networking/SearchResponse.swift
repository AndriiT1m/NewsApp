//
//  SearchResponse.swift
//  News App
//
//  Created by Andrii Tymoshchuk on 20.06.2022.
//

import Foundation
import UIKit

struct APIResponse: Codable {
    var articles: [Articles]
}

struct Source: Codable {
    var name: String
}

struct Articles: Codable {
    var source: Source
    var title: String
    var description: String?
    var url: String
    var urlToImage: String?
    var publishedAt: String
}

