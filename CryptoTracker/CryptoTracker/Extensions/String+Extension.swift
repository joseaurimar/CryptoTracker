//
//  String+Extension.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 11/04/26.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
