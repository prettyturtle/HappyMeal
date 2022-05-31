//
//  UIView+.swift
//  HappyMeal
//
//  Created by yc on 2022/05/31.
//

import UIKit

extension UIView {
  func asImage() -> UIImage {
      let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image { rendererContext in
            self.layer.render(in: rendererContext.cgContext)
        }
    }
}
