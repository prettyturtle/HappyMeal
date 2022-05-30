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
    
    var image: UIImage? {
        switch self {
        case .search: return UIImage(systemName: "magnifyingglass")
        case .info: return UIImage(systemName: "info.circle")
        case .arrowRight: return UIImage(systemName: "arrow.right")
        case .arrowLeft: return UIImage(systemName: "arrow.left")
        }
    }
}
