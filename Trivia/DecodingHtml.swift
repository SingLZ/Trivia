//
//  &quot;.swift
//  Trivia
//
//  Created by Lixing Zheng on 10/7/23.
//

import Foundation

extension String {
    func decodeHTML() -> String {
        guard let data = data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string
        } else {
            return self
        }
    }
}

