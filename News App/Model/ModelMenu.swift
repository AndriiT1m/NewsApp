//
//  MenuModel.swift
//  Sushi App
//
//  Created by Andrii Tymoshchuk on 16.06.2022.
//  Copyright © 2022 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

enum MenuModel: Int {
    case Australia, Canada, Japan, Ukraine, UnitedStates, Germany, CzechRepublic, Italy, France, Mexico, China, Poland, Brazil, Sweden, India
    
    var description: String {
        switch self {
        case .Australia:
            return "Australia"
        case .Canada:
            return "Canada"
        case .Japan:
            return "Japan"
        case .Ukraine:
            return "Ukraine"
        case .UnitedStates:
            return "United States"
        case .Germany:
            return "Germany"
        case .CzechRepublic:
            return "Czech Republic"
        case .Italy:
            return "Italy"
        case .France:
            return "France"
        case .Mexico:
            return "Mexico"
        case .China:
            return "China"
        case .Poland:
            return "Poland"
        case .Brazil:
            return "Brazil"
        case .Sweden:
            return "Sweden"
        case .India:
            return "India"
        }
    }
}


