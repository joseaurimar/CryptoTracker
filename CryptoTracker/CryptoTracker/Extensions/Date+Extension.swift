//
//  Date+Extension.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 10/04/26.
//

import Foundation

extension Date {
    init(stringDate: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: stringDate) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    func asShortDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
}
