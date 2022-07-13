//
//  NewsTableViewCellViewModel.swift
//  News App
//
//  Created by Andrii Tymoshchuk on 24.06.2022.
//

import Foundation
import UIKit

class NewsTableViewCellViewModel: NSObject, NSCoding {
    let title: String
    let desctiption: String
    let url: String
    let imgUrl: URL?
    var imageData: Data? = nil
    
    init(
        title: String,
        desctiption: String,
        url: String,
        imgUrl: URL?
    ) {
        self.title = title
        self.desctiption = desctiption
        self.url = url
        self.imgUrl = imgUrl
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(desctiption, forKey: "desctiption")
        coder.encode(url, forKey: "url")
        coder.encode(imgUrl, forKey: "imgUrl")
        coder.encode(imageData, forKey: "imageData")
    }
    
    required init?(coder: NSCoder) {
        title = coder.decodeObject(forKey: "title") as? String ?? ""
        desctiption = coder.decodeObject(forKey: "desctiption") as? String ?? ""
        url = coder.decodeObject(forKey: "url") as? String ?? ""
        imgUrl = coder.decodeObject(forKey: "imgUrl") as? URL ?? nil
        imageData = coder.decodeObject(forKey: "imageData") as? Data ?? nil
    }
}    
