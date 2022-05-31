//
//  Icon.swift
//  HappyMeal
//
//  Created by yc on 2022/05/30.
//

import UIKit

enum Icon {
    case search
    case info
    case arrowRight
    case arrowLeft
    case share
    case house
    
    var image: UIImage? {
        switch self {
        case .search: return UIImage(systemName: "magnifyingglass")
        case .info: return UIImage(systemName: "info.circle")
        case .arrowRight: return UIImage(systemName: "arrow.right")
        case .arrowLeft: return UIImage(systemName: "arrow.left")
        case .share: return UIImage(systemName: "square.and.arrow.up")
        case .house: return UIImage(systemName: "house")
        }
    }
}
