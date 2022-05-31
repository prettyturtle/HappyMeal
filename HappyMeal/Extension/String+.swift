//
//  String+.swift
//  HappyMeal
//
//  Created by yc on 2022/05/31.
//

import Foundation

extension String {
    var trimmed: String { self.replacingOccurrences(of: "-", with: "") }
    var translateHtml: String {
        guard let htmlTextData = self.data(using: .utf16),
              let translatedHtmlString = try? NSAttributedString(data: htmlTextData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil).string else { return "" }
        return translatedHtmlString
    }
}
